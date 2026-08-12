#!/usr/bin/env bash

set -euo pipefail

cd /app/backend

echo "Starting Open WebUI..."

bash start.sh &
OPENWEBUI_PID=$!

echo "Waiting for Open WebUI database initialization..."

until curl --silent --fail http://127.0.0.1:8080/health >/dev/null 2>&1; do
    if ! kill -0 "${OPENWEBUI_PID}" 2>/dev/null; then
        echo "ERROR: Open WebUI exited before becoming healthy"
        wait "${OPENWEBUI_PID}"
        exit 1
    fi

    sleep 1
done

echo "Open WebUI is healthy"

echo "Installing staging functions..."

python /opt/nai/bootstrap-function.py

echo "Staging functions installed"

wait "${OPENWEBUI_PID}"