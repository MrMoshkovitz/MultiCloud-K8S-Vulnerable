#* MultiCloud Kubernetes Infrastructure Configuration
#* This configuration sets up Kubernetes clusters in both Azure and GCP
#* with vulnerable application deployments for security testing purposes

#? SECURITY NOTE: This infrastructure intentionally deploys vulnerable applications
#? for educational and testing purposes. DO NOT deploy in production environments.

#* Azure Infrastructure Module
# Configures Azure AKS cluster and related resources
module "azure" {
  source = "./Modules/azure"

  prefix                = var.prefix
  registry_name         = var.registry_name
  image_name            = var.image_name
  image_version         = var.image_version
  subnet_cidr           = var.subnet_cidr
  vnet_cidr             = var.vnet_cidr
  service_cidr          = var.service_cidr
  dns_service_ip        = var.dns_service_ip
  docker_bridge_cidr    = var.docker_bridge_cidr
  azure_subscription_id = var.azure_subscription_id
  azure_client_id       = var.azure_client_id
  azure_client_secret   = var.azure_client_secret
  azure_tenant_id       = var.azure_tenant_id
  # azure_region          = var.azure_region
  azure_region              = "eastus"
  azure_juice_shop_manifest = var.azure_juice_shop_manifest
  azure_pygoat_manifest     = var.azure_pygoat_manifest

}

#* Google Cloud Platform Infrastructure Module
# Configures GCP GKE cluster and related resources
module "gcp" {
  source = "./Modules/gcp"

  prefix        = var.prefix
  registry_name = var.registry_name
  image_name    = var.image_name
  image_version = var.image_version
  subnet_cidr   = var.subnet_cidr

  gcp_project_id          = var.gcp_project_id
  gcp_region              = var.gcp_region
  gcp_zone                = var.gcp_zone
  gcp_juice_shop_manifest = var.gcp_juice_shop_manifest
  gcp_pygoat_manifest     = var.gcp_pygoat_manifest

}

#* Amazon Web Services Infrastructure Module
# Configures AWS EKS cluster and related resources
# TODO: Implement AWS EKS infrastructure
module "aws" {
  source = "./Modules/aws"
  # TODO: Add required variables for AWS configuration:
  # - AWS access key and secret
  # - AWS region
  # - VPC and subnet configurations
  # - EKS cluster configurations
  # - Container registry (ECR) settings
  # - Security group configurations
}

#* Kubernetes Deployments Section
#? These modules handle the deployment of vulnerable applications
#? including Juice Shop and PyGoat on both cloud providers

#* Azure Kubernetes deployments configuration
module "azure_k8s_deployments" {
  source              = "./Modules/k8s"
  kubeconfig          = module.azure.kubeconfig
  juice_shop_manifest = module.azure.juice_shop_manifest
  pygoat_manifest     = module.azure.pygoat_manifest
}

#* GCP Kubernetes deployments configuration
module "gcp_k8s_deployments" {
  source              = "./Modules/k8s"
  kubeconfig          = module.gcp.kubeconfig
  juice_shop_manifest = module.gcp.juice_shop_manifest
  pygoat_manifest     = module.gcp.pygoat_manifest
}

#* AWS Kubernetes deployments configuration
module "aws_k8s_deployments" {
  source = "./Modules/k8s"
  # TODO: Add required variables:
  # - EKS kubeconfig
  # - Application manifests for AWS deployments
  # depends_on = [module.aws]
}