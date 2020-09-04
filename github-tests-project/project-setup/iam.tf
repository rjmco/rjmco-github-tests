data "google_iam_policy" "project_iam_policy" {
  binding {
    members = [format("serviceAccount:%s@cloudbuild.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/cloudbuild.builds.builder"
  }

  binding {
    members = [format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", data.google_project.project.number)]
    role    = "roles/cloudbuild.serviceAgent"
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