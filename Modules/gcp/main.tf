#* Google Cloud Platform Infrastructure Module
#* This module sets up the complete GCP infrastructure including
#* VPC, subnet, firewall rules, GKE cluster, and artifact registry

#* Network Configuration
#? VPC network for GKE cluster
resource "google_compute_network" "vpc_network" {
  name = "${var.prefix}-vpc"
}

# Subnet configuration for GKE cluster
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.prefix}-subnet"
  ip_cidr_range = "${var.subnet_cidr}"
  network       = google_compute_network.vpc_network.id
  region        = var.gcp_region
}

#* Security Configuration
#? SECURITY NOTE: These firewall rules are intentionally permissive for testing
#? DO NOT use these settings in production environments
resource "google_compute_firewall" "default" {
  name    = "${var.prefix}-allow-http-https-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}

#* GKE Cluster Configuration
#? Main Kubernetes cluster setup with network integration
#? Configured with HTTP load balancing enabled
resource "google_container_cluster" "primary" {
  name     = "${var.prefix}-gke-cluster"
  location = var.gcp_region

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name

  initial_node_count = 3

  node_config {
    machine_type = "e2-medium" # Adjust based on your requirements

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # Enable the HTTP load balancing addon
  addons_config {
    http_load_balancing {
      disabled = false
    }
  }
}

#* Container Registry Configuration
#? Artifact Registry for storing vulnerable application images
#? SECURITY NOTE: Ensure proper access controls in production
resource "google_artifact_registry_repository" "juice_shop_repo" {
  provider      = google
  location      = var.gcp_region
  repository_id = "${var.registry_name}"
  description   = "Artifact Registry for Juice Shop images"
  format        = "DOCKER"
}

#* Project Data Source
# Retrieves current project information
data "google_project" "project" {}

