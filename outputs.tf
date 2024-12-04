output "azure_juice_shop_url" {
  value = module.azure_k8s_deployments.juice_shop_url
}

output "gcp_juice_shop_url" {
  value = module.gcp_k8s_deployments.juice_shop_url
}

output "azure_pygoat_url" {
  value = module.azure_k8s_deployments.pygoat_url
}

output "gcp_pygoat_url" {
  value = module.gcp_k8s_deployments.pygoat_url
}
