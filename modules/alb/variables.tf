variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "acm_cert_arn" {
  type = string
}