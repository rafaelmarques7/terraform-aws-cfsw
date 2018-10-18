# Create OAI
resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "This resource is required. It takes no arguments."
}

# Create CF distribution
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = "${aws_s3_bucket.s3_bucket_website.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.s3_bucket_website.id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path}"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = "${aws_s3_bucket.s3_bucket_website.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
