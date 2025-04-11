#!/bin/bash
# $1=acrName, $2=superset-version, $3=container-tag
echo "Customization directory: $(pwd)"
base_dir="$(pwd)"
superset_dir="$(pwd)/build/superset"
mkdir -p "${superset_dir}"
echo "Superset build directory: ${superset_dir}"
echo "git clone superset (${superset_version})"
git clone --depth 1 --branch ${superset_version} https://github.com/apache/superset.git "${superset_dir}"
echo "Invoke patch-superset.sh ${base_dir} ${superset_dir}"
source ./patch-superset.sh "${base_dir}" "${superset_dir}"

echo "Show available memory"
free -m

echo "Build container image: ${image_name}:latest"
DOCKER_BUILDKIT=1 docker build -f "${superset_dir}/Dockerfile" -t "${image_name}-base:latest" --build-arg DEV_MODE=false "${superset_dir}"
retval=$?
if [ $retval -ne 0 ]; then
    echo "Error ${retval}"
    exit ${retval}
fi
DOCKER_BUILDKIT=1 docker build -f "${base_dir}/Dockerfile_custom" -t "${image_name}:latest" --build-arg DEV_MODE=false "${base_dir}"
echo "Tag container image ${image_name}:latest as ${image_name}:${image_tag}"
docker tag "${image_name}:latest" "${image_name}:${image_tag}"
retval=$?
if [ $retval -ne 0 ]; then
    echo "Error ${retval}"
    exit ${retval}
fi
