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

  fly -t wings set-pipeline \
    -p $name \
    -c $pipeline \
    -l <(lpass show "Concourse Pipeline Credentials" --notes)
}

check_installed lpass
check_installed fly

# Make sure we're up to date and that we're logged in.
lpass sync

pipelines_path=$(cd $(dirname $0)/../ && pwd)

pipeline=${1}

configure_pipeline apps \
    $pipelines_path/apps.yml