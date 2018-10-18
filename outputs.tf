output "s3_bucket_website" {
  description = "Information regarding the bucket created for the static website"

  value {
    id                 = "${aws_s3_bucket.s3_bucket_website.id}"
    arn                = "${aws_s3_bucket.s3_bucket_website.arn}"
    bucket_domain_name = "${aws_s3_bucket.s3_bucket_website.bucket_domain_name}"
  }
}

output "cloudfront_distribution" {
  description = "Information regarding CloudFront, which handles the website distribution"

  value {
    id          = "${aws_cloudfront_distribution.cloudfront_distribution.id}"
    arn         = "${aws_cloudfront_distribution.cloudfront_distribution.arn}"
    domain_name = "${aws_cloudfront_distribution.cloudfront_distribution.domain_name}"
  }
}
