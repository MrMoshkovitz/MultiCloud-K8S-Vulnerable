data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "src/sls_app/sls_full"
  output_path = "src/sls_app/output/sls_lambda.zip"
  }





resource "aws_lambda_function" "serverless_app" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.prefix}_serverless_app"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.handler"
  runtime       = "nodejs14.x"
  memory_size   = 256

  environment {
    variables = {
        USER = "admin"
        PASSWORD = "admin"
        API_KRY = "123456789"
    }
  }
}




resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.prefix}_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "app.handler"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  runtime          = "nodejs14.x"
  memory_size      = 128
  timeout          = 10

  environment {
    variables = {
        NODE_ENV = "production"
        ACCOUNT_ID = "123456789"
        REGION = "us-east-1"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment
  ]
}