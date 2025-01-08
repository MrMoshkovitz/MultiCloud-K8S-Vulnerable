#*#################################################################################
#?                                      IAM Roles for EKS
#*#################################################################################

data aws_iam_policy_document "iam_policy_eks" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node_role" {
  name = "High-Privilege-Policy-Admin2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com", "eks.amazonaws.com"]
        }
      }
    ]
  })
}

resource aws_iam_role "iam_for_eks" {
  name               = lower("gm-iam-for-eks")
  assume_role_policy = data.aws_iam_policy_document.iam_policy_eks.json
}

resource aws_iam_role_policy_attachment "policy_attachement_eks1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_for_eks.name
}

resource aws_iam_role_policy_attachment "policy_attachement_eks2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam_for_eks.name
}

resource aws_iam_role_policy_attachment "policy_attachement_eks_app1_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_for_eks.name
}
resource aws_iam_role_policy_attachment "policy_attachement_eks_app1_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_for_eks.name
}
resource aws_iam_role_policy_attachment "policy_attachement_eks_app1_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_for_eks.name
}





#*#################################################################################
#?                                      IAM ROles for ECr
#*#################################################################################
data "aws_iam_policy_document" "iam_policy_ecr" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}



#*#################################################################################
#?                                      IAM ROles for ECS
#*#################################################################################


resource "aws_iam_role" "iam_for_ecs" {
  name                 = "${var.prefix}-role1"
  path                 = "/"
  permissions_boundary = aws_iam_policy.policy_boundary_ecs.arn
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "policy_attachement_ecs1" {
  role       = aws_iam_role.iam_for_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
resource "aws_iam_role_policy_attachment" "policy_attachement_ecs2" {
  role       = aws_iam_role.iam_for_ecs.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "policy_attachement_ecs3" {
  role       = aws_iam_role.iam_for_ecs.name
  policy_arn = aws_iam_policy.policy_ecs.arn
}

resource "aws_iam_policy" "policy_ecs" {
  name = "${var.prefix}-ecs-policy-1"
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "ssm:*",
          "ssmmessages:*",
          "ec2:RunInstances",
          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DeleteVolume"      
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "Pol1"
      }
    ],
    "Version" : "2012-10-17"
  })
}

resource "aws_iam_policy" "policy_boundary_ecs" {
  name = "${var.prefix}-ecs-policy-boundary"
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "iam:List*",
          "iam:Get*",
          "iam:PassRole",
          "iam:PutRole*",
          "ssm:*",
          "ssmmessages:*",
          "ec2:RunInstances",
          "ec2:Describe*",
          "ecs:*",
          "ecr:*",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "Pol1"
      }
    ],
    "Version" : "2012-10-17"
  })
}

resource "aws_iam_instance_profile" "iam_profile_ec2_1" {
  name = "EC2-Profile-1"
  path = "/"
  role = aws_iam_role.iam_role_ec2_1.id
}
resource "aws_iam_role" "iam_role_ec2_1" {
  name = "EC2-Role-1"
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}



resource "aws_iam_policy" "iam_admin_policy_ec2_1" {
  name = "EC2-Admin-Policy-1"
  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "*"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "Policy1"
      }
    ],
    "Version" : "2012-10-17"
  })
}



resource "aws_iam_role_policy_attachment" "policy_role_attachment_ec2_1" {
  role       = aws_iam_role.iam_role_ec2_1.name
  policy_arn = aws_iam_policy.iam_admin_policy_ec2_1.arn
}

resource "aws_iam_instance_profile" "iam_profile_ecs_instance_1" {
  name = "IaM-Profile-ECS-Instance-1"
  path = "/"
  role = aws_iam_role.iam_role_ec2_1.id
}
resource "aws_iam_role" "ecs-task-role" {
  name = "ecs-task-role"
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
    }
  )
}

resource "aws_iam_role" "iam_role_task_ecs_1" {
  name = "iam-role-task-ecs-1"
  path = "/"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
    }
  )
}



resource "aws_iam_role_policy_attachment" "policy_attachement_task_ecs_1" {
  role       = aws_iam_role.iam_role_task_ecs_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "policy_attachement_task_ecs_2" {
  role       = aws_iam_role.iam_role_task_ecs_1.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "policy_attachement_task_ecs_3" {
  role       = aws_iam_role.iam_role_task_ecs_1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}








resource "aws_iam_policy" "iam-high-priv-policy-assumerole" {
  name        = "High-Privilege-Policy-main"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action = "*"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "iam-high-priv-policy-assumerole-role-1" {
  name                = "High-Privilege-Policy-Start"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.aws_assume_role_arn
        }
      },
    ]
  })
}

resource "aws_iam_role" "iam-high-priv-policy-assumerole-role-2" {
  name                = "High-Privilege-Policy-Moderate"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.iam-high-priv-policy-assumerole-role-1.arn
        }
      },
    ]
  })
}


resource "aws_iam_role" "iam-high-priv-policy-assumerole-3" {
  name                = "High-Privilege-Policy-Admin"
  assume_role_policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = aws_iam_role.iam-high-priv-policy-assumerole-role-2.arn
        }
      },
    ]
  })
}



resource "aws_iam_user" "iam-user-1" {
  name = "${var.prefix}-iam-user-1"
  path = "/"
}
resource "aws_iam_access_key" "iam-user-1" {
  user = aws_iam_user.iam-user-1.name
}
resource "aws_iam_role_policy_attachment" "iam-user-1-policy-attachment" {
  role       = aws_iam_role.iam-high-priv-policy-assumerole-3.name
  policy_arn = aws_iam_policy.iam-high-priv-policy-assumerole.arn

}  

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_policy" "lambda_policy" {
  name_prefix = "${var.prefix}-lambda-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "iam:ListAccessKeys",
          "iam:CreateAccessKey",
          "iam:DeleteAccessKey",
          "iam:UpdateAccessKey",
          "iam:ListUsers",
          "iam:CreateUser",
          "iam:ChangePassword  ",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_exec_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_exec.name
}



resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy_document" "assume_policy_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}




### EC2 instance 
resource "aws_iam_instance_profile" "db_ec2_profile" {
  name = "${var.prefix}-db-profile"
  role = aws_iam_role.db_ec2_role.name
}

resource "aws_iam_role" "db_ec2_role" {
  name = "${var.prefix}-db-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "db_ec2_policy" {
  name = "${var.prefix}-db-policy"
  role = aws_iam_role.db_ec2_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ec2:*",
        "rds:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}




data "aws_iam_policy_document" "app1" {
    statement {
        sid = "PublicReadGetObject"
        effect = "Allow"
        actions = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",            
            "s3:DeleteBucket",
            "s3:CreateBucket",
            "s3:DeleteBucket",
            "s3:DeleteBucketPolicy",
            "s3:DeleteBucketCors",
            "s3:ListBuckets"
        ]
        resources = [
            "arn:aws:s3:::*"
        ]
    }
}

resource "aws_iam_policy" "app1" {
    name   = "vuln_policy"
    path   = "/"
    policy = data.aws_iam_policy_document.app1.json
}













