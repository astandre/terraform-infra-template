locals {
  tags = {
    region  = var.region
    project = "infra-terraform-template"
  }
}

variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Region to deploy the project"
}
variable "s3_bucket_prefix" {
  default     = "infra-terraform-template"
  type        = string
  description = "S3 bucket prefix to avoid global collisions"
}

variable "github_token" {
  default     = null
  type        = string
  description = "Github token to access repo"
  sensitive   = true
}
