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

resource "google_cloudbuild_trigger" "rjmco_tf_gcp_simple_network_test" {
  filename = "build/cloudbuild.yaml"
  github {
    name  = "tf-gcp-simple-network"
    owner = "rjmco"
    push {
      branch = ".*"
    }
  }

  name     = "rjmco-tf-gcp-simple-network"
  project  = var.project_id
  provider = google-beta
  substitutions = {
    _GOLANG_VERSION     = var.golang_version
    _TERRAFORM_VERSION  = var.terraform_version
    _TERRAGRUNT_VERSION = var.terragrunt_version
  }
}