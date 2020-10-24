# ------------------------------------------
# Cluster
# ------------------------------------------
resource "aws_iam_role" "cluster" {
  name = "eks_cluster_${var.cluster_name}"

  assume_role_policy = file("${path.module}/policies/ec2_assume_role.json")

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

# ------------------------------------------
# Worker nodes
# ------------------------------------------
resource "aws_iam_role" "worker_node" {
  name = local.worker_node

  assume_role_policy = file("${path.module}/policies/ec2_assume_role.json")

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker_node.name
}

resource "aws_iam_role_policy" "node_autoscaler" {
  name   = "${var.cluster_name}_node_autoscaler"
  role   = aws_iam_role.worker_node.name
  policy = file("${path.module}/policies/node_autoscaler.json")
}

resource "aws_iam_role_policy" "ingress_controller" {
  name   = "${var.cluster_name}_ingress_controller"
  role   = aws_iam_role.worker_node.name
  policy = file("${path.module}/policies/ingress_controller.json")
}

resource "aws_iam_instance_profile" "worker_node" {
  name = aws_iam_role.worker_node.name
  role = aws_iam_role.worker_node.name
}
