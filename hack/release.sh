#!/bin/bash

set -e
set -x

## Makes a docs release. Run as ./hack/release 0.99.
## This script just copies docs and mkdocs.yml to docs-$version and mkdocs-$version.yml,
## and fixes up the knative_version, branch, docs_dir variables based on the given version.

version="${1##v}"

# Barrel out if release already exists.
if [ -e docs-$version ]; then
  echo release $version already exists.
  exit 1
fi

# Copy docs to docs-$version.
cp -r docs "docs-$version"

# Copy mkdocs.yml to mkdocs-$version.yml & swap docs_dir, knative_version and
# branch to correct version.
cat mkdocs.yml \
  | sed -e "s/^\(docs_dir:\) .*$/\1 docs-$version/" \
  | sed -e "s/^\(\s\+branch:\) .*$/\1 $version/" \
  | sed -e "s/^\(\s\+knative_version:\) .*$/\1 $version/" \
  > mkdocs-$version.yml

# Add version_warning: true to old yamls to enable version warning header.
ymls=($(ls -r mkdocs-*.yml))
for y in ${ymls[@]:1}; do
  sed -i.bak -e "s/^\(\s\+version_warning:\) .*$/\1 true/" $y
  rm $y.bak
done
