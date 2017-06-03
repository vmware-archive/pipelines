#!/usr/bin/env bash

set -e
set -o pipefail

check_installed() {
  if ! command -v $1 > /dev/null 2>&1; then
    printf "$1 must be installed before running this script!"
    exit 1
  fi
}

configure_pipeline() {
  local name=$1
  local pipeline=$2

  printf "configuring the $name pipeline...\n"

  fly -t ci set-pipeline \
    -p $name \
    -c $pipeline \
    -l <(lpass show "Concourse Pipeline Credentials" --notes) \
    -v basic-auth-username=$(credhub get -n /concourse-prod-bosh/concourse-prod/basic_auth_username --output-json | jq -r .value) \
    -v basic-auth-password=$(credhub get -n /concourse-prod-bosh/concourse-prod/basic_auth_password --output-json | jq -r .value)
}

check_installed lpass
check_installed credhub
check_installed jq
check_installed fly

# Make sure we're up to date and that we're logged in.
lpass sync

pipelines_path=$(cd $(dirname $0)/../ && pwd)

pipeline=${1}

if [ "$#" -gt 0 ]; then
  for pipeline in $*; do
    file=$pipelines_path/${pipeline}.yml
    if [ "$pipeline" = "main" ]; then
      file=$pipelines_path/concourse.yml
    fi

    configure_pipeline $pipeline \
      $file
  done
else
  configure_pipeline reconfigure-pipelines \
    $pipelines_path/reconfigure-pipelines.yml
fi
