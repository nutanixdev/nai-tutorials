#!/usr/bin/env bash

git config --global --add safe.directory /workspace || true
git config --global credential.helper 'cache --timeout=3600'

if command -v direnv >/dev/null 2>&1; then
    direnv allow /workspace 2>/dev/null || true
fi

exit 0