#* Cloud Provider Configuration
#* This file configures the necessary providers for multi-cloud deployment
#* including version constraints and authentication settings

#* Required Providers Block
#? Specific versions are pinned for stability
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }
  }
}

#* Google Cloud Platform Provider Configuration
#? Authentication and regional settings for GCP
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

#* Azure Provider Configuration
#? Authentication and subscription settings for Azure
#? SECURITY NOTE: Ensure credentials are properly secured
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

#* AWS Provider Configuration
# #? Authentication and regional settings for AWS
# provider "aws" {
#   region = var.aws_region
# }