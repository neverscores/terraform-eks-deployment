output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks-cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks-cluster.cluster_endpoint
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "service_endpoint" {
  description = "Endpoint for the deployed service"
  value       = module.container-service.service_endpoint
}