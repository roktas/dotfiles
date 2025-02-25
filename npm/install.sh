#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

if command -v npm &>/dev/null; then
	npm config set prefix ~/.local
	npm config set cache ~/.cache/npm
fi
