#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/bundle

rm -rf "$config" && install -d "$config" && {
	ln -sf "$PWD"/Gemfile -t "$config"
}

install -d "$HOME"/.local/bin && {
	find "$PWD"/bin -executable -type f -print0 | xargs -0 ln -t "$HOME"/.local/bin -sf
}

bin/bundle-kludge -i || true
