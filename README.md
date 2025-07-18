# Base Image For Dev In Docker Multi Staged Layers

Below is a script for memo that explains how build and push

```sh

#!/bin/bash

# Build the workspace shell image
docker build -t cdaprod/workspace-shell:latest -f Dockerfile.workspace-shell .

# Tag with additional version if needed
docker tag cdaprod/workspace-shell:latest cdaprod/workspace-shell:v0.1.0

# Login to Docker Hub (if not already logged in)
docker login

# Push to Docker Hub
docker push cdaprod/workspace-shell:latest
docker push cdaprod/workspace-shell:v0.1.0

# Optional: Test the image locally
echo "Testing the image locally..."
docker run -it --rm cdaprod/workspace-shell:latest

# Optional: Run with a mounted workspace
echo "Running with mounted workspace..."
docker run -it --rm -v $(pwd):/home/appuser/workspace cdaprod/workspace-shell:latest
```