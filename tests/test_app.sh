#!/bin/bash

set -e

echo "================================="
echo "JenkinsOps Application Tests"
echo "================================="

PASS=0
FAIL=0

if [ -f "app/index.html" ]; then
    echo "✓ index.html exists"
    ((PASS+=1))
else
    echo "✗ index.html missing"
    ((FAIL+=1))
fi

if grep -q "JenkinsOps" app/index.html; then
    echo "✓ JenkinsOps title found"
    ((PASS+=1))
else
    echo "✗ JenkinsOps title missing"
    ((FAIL+=1))
fi

if grep -q "Self-Healing CI/CD" app/index.html; then
    echo "✓ CI/CD description found"
    ((PASS+=1))
else
    echo "✗ CI/CD description missing"
    ((FAIL+=1))
fi

echo ""
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [ "$FAIL" -gt 0 ]; then
    echo "Tests failed."
    exit 1
fi

echo "All tests passed!"