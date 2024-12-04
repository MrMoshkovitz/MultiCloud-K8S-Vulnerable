#* Infrastructure Variables Configuration
#* This file defines all variables required for the multi-cloud Kubernetes setup
#* including networking, authentication, and application deployment parameters

#* Common Infrastructure Variables
#? These variables are used across both cloud providers
# Basic infrastructure naming and identification
variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

#* Network Configuration Variables
#? Critical networking parameters - ensure these don't overlap
# Subnet configuration for Kubernetes clusters
variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
}

#* VNET Configuration
#? Virtual network configuration for the infrastructure
# VNET CIDR Address Space
variable "vnet_cidr" {
  description = "VNet CIDR"
  type        = string
}

#* Kubernetes Service Network Configuration
#? Service network configuration for the infrastructure
# Service CIDR Address Space
variable "service_cidr" {
  description = "Service CIDR"
  type        = string
}

#* DNS Service Configuration
#? DNS service configuration for the infrastructure
# DNS Service IP
variable "dns_service_ip" {
  description = "DNS Service IP"
  type        = string
}

#* Docker Networking Configuration
#? Docker networking configuration for the infrastructure
# Docker Bridge CIDR
variable "docker_bridge_cidr" {
  description = "Docker Bridge CIDR"
  type        = string
}

#* Container Registry Configuration
#? Settings for container image management
# Container Registry Name
variable "registry_name" {
  description = "Container registry"
  type        = string
}

variable "image_name" {
  description = "Name of the container image"
  type        = string
}

variable "image_version" {
  description = "Version of the container image"
  type        = string
}

#* Azure Authentication and Configuration
#? Sensitive credentials and regional settings for Azure
#? SECURITY NOTE: Ensure these values are properly secured
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "azure_region" {
  description = "Azure Region"
  type        = string
}

#* GCP Authentication and Configuration
#? Project and regional settings for Google Cloud Platform
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  type        = string
}

variable "gcp_zone" {
  description = "GCP Zone"
  type        = string
}

#* Kubernetes Deployment Configuration
#? Configuration for vulnerable application deployments
#? SECURITY NOTE: These applications are intentionally vulnerable

#* Azure Kubernetes Configuration
#? Kubeconfig file content for the target Kubernetes cluster
variable "azure_kubeconfig" {
  description = "Kubeconfig file content for the target Kubernetes cluster"
  type        = string
}

variable "azure_juice_shop_manifest" {
  description = "Path to the Juice Shop Kubernetes manifest file for Azure"
  type        = string
}

variable "azure_pygoat_manifest" {
  description = "Path to the PyGoat Kubernetes manifest file for Azure"
  type        = string
}

#* GCP Kubernetes Configuration
#? Kubeconfig file content for the target Kubernetes cluster
variable "gcp_kubeconfig" {
  description = "Kubeconfig file content for the target Kubernetes cluster"
  type        = string
}

variable "gcp_juice_shop_manifest" {
  description = "Path to the Juice Shop Kubernetes manifest file for GCP"
  type        = string
}

variable "gcp_pygoat_manifest" {
  description = "Path to the PyGoat Kubernetes manifest file for GCP"
  type        = string
}