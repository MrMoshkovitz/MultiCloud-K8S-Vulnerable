provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig)
}

# Create namespace
resource "kubernetes_namespace" "app" {
  metadata {
    name = "oxcloudgraph"
  }
}

# Juice Shop Resources
resource "kubernetes_manifest" "juice_shop_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata   = merge(
      yamldecode(split("---", file(var.juice_shop_manifest))[0]).metadata,
      { namespace = kubernetes_namespace.app.metadata[0].name }
    )
    spec = yamldecode(split("---", file(var.juice_shop_manifest))[0]).spec
  }
}

resource "kubernetes_manifest" "juice_shop_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata   = merge(
      yamldecode(split("---", file(var.juice_shop_manifest))[1]).metadata,
      { namespace = kubernetes_namespace.app.metadata[0].name }
    )
    spec = yamldecode(split("---", file(var.juice_shop_manifest))[1]).spec
  }
}

resource "kubernetes_manifest" "juice_shop_ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata   = merge(
      yamldecode(split("---", file(var.juice_shop_manifest))[2]).metadata,
      { namespace = kubernetes_namespace.app.metadata[0].name }
    )
    spec = yamldecode(split("---", file(var.juice_shop_manifest))[2]).spec
  }
}

# PyGoat Resources
resource "kubernetes_manifest" "pygoat_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata   = merge(
      yamldecode(split("---", file(var.pygoat_manifest))[0]).metadata,
      { namespace = kubernetes_namespace.app.metadata[0].name }
    )
    spec = yamldecode(split("---", file(var.pygoat_manifest))[0]).spec
  }
}

resource "kubernetes_manifest" "pygoat_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata   = merge(
      yamldecode(split("---", file(var.pygoat_manifest))[1]).metadata,
      { namespace = kubernetes_namespace.app.metadata[0].name }
    )
    spec = yamldecode(split("---", file(var.pygoat_manifest))[1]).spec
  }
}
