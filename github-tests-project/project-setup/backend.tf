# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "gcs" {
    prefix = "project-setup"
    bucket = "rdcr-github-tests-tfstate"
  }
}