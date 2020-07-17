terraform {
  required_version = ">= 0.12"
}

module "defs" {
  source = "../../modules/defs"

  bucket_name   = local.bucket_name
  repo_endpoint = local.repo_endpoint
  repos = [
    {
      salt_versions = local.salt_versions
      repo_prefix   = local.repo_prefix
      yum_prefix    = local.yum_prefix
    },
    {
      salt_versions = local.salt_versions_archive
      repo_prefix   = local.repo_prefix_archive
      yum_prefix    = local.yum_prefix
    },
  ]
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "salt-reposync-"
}

locals {
  bucket_name = aws_s3_bucket.this.id

  repo_endpoint       = "https://${aws_s3_bucket.this.bucket_regional_domain_name}"
  repo_prefix         = "repo/"
  repo_prefix_archive = "repo/archive/"
  yum_prefix          = "defs/"

  salt_versions = [
    "3000",
    "2019.2.3",
  ]

  salt_versions_archive = [
    "2018.3.4",
  ]
}
