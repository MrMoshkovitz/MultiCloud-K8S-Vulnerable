#* General Variables
prefix             = "oxcloudgraph"
registry_name      = "registry4oxcloudgraph"
image_name         = "juice-shop"
image_version      = "v1"
subnet_cidr        = "10.0.1.0/24"
vnet_cidr          = "10.0.0.0/16"
service_cidr       = "10.1.0.0/16"
dns_service_ip     = "10.1.0.10"
docker_bridge_cidr = "172.17.0.1/16"

#* GCP Variables
gcp_project_id = "ox-test-playground"
gcp_region     = "europe-west1"
gcp_zone       = "europe-west1-a"

#* Azure Variables
azure_subscription_id = "SUBSCRIPTION_ID"
azure_client_id       = "CLIENT_ID"
azure_client_secret   = "CLIENT_SECRET"
azure_tenant_id       = "4cf1d437-66ce-456b-a8a1-1173d7c8ed66"
azure_region          = "westeurope"


#* K8s Variables
azure_kubeconfig          = "~/.kube/azure_aks_config"
azure_juice_shop_manifest = "/Users/galmoshkovitz/Code/Gitlab/gm-project/CloudGraphGM/Deployment/TF/MultiCloudTFK8SJuiceShop/TFFull/Modules/manifests/azure/juice-shop.yaml"
azure_pygoat_manifest     = "/Users/galmoshkovitz/Code/Gitlab/gm-project/CloudGraphGM/Deployment/TF/MultiCloudTFK8SJuiceShop/TFFull/Modules/manifests/azure/pygoat.yaml"

gcp_kubeconfig          = "~/.kube/gcp_gke_config"
gcp_juice_shop_manifest = "/Users/galmoshkovitz/Code/Gitlab/gm-project/CloudGraphGM/Deployment/TF/MultiCloudTFK8SJuiceShop/TFFull/Modules/manifests/gcp/juice-shop.yaml"
gcp_pygoat_manifest     = "/Users/galmoshkovitz/Code/Gitlab/gm-project/CloudGraphGM/Deployment/TF/MultiCloudTFK8SJuiceShop/TFFull/Modules/manifests/gcp/pygoat.yaml"
