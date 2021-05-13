#!/bin/bash

set -e

# Applies changes from one docs directory to another.
# Usage: 
# 1. Commit your change as normal
# 2. Run ./hack/apply-to-version.sh v0.22 v0.21

for version in "$@"
do
  echo "Apply to version $version"
  git format-patch --stdout -1 HEAD | git apply --index --intent-to-add -p2 --directory "docs-$version"
  git commit -m "Apply $version: $(git log --format=%B -n 1 HEAD)"
done


