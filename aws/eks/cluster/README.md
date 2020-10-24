# EKS cluster

## About This Module

This module creates an empty EKS cluster with the necessary worker node configuration. Worker nodes must be created and assigned separately.

## Usage

Example:

``` terraform
module "eks" {
  source = "github.com/ben-bourdin451/terraform-modules//aws/eks/cluster"

  # Cluster options
  cluster_name     = "dev"
  private_endpoint = true
  cluster_version  = "1.12"

  cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  # Networking options
  vpc_id     = "${data.aws_vpc.kubernetes.id}"
  subnet_ids = "${data.aws_subnet_ids.all.ids}"

  # Auth
  map_accounts       = [
    "123456789012",
  ]
  
  map_roles          = [
    {
      role_arn = var.aws_role
      username = var.username
      group    = "system:masters"
    },
  ]
}
```

## After apply

After applying the infrastructure, the following commands must be run:

1. Update kubectl config via aws cli:  
   `aws eks update-kubeconfig --name <cluster_name> --profile <profile_name>`
2. Enabling worker nodes to connect to the cluster:  
  `mkdir -p auth && tf output auth_config > auth/aws-auth-cm.yaml && kubectl apply -f auth/aws-auth-cm.yaml`

## Dashboard

[AWS EKS Dashboard tutorial](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html)

## Todo

- [] dynamic ingress rules
- [] dynamic egress rules
