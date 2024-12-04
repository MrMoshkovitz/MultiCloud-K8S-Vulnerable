#* Kubernetes Deployment Module
#* This module handles the deployment of vulnerable applications
#* including OWASP Juice Shop and PyGoat on Kubernetes clusters

#* Provider Configuration
#? Uses kubeconfig from the cloud provider modules
provider "kubernetes" {
  config_path = pathexpand(var.kubeconfig)
}

#* Namespace Configuration
#? Creates a dedicated namespace for vulnerable applications
#? SECURITY NOTE: Isolates vulnerable apps from other workloads
resource "kubernetes_namespace" "app" {
  metadata {
    name = "oxcloudgraph"
  }
}

#* OWASP Juice Shop Deployment
#? Deploys the Juice Shop vulnerable web application
#? SECURITY NOTE: This application contains intentional vulnerabilities

# Deployment configuration
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

# Service configuration for network access
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

# Ingress configuration for external access
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

#* PyGoat Application Deployment
#? Deploys the PyGoat vulnerable Python web application
#? SECURITY NOTE: This application contains intentional vulnerabilities

# Deployment configuration
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

# Service configuration for network access
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
