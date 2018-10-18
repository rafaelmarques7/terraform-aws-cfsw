variable "aws_access_key" {
  type        = "string"
  description = "The AWS account access key (id)"
}

variable "aws_secret_key" {
  type        = "string"
  description = "The AWS account secret key (password)"
}

variable "state_bucket_name" {
  type        = "string"
  description = "The S3 bucket name in which the state is stored"
}
