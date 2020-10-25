
module "origin" {
  source = "github.com/azavea/terraform-aws-s3-origin?ref=2.0.0"

  bucket_name      = "${lower(replace(var.project, " ", ""))}-${lower(var.environment)}-data-${var.aws_region}"
  logs_bucket_name = "${lower(replace(var.project, " ", ""))}-${lower(var.environment)}-logs-${var.aws_region}"

  project     = var.project
  environment = var.environment
}
