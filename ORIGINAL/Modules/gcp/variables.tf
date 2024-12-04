variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
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

# Modules/gcp/variables.tf

variable "gcp_juice_shop_manifest" {
  description = "Path to the Juice Shop Kubernetes manifest file for GCP"
  type        = string
}

variable "gcp_pygoat_manifest" {
  description = "Path to the PyGoat Kubernetes manifest file for GCP"
  type        = string
}
