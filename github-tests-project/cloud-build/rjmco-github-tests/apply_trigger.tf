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

resource "google_cloudbuild_trigger" "rjmco_github_tests_apply" {
  build {
    step {
      id   = "tg hclfmt check"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = ["hclfmt", "--terragrunt-check"]
      dir  = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
      wait_for = ["-"]
    }

    step {
      id         = "cloud-build scripts shellcheck"
      name       = "gcr.io/$PROJECT_ID/shellcheck"
      entrypoint = "bash"
      args       = ["-c", "shellcheck *"]
      dir        = "github-tests-project/scripts/"
      wait_for   = ["-"]
    }

    step {
      id         = "prepare tf plugin cache"
      name       = "gcr.io/cloud-builders/gcloud"
      entrypoint = "bash"
      args       = ["scripts/prepare_tf_plugin_cache.sh"]
      dir        = "github-tests-project"
      env = [
        "DEFAULT_REGION=${var.region}",
        "PROJECT_ID=$PROJECT_ID",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache"
      ]
      wait_for = ["-"]
    }

    step {
      id   = "tg validate-all"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = ["validate-all"]
      dir  = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
      wait_for = [
        "prepare tf plugin cache",
        "cloud-build scripts shellcheck",
        "tg hclfmt check"
      ]
    }

    step {
      id   = "tf fmt check"
      name = format("gcr.io/$PROJECT_ID/terraform:%s", var.terraform_version)
      args = ["fmt", "-check", "-recursive"]
      dir  = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
      wait_for = ["tg validate-all"]
    }

    step {
      id         = "backup tf plugin cache"
      name       = "gcr.io/cloud-builders/gcloud"
      entrypoint = "bash"
      args       = ["scripts/backup_tf_plugin_cache.sh"]
      dir        = "github-tests-project"
      env = [
        "PROJECT_ID=$PROJECT_ID",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache"
      ]
      wait_for = ["tg validate-all"]
    }

    step {
      id   = "tg plan-all"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = ["plan-all"]
      dir  = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
      wait_for = ["tf fmt check"]
    }

    step {
      id   = "tg apply-all"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = [
        "apply-all"
      ]
      dir = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_PLUGIN_CACHE_DIR=/workspace/tf_plugin_cache",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
      wait_for = ["tg plan-all"]
    }
  }

  github {
    name  = "rjmco-github-tests"
    owner = "rjmco"
    push {
      branch = "^master$"
    }
  }

  name     = "rjmco-github-tests-apply"
  project  = var.project_id
  provider = google-beta
}