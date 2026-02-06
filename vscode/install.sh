#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

config=${XDG_CONFIG_HOME:-$HOME/.config}/Code/User

install -d "$config" && {
	ln -sf "$PWD"/settings.json -t "$config"
}

if command -v code &>/dev/null; then
	 code --force --install-extension GitHub.codespaces
	 code --force --install-extension GitHub.github-vscode-theme
	 code --force --install-extension adpyke.codesnap
	 code --force --install-extension arcticicestudio.nord-visual-studio-code
	 code --force --install-extension chrislajoie.vscode-modelines
	 code --force --install-extension ms-vscode-remote.vscode-remote-extensionpack
fi
