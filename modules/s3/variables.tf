variable "bucket_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_route_table_ids" {
  type = list(string)
}

variable "region" {
  type    = string
  default = "us-east-1"
}