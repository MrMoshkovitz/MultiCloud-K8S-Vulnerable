#*#################################################################################
#?					 Region
#*#################################################################################
variable "region" {
  type    = string
}


#*#################################################################################
#?					 Profile
#*#################################################################################
variable "profile" {
  type    = string
}


#*#################################################################################
#?					 Creds
#*#################################################################################
variable "password" {
  type        = string

}




#*##################################################################################
#? 				App1 -  Vulny
#*##################################################################################


#? 				App1 -  Vulny
#*##################################################################################
#?				 Prefix
#*#################################################################################
variable "prefix" {
  type    = string
}



#?				 AMI
#*#################################################################################

variable "ami1" {
  type    = string
}


#?				 Network
#*#################################################################################
#?                                      AWS VPC
#*#################################################################################
variable "vpc_cidr" {
  type    = string
}


#?                                      AWS Subnet
#*#################################################################################
variable "subnet_cidr" {
  type    = string
}

#?                                      AWS Subnet
#*#################################################################################
variable "db_subnet_cidr1" {
  type    = string
  
}
variable "db_subnet_cidr2" {
  type    = string
}

#?                                     AWS Network Interface
#*=#################################################################################
variable "eni_cidr" {
  type    = string

}


#?                                     AWS EC2 - Ubuntu Server 16.04
#*=#################################################################################
# variable "




#?                                    AWS IAM 
#*=#################################################################################

#?                                    AWS IAM - Role
#*=#################################################################################
variable "role_name" {
  type    = string
}

variable "aws_assume_role_session_name" {
  type    = string
}



variable "aws_assume_role_arn" {
  type        = string
}