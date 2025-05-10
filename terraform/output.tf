output "app_url" {
  description = "URL to access the app"
  value       = "http://${aws_instance.fintrack-app.public_dns}:5001"

}