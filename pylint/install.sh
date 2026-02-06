#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}

install -d "$config" && {
	ln -sf "$PWD"/pylintrc -t "$config"
}
