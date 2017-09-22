#!/bin/bash

set -eux

resource=$1; shift
params=${*:-"ship=true"}

usage() {
  echo "usage: $0 <resource-name> [ship=true] [resources=fly|cf]"
  exit 1
}

[ -n "$resource" ] || usage

fly -t resources set-pipeline -p "$resource" -c <(erb $params template.yml.erb) -v resource="$resource"
fly -t resources expose-pipeline -p "$resource"
