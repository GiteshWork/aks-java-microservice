End-to-End Cloud-Native Delivery Platform on Microsoft Azure
This repository contains the source code and CI/CD pipeline configuration for a production-grade, fully automated software delivery platform built on Microsoft Azure. The project demonstrates a modern approach to deploying a Java microservice to Kubernetes using GitOps principles, Infrastructure as Code, and a security-first mindset.

The goal of this project is to create a complete, touchless workflow that takes a code change from a developer's machine and safely deploys it to a live Kubernetes cluster with no manual intervention.

Architecture Diagram
The following diagram illustrates the complete workflow, from code commit to live deployment:

Key Features
Automated CI/CD: The entire build, test, and deployment process is automated using GitLab CI.

Infrastructure as Code (IaC): All Azure resources (AKS, ACR, etc.) are defined declaratively using Azure Bicep for repeatable and version-controlled environments.

GitOps-Powered Deployments: Continuous Deployment is managed by Argo CD, which uses a dedicated Git repository as the single source of truth for the application's state in Kubernetes.

Integrated Code Quality & Security: SonarCloud is integrated directly into the CI pipeline, acting as a quality gate to block vulnerabilities and low-quality code before deployment.

Containerized Application: The Java application is packaged into a minimal, secure Docker container using a multi-stage build process.

Secure Artifact Management: Versioned Docker images are stored in a private Azure Container Registry (ACR).

Advanced Networking & Security: A Service Mesh (Istio) is deployed to provide zero-trust networking (mTLS), traffic management, and deep observability without any changes to the application code.

Tech Stack
Category

Technology

Cloud Platform

Microsoft Azure

Orchestration

Azure Kubernetes Service (AKS)

CI/CD & GitOps

GitLab CI, Argo CD

Infrastructure as Code

Azure Bicep

Containerization

Docker

Artifact Registry

Azure Container Registry (ACR)

Code Quality

SonarCloud

Application

Java, Spring Boot, Gradle

Service Mesh

Istio

Authentication

Azure AD (Service Principals), SSH Deploy Keys

Project Setup Guide
To replicate this project, you will need the following prerequisites and must follow the setup steps in order.

Prerequisites:
An Azure account with an active subscription.

A GitLab.com account.

A SonarCloud.io account, linked to your GitLab account.

The following tools installed locally: Azure CLI, kubectl, Docker Desktop, Git.

Phase 1: Provision Core Infrastructure
Clone this repository (aks-java-demo).

Log in to Azure via the CLI: az login.

Create a resource group: az group create --name MyProject-RG --location "East US".

Deploy the Azure Bicep file to create the AKS cluster and ACR:

az deployment group create --resource-group MyProject-RG --template-file main.bicep

Configure kubectl to connect to your new cluster:

az aks get-credentials --resource-group MyProject-RG --name my-java-aks-cluster

Phase 2: Configure CI/CD Pipeline
Create Repositories: Create two empty, public repositories on GitLab: aks-java-demo (for this application code) and aks-java-demo-config (for Kubernetes manifests).

Push Application Code: Push the code from this project to your aks-java-demo repository.

Configure ACR Authentication: Create a Service Principal in Azure and assign it the AcrPush role on your ACR instance.

Configure SonarCloud: Set up your project on SonarCloud and get the organization and project keys.

Set GitLab CI/CD Variables: In the aks-java-demo project settings, configure the following variables:

ACR_URL, ACR_SP_USERNAME, ACR_SP_PASSWORD

SONAR_HOST_URL, SONAR_TOKEN

GIT_SSH_PRIVATE_KEY (for the deploy key to the config repo).

Configure Deploy Key: Add the public part of the SSH key as a "Deploy Key" with write access to the aks-java-demo-config repository.

Phase 3: Configure GitOps & Argo CD
Create Manifests: In your local clone of the aks-java-demo-config repository, create deployment.yaml and service.yaml files. Push them to the repository.

Install Argo CD: Install Argo CD into your AKS cluster:

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Connect AKS to ACR: Grant the AKS cluster pull access to your private ACR:

az aks update -n my-java-aks-cluster -g MyProject-RG --attach-acr <your-acr-name>

Deploy the App via Argo CD: Access the Argo CD UI via port-forwarding and create a new application, pointing it to your aks-java-demo-config repository.

How to Trigger the Automated Workflow
The entire end-to-end pipeline is triggered by a single action:

Make a code change in the aks-java-demo application repository.

Commit and push the change to the main branch:

git push origin main

This will automatically kick off the CI pipeline, which in turn will trigger the CD pipeline by updating the configuration repository, leading to an automated deployment in AKS.

Cleanup
To avoid ongoing costs, destroy all created Azure resources by deleting the resource group.
Warning: This action is irreversible.

az group delete --name MyProject-RG --yes --no-wait
