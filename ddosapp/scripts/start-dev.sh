#!/usr/bin/env bash

set -eo pipefail

export APP_MODULE=${APP_MODULE:="${MODULE_NAME:-src.main}:${VARIABLE_NAME:-app}"}
export LOG_CONFIG=${LOG_CONFIG:-/app/logging.ini}

exec uvicorn --reload --proxy-headers --host "${HOST:-0.0.0.0}" --port "${PORT:-8000}" --log-config "$LOG_CONFIG" "$APP_MODULE" --log-level=debug
