# Copyright 2020 The Tranquility Base Authors
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

data "google_iam_policy" "project_iam_policy" {
  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/cloudbuild.builds.builder"
  }

  binding {
    members = [format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/cloudbuild.serviceAgent"
  }

  # Required for tf-gcp-simple-network tests
  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/compute.networkAdmin"
  }

  binding {
    members = [format("serviceAccount:service-%s@containerregistry.iam.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/editor"
  }

  binding {
    members = ["user:rdcr@gftdevgcp.com"]
    role    = "roles/owner"
  }

  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/resourcemanager.projectIamAdmin"
  }

  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/storage.admin"
  }
}

resource "google_project_iam_policy" "project_iam" {
  policy_data = data.google_iam_policy.project_iam_policy.policy_data
  project     = var.project_id
}