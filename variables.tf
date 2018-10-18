variable "region" {
  type        = "string"
  description = "The AWS region where the terraform stack is created"
  default     = "us-east-1"
}

variable "s3_filename_state" {
  type        = "string"
  description = "The file name of the state inside the state_bucket"
  default     = "state_terraform"
}

variable "s3_bucket_website_name" {
  type        = "string"
  description = "The websites' S3 bucket name"
  default     = "website-terraform-aws-cfsw"
}

variable "build_dir_name" {
  type        = "string"
  description = "The name of the directory that contains the static frontend files."
  default     = "build"
}
