`rdcr-github-tests` project setup
=================================

Initial setup
-------------

1. Set environment variables (after replacing `<..._ID>` values):

```shell script
export DEFAULT_REGION=europe-west2
export FOLDER_ID=<FOLDER_ID>
export PROJECT_ID=<PROJECT_ID>
```
1. Project creation:

```
% gcloud projects create $PROJECT_ID --no-enable-cloud-apis --folder $MA_FOLDER_ID --labels="team=ma-infrastructure,business-unit=modern-apps,cost-code=ke017769-001,created-by=rdcr,dont-delete=true,owner=rdcr,environment=development"
```

2. Linking project to billing account:

```
% gcloud beta billing projects link $PROJECT_ID --billing-account=$BILLING_ACCOUNT
```

3. Enabling Cloud Build API:

```
gcloud --project $PROJECT_ID services enable cloudbuild.googleapis.com
```

4. Create Terraform state backend bucket:

```
gsutil mb -b on -l europe-west2 -p $PROJECT_ID gs://${PROJECT_ID}-tfstate
gsutil versioning set on gs://${PROJECT_ID}-tfstate
```

5. Grant Cloud Build's service account the project IAM Admin role:

```
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')@cloudbuild.gserviceaccount.com" \
  --role=roles/roles/resourcemanager.projectIamAdmin 
```

6. Grant Cloud Build's service account the Cloud Storage Admin role:

```
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')@cloudbuild.gserviceaccount.com" \
  --role=roles/storage.admin
```