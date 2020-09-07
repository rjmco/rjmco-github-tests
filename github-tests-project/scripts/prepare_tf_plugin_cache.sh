#!/usr/bin/env bash

# Create Terraform plugin cache bucket
if ! gsutil ls "gs://${PROJECT_ID}-tf-plugin-cache" &> /dev/null; then
  echo "Terraform plugin cache bucket gs://${PROJECT_ID}-tf-plugin-cache doesn't exist."
  gsutil mb -b on -l "${DEFAULT_REGION}" -p "${PROJECT_ID}" "gs://${PROJECT_ID}-tf-plugin-cache"
else
  echo "Terraform plugin cache bucket gs://${PROJECT_ID}-tf-plugin-cache already exists."
fi

# Restore backed up Terraform plugins
mkdir -p "${TF_PLUGIN_CACHE_DIR}"
if gsutil -m cp -r -P "gs://${PROJECT_ID}-tf-plugin-cache/*" "${TF_PLUGIN_CACHE_DIR}/"; then
  echo "Terraform plugin cache populated."
else
  echo "Terraform plugin cache empty."
fi