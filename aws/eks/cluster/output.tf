output "worker_iam_role" {
  value = aws_iam_role.worker_node.id
}

output "worker_iam_role_arn" {
  value = aws_iam_role.worker_node.arn
}

output "worker_instance_profile" {
  value = aws_iam_instance_profile.worker_node.id
}

output "worker_instance_profile_arn" {
  value = aws_iam_instance_profile.worker_node.arn
}

output "worker_security_group" {
  value = aws_security_group.worker_node.name
}

output "worker_security_group_id" {
  value = aws_security_group.worker_node.id
}

output "auth_config" {
  value = data.template_file.config_map_aws_auth.rendered
}

output "cluster_name" {
  value = element(concat(aws_eks_cluster.cluster.*.id, [""]), 0)
}

output "cluster_arn" {
  value = element(concat(aws_eks_cluster.cluster.*.arn, [""]), 0)
}

output "cluster_version" {
  value = element(concat(aws_eks_cluster.cluster.*.version, [""]), 0)
}

output "cluster_endpoint" {
  value = element(concat(aws_eks_cluster.cluster.*.endpoint, [""]), 0)
}

output "platform_version" {
  value = element(concat(aws_eks_cluster.cluster.*.platform_version, [""]), 0)
}

output "cluster_ca" {
  value = aws_eks_cluster.cluster[0].certificate_authority[0].data
}
