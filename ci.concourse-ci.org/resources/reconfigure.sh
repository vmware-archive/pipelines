#!/bin/bash

set -eux

resource=$1; shift
params=${*:-"ship=true"}

usage() {
  echo "usage: $0 <resource-name> [ship=true] [resources=fly|cf]"
  exit 1
}

[ -n "$resource" ] || usage

if [ -e "$resource.yml" ]; then
  fly -t resources set-pipeline -p "$resource" -c "$resource.yml"
else
  fly -t resources set-pipeline -p "$resource" -c <(erb $params template.yml.erb) -v resource="$resource"
fi
fly -t resources expose-pipeline -p "$resource"
