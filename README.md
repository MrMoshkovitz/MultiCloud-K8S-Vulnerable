# MultiCloud Kubernetes Vulnerable Infrastructure

⚠️ **WARNING: This infrastructure intentionally deploys vulnerable applications for security testing purposes. DO NOT deploy in production environments.**

## Table of Contents
1. [Project Overview](#project-overview)
2. [File Structure](#file-structure)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Deployment Guide](#deployment-guide)
7. [Security Notice](#security-notice)
8. [Maintenance](#maintenance)
9. [Contributing](#contributing)
10. [License](#license)

## Project Overview
This project sets up Kubernetes clusters across multiple cloud providers (Azure and GCP) and deploys intentionally vulnerable applications for security testing and educational purposes. It uses Infrastructure as Code (IaC) with Terraform to create and manage cloud resources consistently and reproducibly.

## File Structure
```
.
├── environments/           # Environment-specific configurations
│   ├── dev/               # Development environment settings
│   ├── staging/           # Staging environment settings
│   └── prod/              # Production environment settings
├── Modules/               # Reusable Terraform modules
│   ├── azure/             # Azure infrastructure components
│   ├── gcp/               # GCP infrastructure components
│   ├── k8s/               # Kubernetes configurations
│   └── manifests/         # Shared manifest templates
├── manifests/             # Kubernetes manifests
│   ├── applications/      # Application deployments (Juice Shop, PyGoat)
│   └── services/          # Service configurations
├── scripts/               # Automation scripts
│   ├── deployment/        # Deployment automation scripts
│   ├── utilities/         # Utility scripts
│   └── structure_create.sh # Directory structure creation script
├── main.tf                # Main Terraform configuration
├── variables.tf           # Variable definitions
├── outputs.tf             # Output definitions
├── providers.tf           # Provider configurations
└── terraform.tfvars       # Variable values
```

## Prerequisites
- Terraform >= 1.0.0
- Azure CLI (latest version)
- Google Cloud SDK (latest version)
- kubectl (compatible with your K8s version)
- Docker Desktop or equivalent
- Active subscriptions/accounts:
  - Azure subscription
  - Google Cloud Platform account
  - Configured service principals/credentials

## Installation

### 1. Clone the Repository
```bash
git clone [repository-url]
cd MultiCloud-K8S-Vulnerable
```

### 2. Install Required Tools
#### For macOS:
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install terraform
brew install azure-cli
brew install google-cloud-sdk
brew install kubectl
```

#### For Linux:
```bash
# Install Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install terraform

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install Google Cloud SDK
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update && sudo apt install google-cloud-sdk

# Install kubectl
sudo apt install kubectl
```

## Configuration

### 1. Cloud Provider Setup

#### Azure Setup:
```bash
# Login to Azure
az login

# Create Service Principal
az ad sp create-for-rbac --name "MultiCloud-K8S-Vulnerable" --role Contributor
```

#### GCP Setup:
```bash
# Login to GCP
gcloud auth login

# Set project
gcloud config set project [YOUR_PROJECT_ID]

# Create service account and download key
gcloud iam service-accounts create multicloud-k8s-vulnerable
gcloud projects add-iam-policy-binding [YOUR_PROJECT_ID] \
    --member="serviceAccount:multicloud-k8s-vulnerable@[YOUR_PROJECT_ID].iam.gserviceaccount.com" \
    --role="roles/owner"
gcloud iam service-accounts keys create gcp-credentials.json \
    --iam-account=multicloud-k8s-vulnerable@[YOUR_PROJECT_ID].iam.gserviceaccount.com
```

### 2. Configure terraform.tfvars
Update the `terraform.tfvars` file with your specific values:
```hcl
prefix = "your-prefix"
azure_subscription_id = "your-subscription-id"
azure_client_id = "your-client-id"
azure_client_secret = "your-client-secret"
azure_tenant_id = "your-tenant-id"
gcp_project_id = "your-project-id"
```

## Deployment Guide

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Plan the Deployment
```bash
terraform plan -out=tfplan
```

### 3. Apply the Configuration
```bash
terraform apply tfplan
```

### 4. Access the Clusters
```bash
# Configure kubectl for Azure
az aks get-credentials --resource-group [resource-group-name] --name [cluster-name]

# Configure kubectl for GCP
gcloud container clusters get-credentials [cluster-name] --region [region]
```

### 5. Verify Deployments
```bash
# List all pods
kubectl get pods --all-namespaces

# Get service endpoints
kubectl get services
```

## Security Notice
This infrastructure deploys the following intentionally vulnerable applications:
- OWASP Juice Shop: A purposefully vulnerable web application
- PyGoat: A vulnerable Python web application

⚠️ **IMPORTANT SECURITY CONSIDERATIONS:**
- This infrastructure is for testing and educational purposes only
- Never deploy in production environments
- Keep access restricted to trusted networks
- Regularly rotate credentials and access keys
- Monitor resource usage and costs

## Maintenance
- Regular Updates:
  - Keep Terraform providers updated
  - Update cloud provider SDKs
  - Maintain current versions of vulnerable applications
- Best Practices:
  - Use consistent naming conventions
  - Document all changes
  - Test changes in development environment first
  - Keep security configurations isolated

## Contributing
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
[MIT License](LICENSE)

---
⚠️ **Reminder**: This project is for educational purposes only. Deploy at your own risk.