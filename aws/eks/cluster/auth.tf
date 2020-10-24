# ------------------------------------------
# Generate AWS Auth config file
# ------------------------------------------
data "template_file" "config_map_aws_auth" {
  template = file("${path.module}/templates/auth.yaml")

  vars = {
    roles        = join("", data.template_file.map_roles.*.rendered)
    accounts     = join("", data.template_file.map_accounts.*.rendered)
    worker_nodes = join("", data.template_file.map_worker_nodes.*.rendered)
  }
}

# ------------------------------------------
# Add role authorizations
# ------------------------------------------
data "template_file" "map_roles" {
  count    = length(var.map_roles)
  template = file("${path.module}/templates/aws-roles.yaml")

  vars = {
    role_arn = var.map_roles[count.index].role_arn
    username = var.map_roles[count.index].username
    group    = var.map_roles[count.index].group
  }
}

# ------------------------------------------
# Add account authorizations
# ------------------------------------------
data "template_file" "map_accounts" {
  count    = length(var.map_accounts)
  template = file("${path.module}/templates/aws-accounts.yaml")

  vars = {
    account_number = element(var.map_accounts, count.index)
  }
}

# ------------------------------------------
# Add worker node authorization
# ------------------------------------------
data "template_file" "map_worker_nodes" {
  template = file("${path.module}/templates/aws-workers.yaml")

  vars = {
    role_arn = aws_iam_role.worker_node.arn
  }
}
