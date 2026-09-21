#!/bin/bash

echo "================================="
echo "Running Application Tests"
echo "================================="

if [ -f "app/index.html" ]; then
    echo "✓ index.html exists"
else
    echo "✗ index.html missing"
    exit 1
fi

if grep -q "JenkinsOps" app/index.html; then
    echo "✓ JenkinsOps application detected"
else
    echo "✗ Application content invalid"
    exit 1
fi

if grep -q "Self-Healing CI/CD" app/index.html; then
    echo "✓ CI/CD description detected"
else
    echo "✗ CI/CD description missing"
    exit 1
fi

echo ""
echo "All tests passed!"