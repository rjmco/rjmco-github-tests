#!/usr/bin/env bash

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