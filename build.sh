#!/bin/bash
set -e

# 設定變數
DOCKER_USER="${DOCKER_USER:-vanisoul}"
IMAGE_NAME="soulmask-ops-web"
VERSION="${1:-latest}"

echo "Building ${DOCKER_USER}/${IMAGE_NAME}:${VERSION} ..."

docker build . --build-arg VERSION="${VERSION}" -t "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"

echo "Pushing ${DOCKER_USER}/${IMAGE_NAME}:${VERSION} ..."
docker push "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"

# 同時推送 latest tag
if [ "${VERSION}" != "latest" ]; then
  docker tag "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}" "${DOCKER_USER}/${IMAGE_NAME}:latest"
  docker push "${DOCKER_USER}/${IMAGE_NAME}:latest"
fi

echo "Done! Image pushed: ${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"
