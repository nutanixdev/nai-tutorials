#!/usr/bin/env bash

echo 'export PATH="${PATH}:/custom/bin"' >> "$HOME/.profile"

git config --global --add safe.directory /workspace || true
git config --global credential.helper 'cache --timeout=3600'