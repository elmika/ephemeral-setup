#!/usr/bin/env bash
set -e

MODE="${1:-DEV}" # DEV | PROD

if [ "$MODE" = "PROD" ]; then
  source ./env-prod.sh

  echo "PRODUCTION BUILD & PUSH"
  echo "Project: $PROJECT_ID"
  echo "Repo: $REPO"
  echo "Image: $IMAGE"
  echo 

  read -p "Type PUSH-PROD to continue: " CONFIRM
  if [ "$CONFIRM" != "PUSH-PROD" ]; then
    echo "Aborted."
    exit 1
  fi
else
  source ./env.sh
  echo "Dev build and push -> $IMAGE"
fi

echo "Building image (amd64)..."
docker build --platform=linux/amd64 \
  -t "$IMAGE" \
  .

echo "Pushing image to Artifact Registry..."
docker push "$IMAGE"

echo "Done: $IMAGE"
