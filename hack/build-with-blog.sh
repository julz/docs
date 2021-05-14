#!/bin/bash

# Builds blog and community into the site by cloning the website repo, copying blog/community dirs in, running hugo.
# - Results are written to site/ as normal.
# - Run as "./hack/build-with-blog.sh serve" to run a local preview server on site/ afterwards (requires `npm install -g http-server`).

# Quit on error
set -e
# Echo each line
set -x

# First, build the main site with mkdocs.
rm -rf site/
mkdocs build -d site/docs

# Build the previous versions to the correct directories.
mkdocs build -f mkdocs.yml -d site/development     # pre-release:    docs => development/
mkdocs build -f mkdocs-0.23.yml -d site/docs       # latest release: docs-0.23 => docs/
mkdocs build -f mkdocs-0.23.yml -d site/v0.22-docs # old releases:   docs-N => vN-docs/

# Set up the version file to point to the built docs.
cat << EOF > site/versions.json
[
  {"version": "docs", "title": "v0.23", "aliases": [""]},
  {"version": "v0.22-docs", "title": "v0.22", "aliases": [""]},
  {"version": "development", "title": "(Pre-release)", "aliases": [""]}
]
EOF

# Re-Clone
# TODO(jz) Cache this and just do a pull/update for local dev flow.
# Maybe also support local checkout in siblings?
rm -rf temp
mkdir temp
git clone --recurse-submodules https://github.com/knative/website temp/website
git clone https://github.com/knative/community temp/community

# Move blog files into position
mkdir -p temp/website/content/en
cp -r blog temp/website/content/en/

# Clone community/ in to position too
# This is pretty weird: the base community is in docs, but then the
# community repo is overlayed into the community/contributing subdir.
cp -r community temp/website/content/en/
cp -r temp/community/* temp/website/content/en/community/contributing/
rm -r temp/website/content/en/community/contributing/elections/2021-TOC # Temp fix for markdown that confuses hugo.

# Run the hugo build as normal!

# need postcss cli in PATH
PATH=${PATH}:${PWD}/node_modules/.bin
pushd temp/website
hugo
popd

# Hugo builds to public/, just copy over to site/ to match up with mkdocs
mv temp/website/public/blog site/
mv temp/website/public/community site/
mv temp/website/public/css site/
mv temp/website/public/scss site/
mv temp/website/public/webfonts site/
mv temp/website/public/images site/
mv temp/website/public/js site/

# Home page is served from docs, so add a redirect.
# TODO(jz) in production this should be done with a netlify 301 (or maybe just copy docs/index up with a base set).
cat << EOF > site/index.html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Redirecting</title>
  <noscript>
    <meta http-equiv="refresh" content="1; url=docs/" />
  </noscript>
  <script>
   window.location.replace(window.location.href+"docs/");
  </script>
</head>
<body>
  Redirecting to <a href="docs/">docs/</a>...
</body>
</html>
EOF

# Clean up
rm -rf temp

if [ "$1" = "serve" ]; then
  pushd site
  npx http-server
  popd
fi
