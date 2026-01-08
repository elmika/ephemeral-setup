#!/usr/bin/env bash
set -e

sourve ./env.sh

echo "Building image (amd64)..."
docker build --platform=linux/amd64 \
  -t "$IMAGE" \
  .

echo "Pushing image to Artifact Registry..."
docker push "$IMAGE"

echo "Done: $IMAGE"
