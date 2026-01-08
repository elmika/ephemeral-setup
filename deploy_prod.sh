#!/usr/bin/env bash
set -e

source ./env-prod.sh

echo "! PRODUCTION DEPLOY"
echo "Project: $PROJECT_ID"
echo "Region: $REGION"
echo "Service: $PROD_SERVICE"
echo "Image: $IMAGE"

read -p "Type DEPLOY to continue: " CONFIRM
if [ "$CONFIRM" != "DEPLOY" ]; then
  echo "Aborted."
  exit 1
fi

gcloud run deploy "$PROD_SERVICE" \
  --project "$PROJECT_ID" \
  --image "$IMAGE" \
  --region "$REGION" \
  --no-allow-unauthenticated

