🚀 DevOps CI/CD Infrastructure Pipeline on Azure (AKS, Bicep, GitLab CI, ArgoCD)
This project demonstrates the creation of a complete CI/CD infrastructure pipeline on Microsoft Azure using Infrastructure as Code (IaC) principles. It provisions an Azure Kubernetes Service (AKS) cluster using Azure Bicep, builds and deploys a Java microservice with GitLab CI, and implements a GitOps workflow using Argo CD. Code quality checks are integrated using SonarCloud, and container images are managed through Azure Container Registry (ACR).

🎯 Project Objective
To build an end-to-end, production-grade CI/CD pipeline showcasing proficiency in:

Cloud Infrastructure Provisioning (Azure)

Infrastructure as Code (Azure Bicep)

Container Orchestration (Kubernetes on AKS)

Continuous Integration & Delivery (GitLab CI, Argo CD)

GitOps Principles

Code Quality & Security Integration (SonarCloud)

Service Mesh (Istio)

🔧 Technologies Used
Category	Technology
Cloud Platform	Microsoft Azure
Container Orchestration	Azure Kubernetes Service (AKS)
CI/CD	GitLab CI
GitOps	Argo CD
Infrastructure as Code	Azure Bicep
Containerization	Docker
Artifact Management	Azure Container Registry (ACR)
Code Quality & Analysis	SonarCloud
Application Stack	Java (Spring Boot), Gradle
Authentication	Azure AD (Service Principals), SSH Keys
Service Mesh	Istio

📁 Project Structure
📦 Application Repository: aks-java-demo
graphql
Copy
Edit
aks-java-demo/
├── src/                    # Java application source code
├── build.gradle            # Gradle build configuration
├── Dockerfile              # Multi-stage Docker build
├── .gitlab-ci.yml          # GitLab CI pipeline
├── main.bicep              # Azure Bicep IaC file
└── README.md               # Project documentation
⚙️ Configuration Repository: aks-java-demo-config
bash
Copy
Edit
aks-java-demo-config/
├── deployment.yaml         # Kubernetes Deployment manifest
└── service.yaml            # Kubernetes Service manifest
🧰 Prerequisites
Ensure the following are installed and configured:

Azure CLI (az login)

GitLab account with a personal access token

SonarCloud account linked with GitLab

Docker Desktop

kubectl

Git

SSH deploy keys

🚀 Setup & Deployment Instructions
1️⃣ Provision Azure Infrastructure using Bicep
bash
Copy
Edit
# Clone the application repo
git clone https://gitlab.com/giteshwork-group/aks-java-demo.git
cd aks-java-demo

# Create Resource Group
az group create --name MyProject-RG --location "East US"

# Deploy resources via Bicep
az deployment group create --resource-group MyProject-RG --template-file main.bicep

# Configure kubectl
az aks get-credentials --resource-group MyProject-RG --name my-java-aks-cluster

# Verify node status
kubectl get nodes
2️⃣ Install & Configure Argo CD on AKS
bash
Copy
Edit
# Create Argo CD namespace
kubectl create namespace argocd

# Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Access Argo CD UI (Local)
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get initial password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
Access: https://localhost:8080
Login: admin / <your-password>

3️⃣ Setup Configuration Repository & GitOps
bash
Copy
Edit
# Create and push the config repo manually via GitLab
git clone https://gitlab.com/giteshwork-group/aks-java-demo-config.git
cd aks-java-demo-config
# Add deployment.yaml and service.yaml, then push
Grant AKS permission to pull from ACR:

bash
Copy
Edit
az aks update -n my-java-aks-cluster -g MyProject-RG --attach-acr <your-acr-name>
Deploy App via Argo CD UI:

App Name: aks-demo-app

Repo URL: https://gitlab.com/giteshwork-group/aks-java-demo-config.git

Revision: HEAD

Path: .

Sync Policy: Automatic (enable Prune & Self-Heal)

Destination Cluster: https://kubernetes.default.svc

Namespace: default

4️⃣ Trigger CI/CD Workflow
bash
Copy
Edit
# Make a code change in aks-java-demo
git add .
git commit -m "Feature: Updated Java logic"
git push origin main
This triggers:

GitLab CI → Builds image → Pushes to ACR

CI pushes new manifest to aks-java-demo-config

Argo CD auto-syncs → Updates app on AKS

🧹 Cleanup Instructions
bash
Copy
Edit
# Destroy all Azure resources
az group delete --name MyProject-RG --yes --no-wait
📸 Screenshots
GitLab CI pipeline run

Argo CD UI showing Synced/Healthy status

AKS nodes

Application running (kubectl get svc, etc.)

🙌 About
A modern DevOps reference architecture on Azure using GitOps principles, CI/CD automation, service mesh integration, and IaC.

🔗 Resources
AKS Documentation

Azure Bicep

GitLab CI/CD

Argo CD

SonarCloud

