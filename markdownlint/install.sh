#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

ln -sf "$PWD"/markdownlint.json "$HOME"/.markdownlint.json
