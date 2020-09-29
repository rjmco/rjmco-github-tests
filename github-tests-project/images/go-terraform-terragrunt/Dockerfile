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

ARG ALPINE_VERSION
ARG GOLANG_VERSION
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION

FROM alpine as builder
ARG TERRAFORM_VERSION
ARG TERRAGRUNT_VERSION
WORKDIR /tmp
RUN apk add --no-cache unzip wget
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O terraform.zip
RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O terragrunt
RUN unzip terraform.zip

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION}
WORKDIR /usr/local/bin
COPY --chown=root:root --from=builder /tmp/terraform .
COPY --chown=root:root --from=builder /tmp/terragrunt .
RUN apk add --no-cache git bash openssh && chmod +x /usr/local/bin/terra*
ENTRYPOINT []