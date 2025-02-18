#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/alacritty

rm -rf "$config" && install -d "$config" && {
	ln -sf "$PWD"/alacritty.toml -t "$config"
}
