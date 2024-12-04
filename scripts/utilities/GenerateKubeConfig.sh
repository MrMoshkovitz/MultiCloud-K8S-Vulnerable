#* Generate Kube Config for Azure AKS
AZURE_RESOURCE_GROUP="oxcloudgraph-rg"
AZURE_AKS_CLUSTER_NAME="oxcloudgraph-aks"

az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_AKS_CLUSTER_NAME --file ~/.kube/azure_aks_config
cp ~/.kube/azure_aks_config .


#* Generate Kube Config for GCP GKE
GCP_PROJECT_ID="ox-test-playground"
GCP_GKE_CLUSTER_NAME="oxcloudgraph-gke-cluster"
GCP_GKE_REGION="europe-west1"

# Get credentials and save directly to file
gcloud container clusters get-credentials $GCP_GKE_CLUSTER_NAME --region $GCP_GKE_REGION --project $GCP_PROJECT_ID
GKE_CONTEXT=$(kubectl config get-contexts -o name | grep oxcloudgraph-gke-cluster)
# Create a new kubeconfig file with just the GKE context
kubectl config view --minify --flatten --context=$GKE_CONTEXT > ~/.kube/gcp_gke_config
cp ~/.kube/gcp_gke_config .

