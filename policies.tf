# Create IAM policy
#   - make s3 bucket accessible only from OAI
data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_website_name}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn}"]
    }
  }
}
