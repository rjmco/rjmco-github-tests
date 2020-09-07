#!/usr/bin/env bash

# Backup cached Terraform plugins
gsutil -m rsync -r -P "${TF_PLUGIN_CACHE_DIR}/" "gs://${PROJECT_ID}-tf-plugin-cache/"