variable "primary_region" {
  description = "Primary region for infrastructure"
}

variable "secondary_region" {
  description = "Secondary region for infrastructure"
}

variable "primary_bucket_arn" {
  description = "ARN of the primary S3 bucket"
}

variable "secondary_bucket_arn" {
  description = "ARN of the secondary S3 bucket"
}

variable "primary_bucket_domain_name" {
  description = "Domain Name of the primary S3 bucket"
}

variable "secondary_bucket_domain_name" {
  description = "Domain Name of the secondary S3 bucket"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "CloudFront Origin Access Identity"
}

resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name = var.primary_bucket_domain_name
    origin_id   = "primary-bucket"
  }

  origin {
    domain_name = var.secondary_bucket_domain_name
    origin_id   = "secondary-bucket"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "primary-bucket"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/index.html"
    target_origin_id = "secondary-bucket"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "ski-chatgpt-infra-cloudfront"
  }
}
