#!/usr/bin/env bash

PROJECT_ID=$(gcloud config get-value project)
REGION="europe-southwest1"
REPO="devops-playground"
SERVICE_BASE="ephemeral-env"

IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$SERVICE_BASE:latest"
