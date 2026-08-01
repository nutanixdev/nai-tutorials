#!/usr/bin/env sh
set -eu

if [ -f .env-template ]; then
    cp -f .env-template .env
fi