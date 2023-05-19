variable "primary_region" {
  description = "Primary region for infrastructure"
}

variable "secondary_region" {
  description = "Secondary region for infrastructure"
}

resource "aws_s3_bucket" "primary_bucket" {
  bucket = "ski-chatgpt-primary-bucket-example"
  tags = {
    Name = "ski-chatgpt-infra-primary-bucket"
  }
}

resource "aws_s3_bucket" "secondary_bucket" {
 provider = aws.secondary
  bucket  = "ski-chatgpt-secondary-bucket-example"
  tags = {
    Name = "ski-chatgpt-infra-secondary-bucket"
  }
}

output "primary_bucket_arn" {
  value = aws_s3_bucket.primary_bucket.arn
}

output "secondary_bucket_arn" {
  value = aws_s3_bucket.secondary_bucket.arn
}

output "primary_bucket_domain_name" {
  value = aws_s3_bucket.primary_bucket.bucket_regional_domain_name
}

output "secondary_bucket_domain_name" {
  value = aws_s3_bucket.secondary_bucket.bucket_regional_domain_name
}