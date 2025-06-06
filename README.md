# Terraform EKS Deployment Project



## 📝 Assignment Summary
Deploy a containerized service to AWS EKS with all required infrastructure (VPC, networking, security) using Terraform modules.  
**Expected completion time:** 1-2 hours.

![web_image](https://github.com/user-attachments/assets/fe39a1da-9ad0-47b6-9c18-65a951c89cab)  

---

## 🛠️ Deployment Guide

### Prerequisites
- AWS account with IAM permissions for EKS, VPC, and IAM
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0+)
- [AWS CLI](https://aws.amazon.com/cli/) configured
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### Step 1: Clone Repository
git clone https://github.com/neverscores/terraform-eks-deployment.git
cd terraform-eks-deployment


### Step 2: Initialize terraform
terraform init


### Step 3: Deploy Infrastrucutre
terraform apply -auto-approve

This creates:

VPC with public/private subnets
EKS cluster with managed node group
NGINX service with LoadBalancer

### Step 4: Access the cluster
aws eks --region $(terraform output -raw region) update-kubeconfig \
  --name $(terraform output -raw cluster_name)

### Step 5: Verify Deployment
kubectl get svc hiive-service -o wide

Access your service at:
http://$(kubectl get svc hiive-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

Key Design Decisions
1. Modular Structure: The project is organized into reusable modules (VPC, EKS, Container Service) following Terraform best practices. This separation allows for better maintainability and reusability of components.

2. High Availability: The VPC module creates resources across 3 availability zones with both public and private subnets, ensuring high availability for the EKS cluster and worker nodes.

3. Security: IAM roles with least-privilege policies are created for both the EKS cluster and worker nodes. The private subnets provide an additional layer of security for worker nodes.

4. Scalability: The node group is configured with auto-scaling parameters (desired, min, max size) to handle varying workloads efficiently.

5. Separation of Concerns: The container service module handles only Kubernetes resources, keeping infrastructure and application layers separate.