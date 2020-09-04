remote_state {
  backend = "gcs"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket                    = "${get_env("PROJECT_ID")}-tfstate"
    enable_bucket_policy_only = true
    location                  = get_env("DEFAULT_REGION")
    prefix                    = path_relative_to_include()
    project                   = get_env("PROJECT_ID")
  }
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.37.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "3.37.0"
    }
  }
}
EOF
}

generate "common_variables" {
  path      = "common_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "project_id" {
  default     = "${get_env("PROJECT_ID")}"
  description = "Resource's GCP Project ID"
  type        = string
}

variable "region" {
  default     = "${get_env("DEFAULT_REGION")}"
  type        = string
  description = "Region where resources should be provisioned at"
}
EOF
}

generate "common_datasources" {
  path      = "common_datasources.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "google_project" "project" {
  project_id = var.project_id
}
EOF
}