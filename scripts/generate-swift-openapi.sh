#!/usr/bin/env bash
set -euo pipefail

log() { printf -- "** %s\n" "$*" >&2; }
error() { printf -- "** ERROR: %s\n" "$*" >&2; }
fatal() { error "$@"; exit 1; }

CURRENT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$(git -C "${CURRENT_SCRIPT_DIR}" rev-parse --show-toplevel)"

OPENAPI_YAML="${REPO_ROOT}/openapi/openapi.yaml";
TYPES_OUTPUT="${REPO_ROOT}/Sources/CoreOpenAPIRuntimeKit/";

swift-openapi-generator generate \
    --mode types \
    --output-directory "${TYPES_OUTPUT}" \
    --access-modifier public \
    "${OPENAPI_YAML}"
