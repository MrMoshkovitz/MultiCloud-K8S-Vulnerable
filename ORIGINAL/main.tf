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


module "azure_k8s_deployments" {
  source              = "./Modules/k8s"
  kubeconfig          = module.azure.kubeconfig
  juice_shop_manifest = module.azure.juice_shop_manifest
  pygoat_manifest     = module.azure.pygoat_manifest
}

module "gcp_k8s_deployments" {
  source              = "./Modules/k8s"
  kubeconfig          = module.gcp.kubeconfig
  juice_shop_manifest = module.gcp.juice_shop_manifest
  pygoat_manifest     = module.gcp.pygoat_manifest
}