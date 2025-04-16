#!/bin/bash
# $1=acrName, $2=superset-version, $3=container-tag
base_dir="$(pwd)"
superset_dir="$(pwd)/build/superset"
echo "Customization directory: $(pwd)"
echo "Superset build directory: ${superset_dir}"

echo "Invoke patch-superset.sh ${base_dir} ${superset_dir}"
source ./patch-superset.sh "${base_dir}" "${superset_dir}"

echo "Show available memory"
free -m

echo "Build container image: ${image_name}:latest"
DOCKER_BUILDKIT=1 docker build -f "${superset_dir}/Dockerfile" -t "pa-superset-base:latest" --build-arg DEV_MODE=false "${superset_dir}"
retval=$?
if [ $retval -ne 0 ]; then
    echo "Error ${retval}"
    exit ${retval}
fi
DOCKER_BUILDKIT=1 docker build -f "${base_dir}/Dockerfile_custom" -t "${image_name}:latest" --build-arg DEV_MODE=false "${base_dir}"
retval=$?
if [ $retval -ne 0 ]; then
    echo "Error ${retval}"
    exit ${retval}
fi
echo "Tag container image ${image_name}:latest as ${image_name}:${image_tag}"
docker tag "${image_name}:latest" "${image_name}:${image_tag}"
retval=$?
if [ $retval -ne 0 ]; then
    echo "Error ${retval}"
    exit ${retval}
fi
