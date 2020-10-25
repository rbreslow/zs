variable "project" {
  default = "Zombie Survival"
  type    = string
}

variable "environment" {
  default = "Staging"
  type    = string
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "aws_availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
  type    = list(string)
}

variable "aws_key_name" {
  type = string
}

variable "r53_public_hosted_zone" {
  type = string
}

variable "cloudfront_price_class" {
  default = "PriceClass_100"
  type    = string
}

variable "external_access_cidr_block" {
  type = string
}

variable "srcds_ami" {
  type = string
}

variable "srcds_instance_type" {
  default = "c5.large"
  type    = string
}
