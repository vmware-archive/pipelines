#!/bin/bash

set -ex

resources=${1:-"pool time git docker-image"}

for resource in $resources; do
  fly -t resources set-pipeline -p "$resource" -c template.yml -v resource="$resource"
  fly -t resources expose-pipeline -p "$resource"
done
