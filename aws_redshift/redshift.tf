resource "aws_redshift_cluster" "default" {
  cluster_identifier = var.obj_prefix
  database_name      = "redshift_test_db"
  master_username    = "main"
  master_password    = "main"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.subnet_group.id
  skip_final_snapshot = true
  iam_roles = [aws_iam_role.role.arn]
}