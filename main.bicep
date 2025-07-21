// main.bicep

// --- Parameters ---
// These are like variables you can change easily.
@description('The name of your AKS cluster.')
param clusterName string = 'my-java-aks-cluster'

@description('The Azure region where resources will be deployed.')
param location string = resourceGroup().location

@description('The number of nodes (VMs) in the cluster.')
param nodeCount int = 2

@description('The size of the VMs for the nodes.')
param vmSize string = 'Standard_B2s' // A good, cost-effective size for learning

// --- Resource Definition ---
// This is the core part where you declare what you want Azure to build.
resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-08-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: nodeCount
        vmSize: vmSize
        mode: 'System'
        osType: 'Linux'
      }
    ]
  }
}

// --- Outputs ---
// This will print the cluster name after deployment.
output aksClusterName string = aksCluster.name