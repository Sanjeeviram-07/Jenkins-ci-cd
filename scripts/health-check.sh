#!/bin/bash

URL=${1:-http://localhost}

echo "================================="
echo "JenkinsOps Health Check"
echo "================================="

echo "Checking: $URL"

HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")

echo "HTTP Status: $HTTP_STATUS"

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✓ Application is healthy"
    exit 0
else
    echo "✗ Application health check failed"
    exit 1
fi