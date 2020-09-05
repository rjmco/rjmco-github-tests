resource "google_cloudbuild_trigger" "rjmco_github_tests_plan" {
  build {
    step {
      id   = "tg hclfmt check"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = [
        "hclfmt",
        "--terragrunt-check"
      ]
      dir = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
    }

    step {
      id   = "tf fmt check"
      name = format("gcr.io/$PROJECT_ID/terraform:%s", var.terraform_version)
      args = [
        "fmt",
        "-check",
        "-recursive"
      ]
      dir = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
    }

    step {
      id   = "tg validate-all"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = [
        "validate-all"
      ]
      dir = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
    }

    step {
      id   = "tg plan-all"
      name = format("gcr.io/$PROJECT_ID/terragrunt:%s-%s", var.terraform_version, var.terragrunt_version)
      args = [
        "plan-all"
      ]
      dir = "github-tests-project"
      env = [
        "TF_IN_AUTOMATION=1",
        "TF_INPUT=0",
        "TF_VAR_project_id=$PROJECT_ID"
      ]
    }
  }

  github {
    name  = "gft-rdcr-github-tests"
    owner = "rjmco"
    push {
      invert_regex = true
      branch       = "^master$"
    }
  }

  name     = "rjmco-github-tests-plan"
  project  = var.project_id
  provider = google-beta
}