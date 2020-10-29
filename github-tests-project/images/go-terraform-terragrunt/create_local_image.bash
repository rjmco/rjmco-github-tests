#!/usr/bin/env bash

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

set -euf -o pipefail -x

IMAGE_TAG_NAME='go-terraform-terragrunt'
VERSIONS_FILE_PATH='../../versions.yaml'

# Gather tools versions
alpine_version=$(grep alpine: ${VERSIONS_FILE_PATH} | sed 's/^.*: \(.*\)$/\1/')
golang_version=$(grep golang: ${VERSIONS_FILE_PATH} | sed 's/^.*: \(.*\)$/\1/')
terraform_version=$(grep terraform: ${VERSIONS_FILE_PATH} | sed 's/^.*: \(.*\)$/\1/')
terragrunt_version=$(grep terragrunt: ${VERSIONS_FILE_PATH} | sed 's/^.*: \(.*\)$/\1/')
image_tag_version="${golang_version}-${terraform_version}-${terragrunt_version}"

echo "Using Alpine version $alpine_version"
echo "Using Golang version $golang_version"
echo "Using Terraform version $terraform_version"
echo "Using Terragrunt version $terragrunt_version"

# Build docker image
docker build -t ${IMAGE_TAG_NAME}:${image_tag_version} \
    --build-arg ALPINE_VERSION=${alpine_version} \
    --build-arg GOLANG_VERSION=${golang_version} \
    --build-arg TERRAFORM_VERSION=${terraform_version} \
    --build-arg TERRAGRUNT_VERSION=${terragrunt_version} \
    . $@