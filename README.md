GitHub tests project
====================

Initial setup
-------------

1. Set environment variables (after replacing `<..._ID>` values):

```shell script
export BUSINESS_UNIT=<BUSINESS_UNIT>
export COST_CODE=<COST_CODE>
export CREATED_BY=<CREATED_BY>
export FOLDER_ID=<FOLDER_ID>
export TEAM=<TEAM>
export TF_VAR_project_id=<PROJECT_ID>
```
1. Project creation:

```
% gcloud projects create $TF_VAR_project_id --no-enable-cloud-apis --folder $MA_FOLDER_ID --labels="team=$TEAM,business-unit=$BUSINESS_UNIT,cost-code=$COST_CODE,created-by=$CREATED_BY,dont-delete=true,owner=$CREATED_BY,environment=development"
```

2. Linking project to billing account:

```
% gcloud beta billing projects link $TF_VAR_project_id --billing-account=$BILLING_ACCOUNT
```

3. Enabling Cloud Build API:

```
gcloud --project $TF_VAR_project_id services enable cloudbuild.googleapis.com
```

4. Create Terraform state backend bucket:

```
gsutil mb -b on -l europe-west2 -p $TF_VAR_project_id gs://${TF_VAR_project_id}-tfstate
gsutil versioning set on gs://${TF_VAR_project_id}-tfstate
```

5. Grant Cloud Build's service account the project IAM Admin role:

```
gcloud projects add-iam-policy-binding $TF_VAR_project_id \
  --member="serviceAccount:$(gcloud projects describe $TF_VAR_project_id --format='value(projectNumber)')@cloudbuild.gserviceaccount.com" \
  --role=roles/roles/resourcemanager.projectIamAdmin 
```

6. Grant Cloud Build's service account the Cloud Storage Admin role:

```
gcloud projects add-iam-policy-binding $TF_VAR_project_id \
  --member="serviceAccount:$(gcloud projects describe $TF_VAR_project_id --format='value(projectNumber)')@cloudbuild.gserviceaccount.com" \
  --role=roles/storage.admin
```