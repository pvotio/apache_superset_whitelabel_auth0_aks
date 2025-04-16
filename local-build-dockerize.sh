#!/bin/bash
dockerize_version="v0.9.3"
image_name="xxxxxxx.azurecr.io/pa-dockerize"
az acr login --name paacrr2sjis
echo "Customization directory: $(pwd)"
base_dir="$(pwd)"
superset_dir="$(pwd)/build/superset"
if [ -d "${superset_dir}" ]; then rm -rf ${superset_dir}; fi
mkdir -p "${superset_dir}"
echo "Superset build directory: ${superset_dir}"
echo "git clone superset (${superset_version})"
git clone --depth 1 --branch ${superset_version} https://github.com/apache/superset.git "${superset_dir}"

echo "Build container image: ${image_name}:latest"
docker build -t "${image_name}:latest" --build-arg DOCKERIZE_VERSION=${dockerize_version} -f "${superset_dir}/dockerize.Dockerfile" "${superset_dir}"

docker push "${image_name}:latest"
