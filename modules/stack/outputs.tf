output "app_url" {
  value = "http://localhost:${var.external_port}"
}

output "health_url" {
  value = "http://localhost:${var.external_port}/health"
}
