#!/bin/bash

# Builds blog and community into the site by cloning the website repo, copying blog/community dirs in, running hugo.
# - Results are written to site/ as normal.
# - Also builds release versions from docs-*/ directories.
# - Run as "./hack/build-with-blog.sh serve" to run a local preview server on site/ afterwards (requires `npm install -g http-server`).

# >> Releasing a new docs release (we will make this in to a script at some point):
# 1. Copy docs to docs-$release
# 2. Copy mkdocs.yml to mkdocs-$release.yml
# 3. Edit docs_dir in mkdocs-$release.yml to docs-$release (this script will warn and exit if you forget)
# 4. Also update knative_version and branch variables in mkdocs-$release.yml
#    so artifact and branch macros work nicely
# That's it, go party.

set -e
set -x

rm -rf site/
mkdir site

docs_dirs=($(ls -d -r docs-*))
latest=${docs_dirs[0]##docs-}

# Build pre-release docs from docs/ to development/.
mkdocs build -f mkdocs.yml -d site/development

# Build latest release to docs/.
mkdocs build -f mkdocs-$latest.yml -d site/docs

# Build docs-$release directories (other than latest) to docs-$release/.
versionjson=""
for docs in ${docs_dirs[@]:1}; do
  version=${docs##docs-}
  grep -q "docs_dir: docs-$version" mkdocs-$version.yml || (echo "docs_dir for mkdocs-$version.yml should be docs-$version" && exit 1)
  versionjson+="{\"version\": \"v$version-docs\", \"title\": \"v$version\", \"aliases\": [\"\"]},"
  mkdocs build -f mkdocs-$version.yml -d site/v$version-docs
done

# Set up the versions.json file to point to the built docs for the dropdown switcher.
cat << EOF > site/versions.json
[
  {"version": "docs", "title": "v$latest", "aliases": [""]},
  $versionjson
  {"version": "development", "title": "(Pre-release)", "aliases": [""]}
]
EOF

# Clone out website and community repos to build the blog/community stuff, for now.
# TODO(jz) Cache this and just do a pull/update for local dev flow.
# Maybe also support local checkout in siblings?
if [[ -z "${SKIP_BLOG}" ]]; then
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
  pushd temp/website
  npx hugo
  popd

  # Hugo builds to public/, just copy over to site/ to match up with mkdocs
  mv temp/website/public/blog site/
  mv temp/website/public/community site/
  mv temp/website/public/css site/
  mv temp/website/public/scss site/
  mv temp/website/public/webfonts site/
  mv temp/website/public/images site/
  mv temp/website/public/js site/
fi

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
