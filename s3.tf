resource "random_integer" "log_bucket_suffix" {
  max = 18
  min = 16
}

module "s3_log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.22.0"

  bucket = "${var.app_name}-log-bucket-${random_integer.log_bucket_suffix.id}"
  acl    = "log-delivery-write"

  force_destroy = true

  attach_elb_log_delivery_policy = true

  restrict_public_buckets = true
}