#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./deploy.sh <env>"
  exit 1
fi

ENV_NAME="$1"

source ./env.sh

SERVICE_NAME="$SERVICE_BASE-$ENV_NAME"

echo "Deploying $SERVICE_NAME"
echo "Project: $PROJECT_ID"
echo "Image: $IMAGE"

gcloud run deploy "$SERVICE_NAME" \
  --image "$IMAGE" \
  --region "$REGION" \
  --allow-unauthenticated
