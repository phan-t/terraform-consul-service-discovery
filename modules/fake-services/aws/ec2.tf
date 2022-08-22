locals {
  key_pair_private_key = file("${path.root}/tphan-hashicorp-aws.pem")
  fake_services = flatten([
    for dc, dcs in var.datacenter_config : [
      for fake_service_name in dcs.fake_service_names : {
        dc   = dc
        name = fake_service_name
      }
    ]
  ])
}

resource "aws_instance" "fake-services" {
  for_each = {
    for fake-service in local.fake_services : "${fake-service.dc}-${fake-service.name}" => fake-service
  }

  ami             = var.ami_fake_service
  instance_type   = "t3.micro"
  key_name        = var.key_pair_key_name
  subnet_id       = element(var.public_subnet_ids["${each.value.dc}"], 1)
  security_groups = [var.security_group_ssh_id["${each.value.dc}"], var.security_group_consul_id["${each.value.dc}"], var.security_group_fake_service_id["${each.value.dc}"]]

  tags = {
    owner = var.owner
    TTL = var.ttl
  }
}

resource "local_file" "consul-client-config" {
  for_each = aws_instance.fake-services

  content = templatefile("${path.root}/examples/templates/consul-client-config.json", {
    datacenter            = substr(each.key, 0, 3)
    server_private_fqdn   = var.consul_server_private_fqdn["${substr(each.key, 0, 3)}"]
    serf_lan_port         = var.consul_serf_lan_port
    node_name             = each.value.private_dns
    })
  filename = "${path.module}/configs/client-config-${each.key}.json.tmp"
  
  depends_on = [
    aws_instance.fake-services
  ]
}

resource "local_file" "consul-service-register" {
  for_each = aws_instance.fake-services
  
  content = templatefile("${path.root}/examples/templates/consul-service-register.json", {
    service_name          = substr(each.key, 4, 20)
    tags                  = "fake-service"
    port                  = 9090
    })
  filename = "${path.module}/configs/consul-service-register-${each.key}.json.tmp"
  
  depends_on = [
    aws_instance.fake-services
  ]
}

resource "local_file" "fake-service-config" {
  for_each = aws_instance.fake-services

  content = templatefile("${path.root}/examples/templates/fake-service.config", {
    upstream_uris         = ""
    name                  = substr(each.key, 4, 20)
    })
  filename = "${path.module}/configs/fake-service-${each.key}.config.tmp"
  
  depends_on = [
    aws_instance.fake-services
  ]
}

resource "null_resource" "consul-client-config" {
  for_each = aws_instance.fake-services

  connection {
    host          = each.value.public_dns
    user          = "ubuntu"
    agent         = false
    private_key   = local.key_pair_private_key
  }

  provisioner "file" {
    source      = "${path.module}/configs/client-config-${each.key}.json.tmp"
    destination = "/tmp/client-config.json"
  }

  provisioner "file" {
    source      = "${path.root}/consul-ent-license.hclic"
    destination = "/tmp/consul-ent-license.hclic"
  }

  provisioner "file" {
    source      = "${path.module}/configs/consul-service-register-${each.key}.json.tmp"
    destination = "/tmp/consul-service-register.json"
  }

  provisioner "file" {
    source      = "${path.module}/configs/fake-service-${each.key}.config.tmp"
    destination = "/tmp/fake-service.config"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/client-config.json /opt/consul/config/default.json",
      "sudo cp /tmp/consul-ent-license.hclic /opt/consul/bin/consul-ent-license.hclic",
      "sudo cp /tmp/consul-service-register.json /opt/consul/config/consul-service-register.json",
      "sudo cp /tmp/fake-service.config /opt/fake-service/config/fake-service.config",
      "sudo /opt/consul/bin/run-consul --client --skip-consul-config",
      "sudo /opt/fake-service/bin/run-fake-service",
      "sudo systemctl start fake-service"
    ]
  }

  depends_on = [
    local_file.consul-client-config,
    local_file.consul-service-register,
    local_file.fake-service-config
  ]
}