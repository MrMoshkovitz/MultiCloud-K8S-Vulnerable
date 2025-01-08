resource "aws_ecr_repository" "gm-vulny" {
  name = "${var.prefix}-repository"
}


resource "aws_ecr_repository_policy" "iam_policy_ecr" {
  repository = aws_ecr_repository.gm-vulny.name
  policy     = data.aws_iam_policy_document.iam_policy_ecr.json
}