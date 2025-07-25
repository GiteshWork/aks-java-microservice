<div align="center">

🚀 End-to-End CI/CD Platform on Azure with GitLab and GitOps 🚀
</div>

This project demonstrates the creation of a complete, production-grade CI/CD and GitOps platform on Microsoft Azure. It provisions an Azure Kubernetes Service (AKS) cluster using Azure Bicep, deploys a Java microservice, and establishes a fully automated workflow from code commit to live deployment using GitLab CI and Argo CD.

Project Objective
To build an end-to-end, automated deployment pipeline showcasing proficiency in:

Cloud Infrastructure Provisioning (Azure)

Infrastructure as Code (Azure Bicep)

Container Orchestration (Kubernetes on AKS)

Continuous Integration & Delivery (GitLab CI, Argo CD)

GitOps Principles

Code Quality & Security Integration (SonarCloud)

Technologies Used
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

Architecture Diagram
Project Structure
This project utilizes two distinct Git repositories to enforce a clean separation between application code and deployment configuration, a core principle of GitOps.

Application Repository (aks-java-demo)

aks-java-demo/
├── src/                     # Java application source code
├── build.gradle             # Gradle build and SonarQube configuration
├── Dockerfile               # Multi-stage Docker build instructions
├── .gitlab-ci.yml           # GitLab CI pipeline definition
├── main.bicep               # Azure Bicep IaC file
└── README.md                # Project documentation (this file)

Configuration Repository (aks-java-demo-config)

aks-java-demo-config/
├── deployment.yaml          # Kubernetes Deployment manifest
└── service.yaml             # Kubernetes Service manifest

Prerequisites
Before starting, ensure you have the following installed and configured:

Azure Account: With an active subscription.

Azure CLI: Installed and configured (az login).

GitLab Account: A free account on GitLab.com.

SonarCloud Account: A free account, linked to your GitLab account.

kubectl: Kubernetes command-line tool.

Docker Desktop: For local container testing.

Git: Version control system.

Setup & Deployment Instructions
Follow these steps to provision the infrastructure and deploy the application.

Phase 1: Provision Azure Infrastructure using Bicep
This step creates the AKS cluster and the Azure Container Registry.

Clone the Application Repository:

git clone https://gitlab.com/giteshwork-group/aks-java-demo.git
cd aks-java-demo

Create an Azure Resource Group:

az group create --name MyProject-RG --location "East US"

Deploy the Bicep Template: This will provision all Azure resources. This step takes 15-25 minutes.

az deployment group create --resource-group MyProject-RG --template-file main.bicep

Configure kubectl: After the deployment completes, run this command to configure your local kubectl to communicate with your new AKS cluster.

az aks get-credentials --resource-group MyProject-RG --name my-java-aks-cluster

Verify EKS Cluster Nodes: Confirm your worker nodes are Ready.

kubectl get nodes

Phase 2: Install & Configure Argo CD on AKS
This sets up the GitOps continuous delivery tool inside your cluster.

Create argocd Namespace:

kubectl create namespace argocd

Apply Argo CD Installation Manifests:

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Access Argo CD UI via Port-Forwarding: Open a new terminal and run the following command to create a secure tunnel.

kubectl port-forward svc/argocd-server -n argocd 8080:443

Get Argo CD Admin Password:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

Access Argo CD UI: Open your browser to https://localhost:8080. Log in with username admin and the password you just copied.

Phase 3: Prepare Repositories and Deploy Application
This final phase connects all the pieces.

Create the Configuration Repository: In GitLab, create a new, empty, public repository named aks-java-demo-config. Clone it locally, add the deployment.yaml and service.yaml files, and push them to the main branch.

Integrate AKS with ACR: Grant your AKS cluster permissions to pull images from your private ACR.

az aks update -n my-java-aks-cluster -g MyProject-RG --attach-acr <your-acr-name>

Deploy the Application via Argo CD:

In the Argo CD UI, click "+ NEW APP".

Application Name: aks-demo-app

Project Name: default

Sync Policy: Automatic (check Prune Resources and Self Heal)

Repository URL: https://gitlab.com/giteshwork-group/aks-java-demo-config.git

Revision: HEAD

Path: .

Destination Cluster: https://kubernetes.default.svc

Namespace: default

Click CREATE.

Phase 4: Trigger the Full CI/CD Workflow
Ensure your aks-java-demo application repository is fully configured with the correct .gitlab-ci.yml file and all necessary CI/CD variables (ACR credentials, SonarCloud tokens, and the SSH deploy key).

Make a code change in the aks-java-demo repository.

Commit and push the change to the main branch.

git push origin main

Observe the Automation:

Watch the pipeline run to completion in GitLab.

Check the aks-java-demo-config repository for a new commit made by the pipeline.

Watch in the Argo CD UI as the application automatically syncs and deploys the new version.

Cleanup Instructions
To avoid further AWS charges, it is CRITICAL to destroy all resources once you are finished.

Navigate to your application directory:

cd aks-java-demo

Destroy all resources: This will remove the AKS cluster, ACR, and all associated networking and storage resources. This step also takes 15-25 minutes.

az group delete --name MyProject-RG --yes --no-wait
