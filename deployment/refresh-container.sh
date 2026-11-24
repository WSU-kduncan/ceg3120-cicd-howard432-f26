#!/bin/bash

set -e

IMAGE="mandyhoward21/howard-cicd-f26:latest"
CONTAINER="howard-cd-app"

echo "Stopping the old container..."
docker stop "$CONTAINER" 2>/dev/null || true

echo "Removing the old container..."
docker rm "$CONTAINER" 2>/dev/null || true

echo "Pulling the latest docker image..."
docker pull "$IMAGE"

echo "Starting the new container..."
docker run -d \
  --name "$CONTAINER" \
  --restart unless-stopped \
  -p 80:80 \
  "$IMAGE"

echo "The Deployment is Complete"
