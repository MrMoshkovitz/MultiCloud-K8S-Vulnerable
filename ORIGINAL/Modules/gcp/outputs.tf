
# Modules/gcp/outputs.tf

output "kubeconfig" {
  value = "~/.kube/gcp_gke_config"
}

output "juice_shop_manifest" {
  value = var.gcp_juice_shop_manifest
}

output "pygoat_manifest" {
  value = var.gcp_pygoat_manifest
}
