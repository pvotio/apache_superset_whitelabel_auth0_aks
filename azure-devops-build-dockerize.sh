#!/bin/bash
# $1=acrName, $2=superset-version, $3=container-tag
base_dir="$(pwd)"
superset_dir="$(pwd)/build/superset"
echo "Customization directory: $(pwd)"
echo "Superset build directory: ${superset_dir}"

echo "Build container image: ${image_name}:latest"
docker build -t "${image_name}:latest" --build-arg DOCKERIZE_VERSION=${dockerize_version} -f "${superset_dir}/dockerize.Dockerfile" "${superset_dir}"
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

