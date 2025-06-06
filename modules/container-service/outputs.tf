output "service_endpoint" {
  description = "Endpoint for the deployed service"
  value       = kubernetes_service.main.status[0].load_balancer[0].ingress[0].hostname
}