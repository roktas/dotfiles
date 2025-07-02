#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/nvim

rm -rf "$config" && install -d "$config" && {
	ln -sf "$PWD"/init.lua -t "$config"
	ln -sf "$PWD"/lazyvim.json -t "$config"
	ln -sf "$PWD"/lua -t "$config"
}

nvim --headless +qall! # Install plugins

install -d "$HOME"/.local/bin && {
	find "$PWD"/bin -executable -type f -print0 | xargs -0 ln -t "$HOME"/.local/bin -sf
}

config=${XDG_CONFIG_HOME:-$HOME/.config}/vi
rm -rf "$config" && git clone https://github.com/nvim-lua/kickstart.nvim.git "$config"
