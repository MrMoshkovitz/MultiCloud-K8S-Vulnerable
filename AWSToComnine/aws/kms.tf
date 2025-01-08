# Insecure KMS key policy 

# KMS key policy allows access from all principals in the account that are authorized to use the key.
resource "aws_kms_key" "kms_key" {
  description             = "KMS key 1"
  deletion_window_in_days = 10

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
POLICY
}


# Insecure KMS key policy
