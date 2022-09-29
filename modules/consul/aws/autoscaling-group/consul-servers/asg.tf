resource "aws_launch_configuration" "launch_configuration" {
  for_each = var.datacenter_config

  name_prefix   = "${var.deployment_id}-${each.key}"
  image_id      = var.ami_consul_server_asg
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  key_name      = var.key_pair_key_name
  security_groups = [var.security_group_ssh_id["${each.key}"], var.security_group_consul_id["${each.key}"], var.security_group_consul_wan_id["${each.key}"]]
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo cp /var/tmp/consul-ent-license.hclic /opt/consul/config/consul-ent-license.hclic
                  sudo cp /var/tmp/consul-config.json /opt/consul/config/consul-config.json
                  /opt/consul/bin/run-consul --server --datacenter ${each.key} --cluster-tag-key consul-cluster --cluster-tag-value ${var.deployment_id}-${each.key}
                  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  for_each = aws_launch_configuration.launch_configuration

  name_prefix               = "${var.deployment_id}-${each.key}"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  launch_configuration      = each.value.name
  vpc_zone_identifier       = var.private_subnet_ids["${each.key}"]

  tag {
      key                 = "consul-cluster"
      value               = "${var.deployment_id}-${each.key}"
      propagate_at_launch = true
    }
  tag {
      key                 = "consul-datacenter"
      value               = "${each.key}"
      propagate_at_launch = true
    }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}