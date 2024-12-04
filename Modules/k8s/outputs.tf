# output "juice_shop_url" {
#   value = kubernetes_manifest.juice_shop.object.status.loadBalancer.ingress[0].ip
#   description = "The URL for accessing the Juice Shop application"
# }

# output "pygoat_url" {
#   value = kubernetes_manifest.pygoat.object.status.loadBalancer.ingress[0].ip
#   description = "The URL for accessing the PyGoat application"
# } 

output "juice_shop_url" {
  value = try(
    coalesce(
      try(kubernetes_manifest.juice_shop_service.object.status.loadBalancer.ingress[0].ip, ""),
      try(kubernetes_manifest.juice_shop_service.object.status.loadBalancer.ingress[0].hostname, "")
    ),
    "Pending"
  )
  description = "The URL for accessing the Juice Shop application"
}

output "pygoat_url" {
  value = try(
    coalesce(
      try(kubernetes_manifest.pygoat_service.object.status.loadBalancer.ingress[0].ip, ""),
      try(kubernetes_manifest.pygoat_service.object.status.loadBalancer.ingress[0].hostname, "")
    ),
    "Pending"
  )
  description = "The URL for accessing the PyGoat application"
}

output "namespace" {
  value = kubernetes_namespace.app.metadata[0].name
  description = "The namespace where all resources are deployed"
} 