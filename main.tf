# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Configure Kubernetes provider after EKS cluster is created
provider "kubernetes" {
  alias                  = "eks" 
  host                   = module.eks-cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks-cluster.cluster_name
    ]
  }
}

# Create VPC and networking resources
module "vpc" {
  source = "./modules/vpc"

  region       = var.region
  cluster_name = var.cluster_name
}

# Create EKS cluster and node groups
module "eks-cluster" {
  source = "./modules/eks-cluster"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  node_group_name = var.node_group_name
  instance_types  = var.instance_types
  desired_size    = var.desired_size
  min_size        = var.min_size
  max_size        = var.max_size
}

# Deploy containerized service to EKS
module "container-service" {
  source = "./modules/container-service"

  service_name     = var.service_name
  service_image    = var.service_image
  service_replicas = var.service_replicas
  container_port   = var.container_port
  service_type     = var.service_type

  providers = {
    kubernetes = kubernetes.eks
  }

  depends_on = [module.eks-cluster]
}