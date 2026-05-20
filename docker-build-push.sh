#!/usr/bin/env bash

set -eou pipefail

image_name=node-hostname
timestamp="$(date +%Y%m%d-%H%M)"
commit="$(git rev-parse --short HEAD)"
tag="$timestamp-$commit"

fqin=europe-north1-docker.pkg.dev/default-418011/docker-repo/$image_name:$tag

docker build \
  --progress=plain \
  --platform="linux/amd64" \
  --push \
  -t "$fqin" \
  -f Dockerfile \
  node-hostname

echo "Built $fqin"
