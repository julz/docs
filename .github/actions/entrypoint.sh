#!/bin/sh

ls -l
mkdocs build --config-file "${GITHUB_WORKSPACE}/mkdocs.yml"
ls -l
ls -l public