#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

install -d "$HOME"/.local/bin && {
	find "$PWD"/bin -executable -type f -print0 | xargs -0 ln -t "$HOME"/.local/bin -sf
}
