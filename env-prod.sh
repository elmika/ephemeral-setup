#!/usr/bin/env bash

PROJECT_ID="devops-playground-480421"
REGION="europe-southwest1"

# Repo de Artifact Registry en prod
REPO="prod"
SERVICE_BASE="directory"

# Imagen de prod: NO latest. Usa prod (o sha, por ahora prod).
IMAGE="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$SERVICE_BASE:prod"

# Nombre de servicio Cloud Run en prod
PROD_SERVICE="directory"
