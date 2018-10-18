# Terraform backend - configuration
terraform {
  backend "s3" {
    bucket = "remote-state-bucket-1smjwi07nd"
    key    = "state_terraform"
    region = "us-east-1"
  }
}

# Terraform backend - loading
data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket     = "${var.state_bucket_name}"
    key        = "${var.s3_filename_state}"
    region     = "${var.region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
  }
}
