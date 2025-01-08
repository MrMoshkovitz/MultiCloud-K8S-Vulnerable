

resource "aws_db_instance" "app1-db" {
  identifier             = "${var.prefix}db"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  engine                 = "mysql"
  engine_version         = "5.7"
  username               = "admin"
  password               = "password123456"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  availability_zone      = "us-east-1b"
  db_subnet_group_name   = aws_db_subnet_group.app1-db.name
  vpc_security_group_ids = [aws_security_group.app1-db.id, aws_security_group.app1.id]
}


#?                                     AWS EC2 - DB Instance
#*#################################################################################
resource "aws_db_instance" "db_instance" {
  name                   = "${var.prefix}dbinstance"
  engine                 = "mysql"
  option_group_name      = aws_db_option_group.db_instance.name
  parameter_group_name   = aws_db_parameter_group.db_instance.name
  db_subnet_group_name   = aws_db_subnet_group.app1-db.name
  vpc_security_group_ids = [aws_security_group.db_instance.id]

  identifier              = "${var.prefix}-rds"
  engine_version          = "8.0" # Latest major version 
  instance_class          = "db.t3.micro"
  allocated_storage       = "20"
  username                = "mysqladmin"
  password                = "mysqlpassword"
  apply_immediately       = true
  multi_az                = false
  backup_retention_period = 0
  storage_encrypted       = false
  skip_final_snapshot     = true
  monitoring_interval     = 0
  publicly_accessible     = true


  # Ignore password changes from tf plan diff
  lifecycle {
    ignore_changes = [password]
  }
}

resource "aws_db_option_group" "db_instance" {
  engine_name              = "mysql"
  name                     = "${var.prefix}-option-group"
  major_engine_version     = "8.0"
  option_group_description = "DB Option Group"
}

resource "aws_db_parameter_group" "db_instance" {
  name        = "pg-${var.prefix}"
  family      = "mysql8.0"
  description = "DB Parameter Group"

  parameter {
    name         = "character_set_client"
    value        = "utf8"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8"
    apply_method = "immediate"
  }
}