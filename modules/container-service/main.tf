# Kubernetes Deployment for the containerized service
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}


resource "kubernetes_deployment" "main" {
  metadata {
    name = var.service_name
    labels = {
      app = var.service_name
    }
  }

  spec {
    replicas = var.service_replicas

    selector {
      match_labels = {
        app = var.service_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.service_name
        }
      }

      spec {
        container {
          image = var.service_image
          name  = var.service_name

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

# Kubernetes Service to expose the deployment
resource "kubernetes_service" "main" {
  metadata {
    name = var.service_name
  }

  spec {
    selector = {
      app = var.service_name
    }

    port {
      port        = 80
      target_port = var.container_port
    }

    type = var.service_type
  }
}