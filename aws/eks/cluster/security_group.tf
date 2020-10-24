# ------------------------------------------
# Cluster
# ------------------------------------------
resource "aws_security_group" "cluster" {
  vpc_id      = var.vpc_id
  name        = "eks-cluster-${var.cluster_name}"
  description = "Security group for the EKS cluster: ${var.cluster_name}."

  tags = merge(
    local.common_tags,
    {
      "Name" = var.cluster_name
    },
  )
}

resource "aws_security_group_rule" "egress" {
  count             = var.deployed ? 1 : 0
  security_group_id = aws_security_group.cluster.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all outbound traffic from the cluster."
}

resource "aws_security_group_rule" "https_node_ingress" {
  count             = var.deployed ? 1 : 0
  security_group_id = aws_security_group.cluster.id
  type              = "ingress"

  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_node.id

  description = "Allow pods to communicate with the EKS cluster API."
}

# ------------------------------------------
# Worker Nodes
# ------------------------------------------
resource "aws_security_group" "worker_node" {
  name        = local.worker_node
  vpc_id      = var.vpc_id
  description = "Security group for the worker nodes in the ${var.cluster_name} EKS cluster."

  tags = merge(
    local.common_tags,
    {
      "Name" = local.worker_node
    },
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
  )
}

resource "aws_security_group_rule" "node_egress" {
  count             = var.deployed ? 1 : 0
  security_group_id = aws_security_group.worker_node.id
  type              = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all outbound traffic from the worker nodes."
}

resource "aws_security_group_rule" "node_ingress_self" {
  count             = var.deployed ? 1 : 0
  security_group_id = aws_security_group.worker_node.id
  type              = "ingress"

  from_port = 0
  to_port   = 65535
  protocol  = "-1"
  self      = true

  description = "Allow worker nodes to communicate with each other."
}

resource "aws_security_group_rule" "nodes_ingress_cluster" {
  count             = var.deployed ? 1 : 0
  security_group_id = aws_security_group.worker_node.id
  type              = "ingress"

  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id

  description = "Allow nodes Kubelets and pods to receive communication from the cluster control plane."
}

resource "aws_security_group_rule" "nodes_ingress_cluster_https" {
  count             = var.deployed ? 1 : 0
  security_group_id = aws_security_group.worker_node.id
  type              = "ingress"

  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id

  description = "Allow the cluster control plane to communicate with pods running extension API servers."
}
