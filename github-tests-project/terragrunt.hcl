# Copyright 2020 Ricardo Cordeiro <ricardo.cordeiro@tux.com.pt>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  default_region           = "europe-west2"
  google_providers_version = "3.37.0"
  terraform_version        = "0.13.2"
  terragrunt_version       = "0.23.40"
}

remote_state {
  backend = "gcs"

  generate = {
    path      = "tg_gen_sensitive_backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket                    = format("%s-tfstate", get_env("TF_VAR_project_id"))
    enable_bucket_policy_only = true
    location                  = local.default_region
    prefix                    = path_relative_to_include()
    project                   = get_env("TF_VAR_project_id")
  }
}

generate "providers" {
  path      = "tg_gen_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "${local.google_providers_version}"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "${local.google_providers_version}"
    }
  }
}
EOF
}

generate "common_variables" {
  path      = "tg_gen_common_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "project_id" {
  description = "Resource's GCP Project ID"
  type        = string
}

variable "region" {
  default     = "${local.default_region}"
  type        = string
  description = "Region where resources should be provisioned at"
}

variable "terraform_version" {
  default     = "${local.terraform_version}"
  description = "Terraform version which should be used"
  type        = string
}

variable "terragrunt_version" {
  default     = "${local.terragrunt_version}"
  description = "Terragrunt version which should be used"
}
EOF
}

generate "common_datasources" {
  path      = "tg_gen_common_datasources.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
data "google_project" "project" {
  project_id = var.project_id
}
EOF
}