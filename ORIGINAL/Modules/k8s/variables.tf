variable "kubeconfig" {
  description = "Kubeconfig file content for the target Kubernetes cluster"
  type        = string
}

variable "juice_shop_manifest" {
  description = "Path to the Juice Shop Kubernetes manifest file"
  type        = string
}

variable "pygoat_manifest" {
  description = "Path to the PyGoat Kubernetes manifest file"
  type        = string
}
