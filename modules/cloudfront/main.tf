variable "primary_s3_bucket_id" {
  description = "The ID of the primary S3 bucket."
}

variable "secondary_s3_bucket_id" {
  description = "The ID of the secondary S3 bucket."
}

variable "primary_region_domain_name" {
  description = "The domain name of the primary region bucket."
}

variable "secondary_region_domain_name" {
  description = "The domain name of the secondary region bucket."
}

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = var.primary_region_domain_name
    origin_id   = "primary"
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.primary_oai.id}"
    }
  }

  origin {
    domain_name = var.secondary_region_domain_name
    origin_id   = "secondary"
    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.secondary_oai.id}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["example.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "primary"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/index.html"
    target_origin_id = "secondary"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
