variable "service_name" {
  description = "Name of the containerized service"
  type        = string
}

variable "service_image" {
  description = "Docker image for the containerized service"
  type        = string
}

variable "service_replicas" {
  description = "Number of replicas for the service"
  type        = number
}

variable "container_port" {
  description = "Port that the container listens on"
  type        = number
}

variable "service_type" {
  description = "Kubernetes service type (ClusterIP, NodePort, LoadBalancer)"
  type        = string
}