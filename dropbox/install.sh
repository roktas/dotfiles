#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

if [[ -f "$HOME"/Dropbox/etc/install.sh ]]; then
	echo >&2 "Setting up private environment..."
	bash "$HOME"/Dropbox/etc/install.sh
fi
