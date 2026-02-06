#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

cry() { echo -e "$*" >&2;                   }
die() { cry "$@"; exit 1;                   }
gui() { [[ -n ${DISPLAY:-} ]];              }
run() { cry "--> $1"; bash "$1"/install.sh; }

[[ ${EUID:-} -gt 0 ]] || die "You must not be root."

touch ~/.hushlogin

run alacritty
run bash
run bat
run bin
run biome
run bun
run bundle
run direnv
run eslint
run fish
run fzf
run gh
run git
run gnome
run irb
run markdownlint
run mc
run neomutt
run npm
run nvim
run prettier
run pylint
run rubocop
run tmux
run todo
run vifm
run vscode
run wezterm
run zsh

! gui || run dropbox
