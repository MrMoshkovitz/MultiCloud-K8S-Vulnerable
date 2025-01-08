
#*#################################################################################
#?                                      App1 - Vulny
#*#################################################################################

#?                                      App1 - Vulny
#*#################################################################################
#?                                      S3 Bucket
#*#################################################################################
#?                                     = S3 Bucket
resource "aws_s3_bucket" "app1" {
    bucket        = lower("${var.prefix}1-s3-bucket-gm")
    force_destroy        = true
    object_lock_enabled = false
    tags = {
      "User" = "admin"
      "Pasword" = "password"
    }
}

#?                                      S3 Bucket - Public Access Block
resource "aws_s3_bucket_public_access_block" "app12" {
    bucket = aws_s3_bucket.app1.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
 }

#?                                      S3 Bucket - ACL
resource "aws_s3_bucket_acl" "app1" {
    depends_on = [
        aws_s3_bucket_public_access_block.app1
    ]    
    bucket = aws_s3_bucket.app1.id
    acl    = "public-read-write"
}
#?                                      S3 Bucket - Public Access Block
resource "aws_s3_bucket_public_access_block" "app1" {
    bucket = aws_s3_bucket.app1.id
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

#?                                      S3 Bucket - CORS
resource "aws_s3_bucket_cors_configuration" "app1" {
    bucket = aws_s3_bucket.app1.id
    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "PUT", "POST", "HEAD", "DELETE"]
        allowed_origins = ["*"]
        expose_headers  = [
            "ETag",
            "x-amz-server-side-encryption",
            "x-amz-request-id",
            "x-amz-id-2",
            "x-amz-version-id",
            "x-amz-delete-marker",
            "x-amz-tagging",
            "x-amz-storage-class",
            "x-amz-website-redirect-location",
            "x-amz-restore",
            "x-amz-restore-output-path",
            "x-amz-copy-source-version-id",
            "x-amz-pre-signed-content-md5",
            "x-amz-encrypted"
        ]        
        max_age_seconds = 3000
    }
}

resource "aws_s3_bucket_versioning" "app1" {
    bucket = aws_s3_bucket.app1.id
    versioning_configuration {
        status = "Disabled"
    }
  }


data "aws_iam_policy_document" "app12" {
  statement {
    actions = [
      "*"
    ]
    resources = [
      "*"
    ]
    effect = "Allow"
  }
}


resource "aws_s3_bucket" "app21" {
    bucket = "${var.prefix}2-s3-bucket-gm"
    force_destroy        = true
    object_lock_enabled = false
}

resource "aws_s3_bucket_policy" "app21" {
  bucket = aws_s3_bucket.app21.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:*"
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.app21.arn}/*"
        ]
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}

#     policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "PublicReadGetObject",
#             "Effect": "Allow",
#             "Principal": "*",
#             "Action": [
#                 "s3:GetObject"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::${aws_s3_bucket.app1.id}/*"
#             ]
#         }
#     ]


#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject"
#         ]
#         Effect   = "Allow"
#         Resource = "${aws_s3_bucket.app1.arn}/*"
#         Principal = "*"
#       }
#     ]
#   })
# }
















