#!/bin/bash
# $1=acrName, $2=superset-version, $3=container-tag
echo "Customization directory: $(pwd)"
base_dir="$(pwd)"
superset_dir="$(pwd)/build/superset"
mkdir -p "${superset_dir}"
echo "Superset build directory: ${superset_dir}"
echo "git clone superset (${superset_version})"
git clone --depth 1 --branch ${superset_version} https://github.com/apache/superset.git "${superset_dir}"


echo "Clean docker environment"
docker system prune -a -f