output "ip_servidor_principal" {
  description = "Dirección IP del servidor"
  value       = aws_instance.servidor_principal.public_ip
}

output "ip_servidor_respaldo" {
  description = "IP del respaldo (si existe)"
  value       = length(aws_instance.servidor_respaldo) > 0 ? aws_instance.servidor_respaldo[0].public_ip : "No creado"
}

output "nombres_de_los_buckets" {
  description = "Lista generada de nombres de buckets"
  value       = [for b in aws_s3_bucket.almacenamiento : b.bucket]
}
