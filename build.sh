#!/bin/bash
set -e

# 設定變數
DOCKER_USER="${DOCKER_USER:-ga2006088445}"
IMAGE_NAME="soulmask-ops-web"
VERSION="${1:-latest}"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"

echo "Building ${DOCKER_USER}/${IMAGE_NAME}:${VERSION} for platforms: ${PLATFORMS} ..."

# 確保 buildx builder 存在
docker buildx inspect multibuilder > /dev/null 2>&1 || \
  docker buildx create --name multibuilder --use

docker buildx use multibuilder

# 建立 tags 參數
TAGS="-t ${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"
if [ "${VERSION}" != "latest" ]; then
  TAGS="${TAGS} -t ${DOCKER_USER}/${IMAGE_NAME}:latest"
fi

# 一次 build + push（buildx 直接推送，不需要額外 docker push）
docker buildx build \
  --platform "${PLATFORMS}" \
  --build-arg VERSION="${VERSION}" \
  ${TAGS} \
  --push \
  .

echo "Done! Image pushed: ${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"