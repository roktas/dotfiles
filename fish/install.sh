#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/fish

rm -rf "$config" && install -d "$config" && {
	ln -sf "$PWD"/config.fish -t "$config"
}

install -d "$config"/functions && {
	find "$PWD"/functions -type f -print0 | xargs -0 ln -t "$config"/functions -sf
}

fish -c "fundle install"
