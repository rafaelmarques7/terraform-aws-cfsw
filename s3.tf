# Create S3 bucket for static website hosting
#   - apply policy that restricts access to OAI only
resource "aws_s3_bucket" "s3_bucket_website" {
  bucket = "${var.s3_bucket_website_name}"
  policy = "${data.aws_iam_policy_document.iam_policy_document.json}"

  website {
    index_document = "index.html"
  }
}

# Upload build folder to S3 bucket
resource "null_resource" "upload_bucket" {
  depends_on = ["aws_s3_bucket.s3_bucket_website"]

  provisioner "local-exec" {
    command = "aws s3 cp ${var.build_dir_name} s3://${aws_s3_bucket.s3_bucket_website.id} --recursive --profile=economist-ds-dev"
  }
}
