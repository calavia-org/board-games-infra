variable "alb_ingress_name" {
  description = "Nombre del Ingress ALB"
  type        = string
}

variable "alb_ingress_namespace" {
  description = "Namespace donde se desplegará el Ingress"
  type        = string
  default     = "default"
}

variable "alb_ingress_annotations" {
  description = "Anotaciones para el Ingress ALB"
  type        = map(string)
  default     = {}
}

variable "alb_ingress_hosts" {
  description = "Lista de hosts para el Ingress"
  type        = list(string)
}

variable "alb_ingress_service_name" {
  description = "Nombre del servicio al que se dirigirá el tráfico"
  type        = string
}

variable "alb_ingress_service_port" {
  description = "Puerto del servicio al que se dirigirá el tráfico"
  type        = number
}

variable "alb_ingress_ssl_cert_arn" {
  description = "ARN del certificado SSL para el Ingress"
  type        = string
}

variable "alb_ingress_path" {
  description = "Ruta para el Ingress"
  type        = string
  default     = "/"
}