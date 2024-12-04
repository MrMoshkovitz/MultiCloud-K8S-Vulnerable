#!/bin/bash

# Make sure to print each command
set -x

# Load environment variables
source .env


PREFIX=$PREFIX
CONTAINER_REGISTRY_NAME=$CONTAINER_REGISTRY_NAME
GCP_PROJECT_ID=$GCP_PROJECT_ID
GCP_REGION=$GCP_REGION
CONTAINER_REGISTRY_BASE=$GCP_CONTAINER_REGISTRY_BASE

JUICE_SHOP_CONTAINER_IMAGE_NAME=$JUICE_SHOP_CONTAINER_IMAGE_NAME
JUICE_SHOP_CONTAINER_IMAGE_VERSION=$JUICE_SHOP_CONTAINER_IMAGE_VERSION
JUICE_SHOP_DEPLOYMENT_FILE=gcp_gke_full_juice-shop.yaml


PYGOAT_DEPLOYMENT_FILE=gcp_gke_short_pygoat.yaml
PYGOAT_CONTAINER_IMAGE_NAME=$PYGOAT_CONTAINER_IMAGE_NAME
PYGOAT_CONTAINER_IMAGE_VERSION=$PYGOAT_CONTAINER_IMAGE_VERSION

#* 1. Authenticate to GCP
gcloud auth login
gcloud config set project $GCP_PROJECT_ID
# gcloud auth configure-docker $GCP_REGION

#* 2. Enable Container Registry API
gcloud services enable container.googleapis.com artifactregistry.googleapis.com

#* 3. Configure Docker to use GCP Container Registry
gcloud auth configure-docker $GCP_REGION-docker.pkg.dev



#* 3. Docker pull image
#? Juice Shop
# docker pull europe-west2-docker.pkg.dev/ox-test-playground/juicehop/juice-shop:v1

#? PyGoat
# docker pull pygoat/pygoat:latest

#* 4. Docker tag image for Azure Container Registry
#? Juice Shop
docker tag europe-west2-docker.pkg.dev/ox-test-playground/juicehop/$JUICE_SHOP_CONTAINER_IMAGE_NAME:$JUICE_SHOP_CONTAINER_IMAGE_VERSION $GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$CONTAINER_REGISTRY_NAME/$JUICE_SHOP_CONTAINER_IMAGE_NAME:$JUICE_SHOP_CONTAINER_IMAGE_VERSION

#? PyGoat
docker tag pygoat/pygoat:latest $GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$CONTAINER_REGISTRY_NAME/$PYGOAT_CONTAINER_IMAGE_NAME:$PYGOAT_CONTAINER_IMAGE_VERSION


#* 5. Docker push image to Azure Container Registry
#? Juice Shop
docker push $GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$CONTAINER_REGISTRY_NAME/$JUICE_SHOP_CONTAINER_IMAGE_NAME:$JUICE_SHOP_CONTAINER_IMAGE_VERSION
#? PyGoat
docker push $GCP_REGION-docker.pkg.dev/$GCP_PROJECT_ID/$CONTAINER_REGISTRY_NAME/$PYGOAT_CONTAINER_IMAGE_NAME:$PYGOAT_CONTAINER_IMAGE_VERSION



#* 6 Get credentials for the cluster
gcloud container clusters get-credentials $PREFIX-gke-cluster --region $GCP_REGION



#* 7. Grant GKE permission to access Artifact Registry
# project_number=$(gcloud projects describe $GCP_PROJECT_ID --format='get(projectNumber)')
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member "serviceAccount:$(gcloud projects describe $GCP_PROJECT_ID --format='get(projectNumber)')-compute@developer.gserviceaccount.com" --role "roles/artifactregistry.reader"


#* 8. Deploy to GKE
kubectl apply -f $JUICE_SHOP_DEPLOYMENT_FILE
kubectl apply -f $PYGOAT_DEPLOYMENT_FILE



