variable "aws_region" {
  default = "ap-south-1"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_type" {
  default = "c7i-flex.large"
}
