#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/mc

rm -rf "$config" && install -d "$config" && {
	ln -sf "$PWD"/mc.keymap -t "$config"
	ln -sf "$PWD"/menu -t "$config"
	cp "$PWD"/mc.ini "$config"/ini # MC overwrites ini, hence copy
}

data=${XDG_DATA_HOME:-$HOME/.local/share}/mc
rm -rf "$data" && install -d "$data" && {
	cp -a "$PWD"/skins "$data"
}
