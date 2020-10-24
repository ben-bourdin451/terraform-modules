# EKS worker group

## About This Module

This module creates an EKS worker group which can be assigned to an existing EKS cluster.

## Usage

Example:

``` terraform
module "general" {
  source = "github.com/ben-bourdin451/terraform-modules//aws/eks/worker_group"

  # Node options
  name             = "general"
  cluster_ca       = "${module.eks.cluster_ca}"
  cluster_name     = "${module.eks.cluster_name}"
  cluster_version  = "${module.eks.cluster_version}"
  cluster_endpoint = "${module.eks.cluster_endpoint}"
  instance_profile = "${module.eks.worker_instance_profile}"
  security_group   = "${module.eks.worker_security_group_id}"

  # Kublet options
  node_labels = [
    "key=value",
    "group=general",
  ]

  # Auto Scaling Group
  max_size            = 5
  min_size            = 1
  desired_capacity    = 3
  volume_size         = 20
  ebs_optimized       = true
  autoscaling_enabled = true
  instance_type       = "t3.medium"

  # Networking options
  vpc_id     = "${data.aws_vpc.kubernetes.id}"
  subnet_ids = "${data.aws_subnet_ids.public.ids}"
}
```

