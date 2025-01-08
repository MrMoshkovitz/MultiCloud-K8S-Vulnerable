
#*#################################################################################
#?                                      App1 - Vulny
#*#################################################################################

#?                                      App1 - Vulny
#*#################################################################################
#?                                      AWS VPC
#*#################################################################################
resource "aws_vpc" "app1" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true    
}



#?                                      AWS Subnet
#*#################################################################################
resource "aws_subnet" "app1" {
    vpc_id            = aws_vpc.app1.id
    cidr_block        = var.subnet_cidr
    availability_zone = "${var.region}a"
}

#?                                      AWS Subnet Group
#*#################################################################################
resource "aws_db_subnet_group" "app1-db" {
  name        = "database subnets"
  subnet_ids  = [aws_subnet.app1-db1.id, aws_subnet.app1-db2.id]
}

#?                                      AWS Subnet Group - DB
#*#################################################################################
resource "aws_subnet" "app1-db1" {
    vpc_id            = aws_vpc.app1.id
    cidr_block        = var.db_subnet_cidr1
    availability_zone = "${var.region}b"
}
resource "aws_subnet" "app1-db2" {
    vpc_id            = aws_vpc.app1.id
    cidr_block        = var.db_subnet_cidr2
    availability_zone = "${var.region}c"
}


#?                                      AWS Network Interface
#*#################################################################################
resource "aws_network_interface" "app1" {
    subnet_id   = aws_subnet.app1.id
    private_ips = [var.eni_cidr]
}


#?                                      AWS Security Group
#*#################################################################################
resource "aws_security_group" "app1" {
    description = "Allow Ports"
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 3389
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 3389
        },
    ]
    ingress     = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 1433
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 1433
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 25
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 25
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 3306
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 3306
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 3389
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 3389
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 445
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 445
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "MySQL"
            from_port        = 443
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 443
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "REDIS"
            from_port        = 6379
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 6379
        },        
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "POSTGRESQL"
            from_port        = 5432
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 5432
        },        
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "REDIS"
            from_port        = 6379
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 6379
        },       
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "MEMCACHED"
            from_port        = 11211
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 11211
        },       
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "MONGODB"
            from_port        = 27017
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 27017
        },       
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "ELASTICSEARCH"
            from_port        = 9200
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 9200
        },       
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "ELASTICSEARCH"
            from_port        = 9300
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 9300
        },       
                                     
    ]
    name        = "AllowingPorts"
    tags    = {
        "User" = "admin"
        "Pasword" = "password"
    }
    vpc_id      = aws_vpc.app1.id

    timeouts {}
}


resource "aws_security_group" "app1-db" {
  name        = "Database Security Group"
  description = "Enable MYSQL Aurora access on Port 3306"
  vpc_id      = aws_vpc.app1.id

  ingress {
    description     = "MYSQL/Aurora Access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app1.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}







resource "aws_security_group" "db_instance" {
  name   = "${var.prefix}-rds-security-group"
  vpc_id = aws_vpc.app1.id
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = "3306"
  to_port           = "3306"
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.app1.cidr_block]
  security_group_id = aws_security_group.db_instance.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_instance.id
}
#?                                     AWS Internet Gateway
#*#################################################################################
resource "aws_internet_gateway" "app1" {
    vpc_id = aws_vpc.app1.id
    
}


#?                                     AWS Route Table
#*#################################################################################
resource "aws_route_table" "app1" {
    vpc_id = aws_vpc.app1.id

    route {
        cidr_block = "0.0.0.0/24"
        gateway_id = aws_internet_gateway.app1.id
    }
}


#?                                     AWS Route Table Association
#*#################################################################################
resource "aws_route_table_association" "app1" {
    route_table_id = aws_route_table.app1.id
    subnet_id      = aws_subnet.app1.id
}


#?                                     AWS Elastic IP
#*#################################################################################
resource "aws_eip" "app1" {
    vpc = true
}


#?                                     AWS Network Interface Attachment
#*#################################################################################
resource "aws_network_interface_attachment" "app1" {
    device_index         = 1
    instance_id          = aws_instance.app1.id
    network_interface_id = aws_network_interface.app1.id
}





















#?                                    AWS Lambda Function
#*#################################################################################

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.serverless_app.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "serverless_app_api_gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "api_gateway_stage" {
  name        = "prod"
  api_id      = aws_apigatewayv2_api.api_gateway.id
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "api_gateway_lambda_integration" {
  api_id             = aws_apigatewayv2_api.api_gateway.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.serverless_app.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "api_gateway_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.api_gateway_lambda_integration.id}"
}

resource "aws_apigatewayv2_deployment" "api_gateway" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  description = "API Gateway Deployment"

  depends_on = [
    aws_apigatewayv2_route.api_gateway_route
  ]
}



#?                                    AWS Load Balancer
#*#################################################################################
resource "aws_alb" "application_load_balancer" {
  name               = "${var.prefix}-load-balancer" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ 
    aws_subnet.app1.id, 
    aws_subnet.app1-db1.id, 
    aws_subnet.app1-db2.id 
  ]
  # Referencing the security group
  security_groups = [aws_security_group.app1.id]
}
