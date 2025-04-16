#!/bin/bash
superset_version="5.0.0rc2"
image_name="xxxxxxxx.azurecr.io/pa-superset"
az acr login --name paacrr2sjis
echo "Customization directory: $(pwd)"
base_dir="$(pwd)"
superset_dir="$(pwd)/build/superset"
if [ -d "${superset_dir}" ]; then rm -rf ${superset_dir}; fi
mkdir -p "${superset_dir}"
echo "Superset build directory: ${superset_dir}"
echo "git clone superset (${superset_version})"
git clone --depth 1 --branch ${superset_version} https://github.com/apache/superset.git "${superset_dir}"
echo "Invoke patch-superset.sh ${base_dir} ${superset_dir}"
source ./patch-superset.sh "${base_dir}" "${superset_dir}"

echo "Build container image: ${image_name}:latest"
DOCKER_BUILDKIT=1 docker build -f "${superset_dir}/Dockerfile" -t "pa-superset-base:latest" --build-arg DEV_MODE=false "${superset_dir}"
DOCKER_BUILDKIT=1 docker build -f "${base_dir}/Dockerfile_custom" -t "${image_name}:latest" --build-arg DEV_MODE=false "${base_dir}"

docker push "${image_name}:latest"
