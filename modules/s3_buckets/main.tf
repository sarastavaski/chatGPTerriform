variable "primary_region_name" {
  description = "The name of the primary region."
}

variable "secondary_region_name" {
  description = "The name of the secondary region."
}

resource "aws_s3_bucket" "primary_s3_bucket" {
  bucket = "primary-slalom-website"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "primary_s3_bucket_access_block" {
  bucket = aws_s3_bucket.primary_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "secondary_s3_bucket" {
  bucket = "secondary-slalom-website"

  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "secondary_s3_bucket_access_block" {
  bucket = aws_s3_bucket.secondary_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "primary_s3_bucket_id" {
  value = aws_s3_bucket.primary_s3_bucket.id
}

output "secondary_s3_bucket_id" {
  value = aws_s3_bucket.secondary_s3_bucket.id
}

output "primary_region_domain_name" {
  value = aws_s3_bucket.primary_s3_bucket.bucket_regional_domain_name
}

output "secondary_region_domain_name" {
  value = aws_s3_bucket.secondary_s3_bucket.bucket_regional_domain_name
}