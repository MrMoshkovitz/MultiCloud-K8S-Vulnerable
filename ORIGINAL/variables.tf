#* General Variables
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

#* Juice Shop Variables
variable "registry_name" {
  description = "Container registry"
  type        = string
}

variable "image_name" {
  description = "Name of the container image"
  type        = string
}

#* Image Version
variable "image_version" {
  description = "Version of the container image"
  type        = string
}

#* Azure-specific variables
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

#* GCP-specific variables
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


#* K8s Variables
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