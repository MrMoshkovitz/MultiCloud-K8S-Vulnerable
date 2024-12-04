# YAML --> tf File
# PyGoat
az acr login --name registry4oxcloudgraph
docker pull pygoat/pygoat
docker tag pygoat/pygoat:latest registry4oxcloudgraph.azurecr.io/pygoat:v1
docker push registry4oxcloudgraph.azurecr.io/pygoat:v1


# Juice Shop
az acr login --name registry4oxcloudgraph
docker pull europe-west2-docker.pkg.dev/ox-test-playground/juicehop/juice-shop:v1
docker tag europe-west2-docker.pkg.dev/ox-test-playground/juicehop/juice-shop:v1 registry4oxcloudgraph.azurecr.io/juice-shop:v1
docker push registry4oxcloudgraph.azurecr.io/juice-shop:v1
