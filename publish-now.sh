#!/bin/bash
# Quick publishing script to complete the release process

echo "Starting final publishing process..."

# Create tags directly
git tag aicrm-sdk-v0.1.0 -m "Release aicrm-sdk v0.1.0"
git tag biscol-v0.1.0 -m "Release biscol v0.1.0" 
git tag cci-sat-v0.1.0 -m "Release cci-sat v0.1.0"
git tag imo-eo-v0.1.0 -m "Release imo-eo v0.1.0"

echo "Tags created successfully!"

# Show what we have
git tag -l | grep "v0.1.0"

echo "Publishing complete! Ready to push to GitHub."