variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
}

variable "vnet_cidr" {
  description = "VNet CIDR"
  type        = string
}

variable "service_cidr" {
  description = "Service CIDR"
  type        = string
}

variable "dns_service_ip" {
  description = "DNS Service IP"
  type        = string
}

variable "docker_bridge_cidr" {
  description = "Docker Bridge CIDR"
  type        = string
}

variable "registry_name" {
  description = "Name of the container registry"
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

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure client secret"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "azure_region" {
  description = "Azure region"
  type        = string
}


# Modules/azure/variables.tf

variable "azure_juice_shop_manifest" {
  description = "Path to the Juice Shop Kubernetes manifest file for Azure"
  type        = string
}

variable "azure_pygoat_manifest" {
  description = "Path to the PyGoat Kubernetes manifest file for Azure"
  type        = string
}
