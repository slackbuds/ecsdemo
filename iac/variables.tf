variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "ecr_image_immutability" {
  type    = string
  default = "IMMUTABLE"
}

variable "ecr_encryption_type" {
  type    = string
  default = "KMS"
}
