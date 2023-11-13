#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/nvim

rm -rf "$config" && install -d "$config" && {
	ln -sf "$PWD"/init.lua -t "$config"
}

nvim --headless +qall! # Install plugins
