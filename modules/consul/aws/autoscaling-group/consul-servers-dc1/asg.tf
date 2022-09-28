data "aws_availability_zones" "available" {}

resource "aws_autoscaling_group" "autoscaling_group" {
  name_prefix               = "${var.deployment_id}-dc1"
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  # availability_zones        = data.aws_availability_zones.available.names
  vpc_zone_identifier       = var.private_subnet_ids["dc1"]
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  # desired_capacity          = var.asg_min_size
  # termination_policies      = [var.termination_policies]

  health_check_type         = "EC2"
  # health_check_grace_period = var.health_check_grace_period
  # wait_for_capacity_timeout = var.wait_for_capacity_timeout
  # service_linked_role_arn   = var.service_linked_role_arn

  # enabled_metrics = var.enabled_metrics

  # protect_from_scale_in = var.protect_from_scale_in

  tag {
      key                 = "name"
      value               = "${var.deployment_id}-dc1"
      propagate_at_launch = true
    }

  tag {
      key                 = "consul-cluster"
      value               = "${var.deployment_id}-dc1"
      propagate_at_launch = true
    }

  dynamic "initial_lifecycle_hook" {
    for_each = var.lifecycle_hooks

    content {
      name                    = initial_lifecycle_hook.key
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      lifecycle_transition    = initial_lifecycle_hook.value.lifecycle_transition
      notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
    }
  }

  lifecycle {
    # As of AWS Provider 3.x, inline load_balancers and target_group_arns
    # in an aws_autoscaling_group take precedence over attachment resources.
    # Since the consul-cluster module does not define any Load Balancers,
    # it's safe to assume that we will always want to favor an attachment
    # over these inline properties.
    #
    # For further discussion and links to relevant documentation, see
    # https://github.com/hashicorp/terraform-aws-vault/issues/210
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix   = "${var.deployment_id}-"
  image_id      = var.ami_consul_server_asg
  instance_type = var.instance_type
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo cp /var/tmp/consul-ent-license.hclic /opt/consul/config/consul-ent-license.hclic
                  sudo cp /var/tmp/consul-config-license.json /opt/consul/config/consul-config-license.json
                  /opt/consul/bin/run-consul --server --cluster-tag-key consul-cluster --cluster-tag-value ${var.deployment_id}-dc1
                  EOF
  # spot_price    = var.spot_price

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  key_name      = var.key_pair_key_name

  security_groups = [var.security_group_ssh_id["dc1"], var.security_group_consul_id["dc1"]]

  # placement_tenancy           = var.tenancy
  # associate_public_ip_address = var.associate_public_ip_address

  # ebs_optimized = var.root_volume_ebs_optimized

  # root_block_device {
  #   volume_type           = var.root_volume_type
  #   volume_size           = var.root_volume_size
  #   delete_on_termination = var.root_volume_delete_on_termination
  #   encrypted             = var.root_volume_encrypted
  # }

  lifecycle {
    create_before_destroy = true
  }
}