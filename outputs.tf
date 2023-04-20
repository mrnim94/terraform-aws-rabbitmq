output "application_username" {
  value       = local.mq_application_user
  description = "RabbitMQ application username"
}

output "application_password" {
  value       = local.mq_application_password
  description = "RabbitMQ application password"
}