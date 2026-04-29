variable "alumno" {
  description = "Tu nombre. Lo usaremos para nombrar recursos y evitar colisiones."
  type        = string
  default     = "usuario1"
}

variable "crear_servidor_respaldo" {
  description = "Interruptor (Toggle) para crear o no un servidor adicional."
  type        = bool
  default     = false 
}

variable "nombres_buckets" {
  description = "Lista de nombres para los buckets que vamos a iterar."
  type        = set(string)
  default     = ["imagenes", "documentos", "backups"]
}
