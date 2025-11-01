## GitOps Deployment with ArgoCD

This repository contains the Kubernetes manifests for deploying the Quote API application to AKS using a GitOps workflow with ArgoCD.

### How It Works

- **Manifests as Source of Truth**: All Kubernetes resources (Deployments, Services, ConfigMaps, etc.) are stored here. ArgoCD continuously monitors this repository for changes.  
- **Automated Deployment**: When a manifest is updated—such as a new Docker image tag pushed by the CI pipeline—ArgoCD detects the change and automatically applies it to the AKS cluster.  
- **Desired State Management**: ArgoCD ensures that the live cluster state always matches the manifests in this repository. If drift occurs, ArgoCD can automatically or manually reconcile the differences.  
- **Observability & Rollbacks**: Every change is versioned via Git, making it easy to track deployments and roll back by reverting a commit.  

This setup enables a clear separation of concerns: CI pipelines build and publish Docker images, while ArgoCD handles continuous delivery and ensures the cluster matches the GitOps manifests.
