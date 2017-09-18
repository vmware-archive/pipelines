#!/bin/bash

set -ex

resources=${1:-"time git docker-image"}

for resource in $resources; do
  fly -t resources set-pipeline -p "$resource" -c template.yml -v resource="$resource"
done
