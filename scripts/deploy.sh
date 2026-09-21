#!/bin/bash

set -e

IMAGE_NAME=${IMAGE_NAME:-jenkinsops}
CONTAINER_NAME=${CONTAINER_NAME:-jenkinsops-app}
PORT=${PORT:-8080}

echo "================================="
echo "JenkinsOps Deployment"
echo "================================="

echo "Image       : $IMAGE_NAME"
echo "Container   : $CONTAINER_NAME"
echo "Port        : $PORT"

echo ""
echo "Stopping previous container..."

docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

echo "Starting new container..."

docker run -d \
    --name "$CONTAINER_NAME" \
    -p "$PORT:80" \
    "$IMAGE_NAME"

echo ""
echo "Deployment completed."

docker ps --filter "name=$CONTAINER_NAME"