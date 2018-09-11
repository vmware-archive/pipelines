#!/bin/bash

set -eu

vanilla_resources="git time registry-image bosh-io-release bosh-io-stemcell tracker hg github-release semver pool"
privileged_resources="docker-image"
special_resources="s3 cf concourse-pipeline"

for r in $vanilla_resources; do
  echo "--- configuring $r ---"
  fly -t resources sp -p $r -c template.yml -v resource=$r -v privileged=false
  echo ""
done

for r in $privileged_resources; do
  echo "--- configuring $r ---"
  fly -t resources sp -p $r -c template.yml -v resource=$r -v privileged=true
  echo ""
done

for r in $special_resources; do
  echo "--- configuring $r ---"
  fly -t resources sp -p $r -c $r.yml
  echo ""
done
