#!/usr/bin/env sh
set -eu

if [ -f .env.example ]; then
    cp -f .env.example .env
fi