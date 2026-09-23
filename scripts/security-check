#!/bin/bash

set -e

echo "================================="
echo "JenkinsOps Security Check"
echo "================================="

echo "Checking for accidentally committed secrets..."

if grep -RniE \
    --exclude-dir=.git \
    --exclude=security-check.sh \
    "AKIA[0-9A-Z]{16}|BEGIN PRIVATE KEY|password=" \
    .; then

    echo "✗ Possible secret detected!"
    exit 1

else

    echo "✓ No obvious secrets detected."
fi

echo ""
echo "Security check passed."