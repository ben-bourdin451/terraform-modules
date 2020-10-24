# ------------------------------------------
# EKS Cluster
# ------------------------------------------
resource "aws_eks_cluster" "cluster" {
  count = var.deployed ? 1 : 0

  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = var.public_endpoint
    endpoint_private_access = var.private_endpoint
    security_group_ids      = [aws_security_group.cluster.id]
  }

  depends_on = [
    aws_cloudwatch_log_group.cluster,
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_service_policy,
  ]
}

# ------------------------------------------
# Cloudwatch Logs
# ------------------------------------------
resource "aws_cloudwatch_log_group" "cluster" {
  name = "/aws/eks/${var.cluster_name}/cluster"

  retention_in_days = var.cloudwatch_retention

  tags = merge(
    local.common_tags,
    {
      "Name" = var.cluster_name
    },
  )
}
