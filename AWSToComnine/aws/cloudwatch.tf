resource "aws_cloudwatch_log_group" "app1" {
  name              = "/aws/eks/${var.prefix}/cluster"
  retention_in_days = 7
}