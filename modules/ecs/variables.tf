variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password_arn" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}