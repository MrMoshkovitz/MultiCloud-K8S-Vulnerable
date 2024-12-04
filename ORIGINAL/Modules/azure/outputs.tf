# Modules/azure/outputs.tf

output "kubeconfig" {
  value = "~/.kube/azure_aks_config"
}

output "juice_shop_manifest" {
  value = var.azure_juice_shop_manifest
}

output "pygoat_manifest" {
  value = var.azure_pygoat_manifest
}
