# Apache Superset Whitelabel (Auth0) on AKS

This repository contains a customized (whitelabeled) version of Apache Superset designed to run on Azure Kubernetes Service (AKS). It includes scripts and pipeline definitions to:

- Patch Superset’s UI for custom branding (colors, logos, etc.).
- Integrate with Auth0 (or other OAuth2 identity providers) for Single Sign-On.
- Build and push Docker images to Azure Container Registry (ACR).
- Deploy onto AKS using Kubernetes manifests.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Local Build Instructions](#local-build-instructions)
- [Azure DevOps Build Pipeline](#azure-devops-build-pipeline)
- [Kubernetes Manifests](#kubernetes-manifests)
- [Configuration & Customization](#configuration--customization)
- [Deploying to AKS](#deploying-to-aks)
- [Contributing](#contributing)
- [License](#license)

## Overview

Apache Superset is an open-source data exploration and visualization platform. This repository:

- Whitelabels Superset (logo, colors, icons).
- Integrates with Auth0 for Single Sign-On.
- Builds Docker images (via local scripts or Azure DevOps pipelines) and pushes them to an Azure Container Registry.
- Provides Kubernetes manifests (Deployments, Ingress, Jobs, ConfigMaps, and Secrets) for easy deployment on AKS.
- Extends Superset with custom views for reporting and Azure Blob Storage links.

## Features

### Custom Branding
- A `patch-superset.sh` script modifies UI colors, logos, and various appearance settings in the Superset source code.

### Auth0 (OAuth) Integration
- Uses custom classes (`CustomAuthOauthView`, `CustomSsoSecurityManager`) to handle Auth0 login flows, role synchronization, and logout.

### Extended Functionality
- Demonstrates custom endpoints (e.g. `reporting_service.py`, `blob_storage.py`) integrated into Superset.
- Includes additional environment variables and a custom config in `superset_config.py` for advanced features like Azure Blob Storage.

### Azure DevOps Integration
- A pipeline (`build-pipeline.yaml`) automates building, patching, and pushing Docker images to ACR.

### AKS Deployment Manifests
- YAML files to define Superset’s Web and Celery Worker deployments, an initialization job, an Ingress, and ConfigMaps/Secrets for environment variables.

## Repository Structure

```plaintext
apache_superset_whitelabel_auth0_aks/
├── build-pipeline.yaml
├── azure-devops-build.sh
├── Dockerfile_custom
├── local-build.sh
├── patch-superset.sh
├── files/
│   ├── *.svg
│   ├── reporting_service.py
│   ├── blob_storage.py
│   ├── setupFormatters.ts
│   ├── HandlebarsViewer.tsx
│   ├── python_requirements.txt
├── deployment-yamls/
│   ├── deployment-web.yaml
│   ├── deployment-worker.yaml
│   ├── init-job.yaml
│   ├── ingress.yaml
│   ├── superset-env-configmap.yaml
│   └── superset-files-configmap.yaml
└── README.md
```

## Local Build Instructions

### Prerequisites

- Docker installed and running.
- Logged into your target Azure Container Registry:
```bash
az acr login --name <YOUR_ACR_NAME>
# or
docker login <YOUR_ACR_NAME>.azurecr.io
```

### Run the local build script

```bash
./local-build.sh
```

This script:

- Clones Apache Superset.
- Runs `patch-superset.sh`.
- Builds a base image and a final image with extra Python dependencies.
- Pushes the image to your ACR.

### Confirm the image

```bash
docker images
```

Look for: `xxxxxxxx.azurecr.io/xx-superset:latest`

## Azure DevOps Build Pipeline

### Definition

- Installs Docker.
- Clones repo and runs `azure-devops-build.sh`.
- Builds and pushes Docker images with appropriate tags.

### Parameters & Variables

- `supersetVersion`, `acrName`, `imageName`, `buildTag`, etc.

### Customizing

Adjust the pipeline to suit your environment.

## Kubernetes Manifests

### `deployment-web.yaml`

- Web UI on port `8088`
- Mounts configuration volumes and secrets from Azure Key Vault

### `deployment-worker.yaml`

- Celery workers for async tasks
- Depends on Redis and Postgres

### `init-job.yaml`

- Seeds DB and creates the admin user
- Run once per environment

### `ingress.yaml`

- External access via NGINX ingress controller

### `superset-env-configmap.yaml`

- Environment variables for Superset and Celery

### `superset-files-configmap.yaml`

- A Kubernetes Secret storing Superset’s Python and shell config

## Configuration & Customization

### Auth0 / OAuth

- Env vars for `AUTH0_URL`, `AUTH0_CLIENT_KEY`, etc.
- Custom view + security manager classes handle SSO logic

### Branding & UI

- Modify `color_subt`, `color_subt2` arrays in `patch-superset.sh`
- Update paths to logos/icons in `superset_config.py`

### Key Vault Integration (CSI)

- Secrets mounted via CSI driver at runtime and exported using `superset_bootstrap.sh`

## Deploying to AKS

### Step-by-step

```bash
kubectl apply -f kubernetes/superset-env-configmap.yaml
kubectl apply -f kubernetes/superset-files-configmap.yaml
kubectl apply -f kubernetes/init-job.yaml
kubectl logs job/superset-init-db -f

kubectl apply -f kubernetes/deployment-web.yaml
kubectl apply -f kubernetes/deployment-worker.yaml
kubectl apply -f kubernetes/ingress.yaml
```

### Validate

```bash
kubectl get pods -n apps-public
kubectl logs deployment/superset-web -n apps-public
```

## Contributing

- Open an issue for bugs/feature requests
- Submit PRs with appropriate test coverage

## License

Apache License 2.0. See `LICENSE` for details.

**Disclaimer**: Not affiliated with the Apache Software Foundation. Custom code is maintained by the contributors.

---

**Enjoy exploring data and building dashboards with your whitelabeled Apache Superset on AKS!**
