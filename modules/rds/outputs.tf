output "db_endpoint" {
  value = aws_db_instance.wiki.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.wiki.id
}

output "db_password_arn" {
  value = aws_secretsmanager_secret.db_password.arn
}