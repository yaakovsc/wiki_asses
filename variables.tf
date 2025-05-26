variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "acm_cert_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
}

variable "db_username" {
  description = "Database username"
  default     = "wikiadmin"
}