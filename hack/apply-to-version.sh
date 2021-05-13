#!/bin/bash

set -e

# Applies changes from one docs directory to another.
# Usage: 
# 1. Commit your change as normal
# 2. Run ./hack/apply-to-version.sh v0.22 v0.21

# Quick check there aren't changes outside docs/
if [ "$(git diff --shortstat HEAD HEAD~ -- docs/)" != "$(git diff --shortstat HEAD HEAD~)" ]
then
  echo "Changes made outside docs/ directory, you probably want to split the commit or do this manually."
  exit 1
fi

# Actually do the patching.
for version in "$@"
do
  echo "Apply to version $version"
  set -x
  git format-patch --stdout -1 HEAD | git apply --index --intent-to-add -p2 --directory "docs-$version"
  git commit -m "Apply $version: $(git log --format=%B -n 1 HEAD)" --author "$(git log -1 --pretty=format:'%an <%ae>')"
done
