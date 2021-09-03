GitHub tests project
====================

Initial setup
-------------

1. Set environment variables (after replacing `<..._ID>` values):

```shell script
export BILLING_ACCOUNT_ID=<BILLING_ACCOUNT_ID>
export TF_VAR_project_id=<PROJECT_ID>
```

1. Project creation:

```shell script
gcloud projects create $TF_VAR_project_id --no-enable-cloud-apis
```

2. Linking project to billing account:

```shell script
gcloud beta billing projects link $TF_VAR_project_id --billing-account=$BILLING_ACCOUNT_ID
```

3. Enable essential APIs:

```shell script
gcloud --project $TF_VAR_project_id services enable cloudbuild.googleapis.com
gcloud --project $TF_VAR_project_id services enable cloudresourcemanager.googleapis.com
```

4. Create Terraform state backend bucket:

```shell script
gsutil mb -b on -l europe-west2 -p $TF_VAR_project_id gs://${TF_VAR_project_id}-tfstate
gsutil versioning set on gs://${TF_VAR_project_id}-tfstate
```

5. Grant Cloud Build's service account the project IAM Admin role:

```shell script
gcloud projects add-iam-policy-binding $TF_VAR_project_id \
  --member="serviceAccount:$(gcloud projects describe $TF_VAR_project_id --format='value(projectNumber)')@cloudbuild.gserviceaccount.com" \
  --role=roles/resourcemanager.projectIamAdmin
```

6. Grant Cloud Build's service account the Cloud Storage Admin role:

```shell script
gcloud projects add-iam-policy-binding $TF_VAR_project_id \
  --member="serviceAccount:$(gcloud projects describe $TF_VAR_project_id --format='value(projectNumber)')@cloudbuild.gserviceaccount.com" \
  --role=roles/storage.admin
```

go-terraform-terragrunt container image creation
------------------------------------------------

1. Update the versions file [github-tests-project/versions.yaml]

2. In [github-tests-project/images/go-terraform-terragrunt] execute the `create_local_image.bash` script:

```
cd images/go-terraform-terragrunt
./create_local_image.bash
```

3. Tag the generated local image to the google container image and push it (the versions below are just an example):

```
docker tag go-terraform-terragrunt:1.17.0-1.0.5-0.31.8 eu.gcr.io/$TF_VAR_project_id/go-terraform-terragrunt:1.17.0-1.0.5-0.31.8
docker push eu.gcr.io/$TF_VAR_project_id/go-terraform-terragrunt:1.17.0-1.0.5-0.31.8
```

tf-gcp-simple-network requirements
----------------------------------

1. Enable the Compute API
```
gcloud --project $TF_VAR_project_id services enable compute.googleapis.com
```

