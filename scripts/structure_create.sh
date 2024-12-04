#!/bin/bash

# Create standardized directory structure
mkdir -p {environments/{dev,staging,prod},modules/{azure,gcp,k8s,networking},manifests/{applications,services},scripts/{deployment,utilities},docs}

# Create README files for documentation
touch {environments,modules,manifests,scripts,docs}/README.md

# $ mkdir -p scripts/deployment scripts/utilities && mv scripts/Deploy*.sh scripts/deployment/ && mv scripts/{autoTF.sh,GenerateKubeConfig.sh,PushImages.sh} scripts/utilities/