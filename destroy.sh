#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./destroy.sh <env>"
  exit 1
fi

ENV_NAME="$1"

source ./env.sh

SERVICE_NAME="$SERVICE_BASE-$ENV_NAME"

echo "Deleting $SERVICE_NAME from project $PROJECT_ID"

gcloud run services delete "$SERVICE_NAME" \
  --region "$REGION" \
  --quiet
