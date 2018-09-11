#!/bin/bash

set -e -u

cat resources | while read resource; do
  echo "configuring $resource..."
  fly -t resources sp -p $resource -c <(jsonnet -V resource=$resource template.jsonnet)
  echo ""
done
