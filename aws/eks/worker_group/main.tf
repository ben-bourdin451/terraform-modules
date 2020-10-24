# ------------------------------------------------------
# Data source: Amazon EKS Worker Node AMI
# ------------------------------------------------------
data "aws_ami" "eks_worker_node" {
  count       = var.deployed ? 1 : 0
  owners      = ["602401143452"] # Amazon
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v${var.ami_release_date}"]
  }

  filter {
    name   = "description"
    values = ["*AmazonLinux2*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# ------------------------------------------------------
# Data source: EKS Worker Node User data script
#
# EKS currently documents this required userdata for EKS node nodes
# to properly configure Kubernetes applications on the EC2 instance.
# More information:
# https://docs.aws.amazon.com/eks/latest/userguide/launch-nodes.html
# https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
# ------------------------------------------------------
data "template_file" "bootstrap" {
  count    = var.deployed ? 1 : 0
  template = file("${path.module}/templates/bootstrap.sh")

  vars = {
    cluster_name          = var.cluster_name
    certificate_authority = var.cluster_ca
    endpoint              = var.cluster_endpoint
    kubelet_extra_args    = local.kubelet_args
    pre_bootstrap_script  = var.pre_bootstrap_script
    bootstrap_extra_args  = var.bootstrap_extra_args
    post_bootstrap_script = var.post_bootstrap_script
  }
}

# ------------------------------------------------------
# Launch template
# ------------------------------------------------------
resource "aws_launch_template" "worker_node" {
  count = var.deployed ? 1 : 0

  name                                 = local.name
  description                          = "Launch template for the ${var.cluster_name} cluster's ${var.name} worker nodes."
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"
  key_name                             = var.key_pair
  instance_type                        = var.instance_type
  ebs_optimized                        = var.ebs_optimized
  image_id                             = data.aws_ami.eks_worker_node[0].id
  user_data                            = base64encode(data.template_file.bootstrap[0].rendered)

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = var.instance_profile
  }

  vpc_security_group_ids = concat(
    var.security_group,
    var.additional_security_group_ids,
    data.aws_security_group.office_and_vpn.id,
  )

  block_device_mappings {
    device_name = data.aws_ami.eks_worker_node[0].root_device_name

    ebs {
      volume_size = var.volume_size
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      EKS       = "true"
      Terraform = "true"
      Group     = var.name
    }
  }
}

# ------------------------------------------------------
# Auto Scaling Group
# ------------------------------------------------------
resource "aws_autoscaling_group" "worker_nodes" {
  count = var.deployed ? 1 : 0

  name                = local.name
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    version = "$Latest"
    id      = aws_launch_template.worker_node[0].id
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }

  tags = concat(
    [
      {
        "key"                 = "Terraform"
        "value"               = "true"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Name"
        "value"               = "EKS Worker node - ${var.name} (Cluster: ${var.cluster_name})"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "kubernetes.io/cluster/${var.cluster_name}"
        "value"               = "owned"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${var.autoscaling_enabled ? "enabled" : "disabled"}"
        "value"               = "true"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
        "value"               = ""
        "propagate_at_launch" = true
      },
      {
        "key"                 = "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"
        "value"               = "${var.volume_size}Gi"
        "propagate_at_launch" = true
      },
    ],
    null_resource.additional_tags_as_list_of_maps.*.triggers,
  )
}

resource "null_resource" "additional_tags_as_list_of_maps" {
  count = var.deployed ? length(keys(var.additional_tags)) : 0

  triggers = {
    "key"                 = element(keys(var.additional_tags), count.index)
    "value"               = trimspace(element(values(var.additional_tags), count.index))
    "propagate_at_launch" = "true"
  }
}
