#!/bin/bash

set -e

CONTAINER_NAME=${CONTAINER_NAME:-jenkinsops-app}
PREVIOUS_IMAGE=${PREVIOUS_IMAGE:-jenkinsops:previous}
PORT=${PORT:-8080}

echo "================================="
echo "JenkinsOps Automatic Rollback"
echo "================================="

echo "Previous image: $PREVIOUS_IMAGE"

echo "Stopping failed deployment..."

docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo "Restoring previous version..."

docker run -d \
    --name "$CONTAINER_NAME" \
    -p "$PORT:80" \
    "$PREVIOUS_IMAGE"

echo ""
echo "Rollback completed."

docker ps --filter "name=$CONTAINER_NAME"