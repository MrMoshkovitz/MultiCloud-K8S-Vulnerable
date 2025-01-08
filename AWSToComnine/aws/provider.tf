
#*#################################################################################
#? PROVIDERS
#*#################################################################################


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
  default_tags {
    tags = {
      Creator     = "GM"
    }

  }
}
