#!/usr/bin/env bash

set -euo pipefail; [[ -z ${TRACE:-} ]] || set -x; cd "$(dirname "$0")"

cry() { echo -e "$*" >&2; }
die() { cry "$@"; exit 1; }

[[ ${EUID:-} -gt 0 ]] || die "You must not be root."

share=$(readlink -m "${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles")
dropbox=$(readlink -m "$HOME"/Dropbox)
vagrant=$(readlink -m /vagrant)

# Deactive linked services if any
systemd=${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user
if [[ -d $systemd ]]; then
	while read -r link; do
		case $(readlink -f "$link") in
		"$share"/*.service|"$dropbox"/*.service|"$vagrant"/*.service)
			service=$(basename "$link")

			cry "... Deactivating service: $service"

			systemctl stop --user "$service" || true
			systemctl disable --user "$service" || true

			need_daemon_reload=t
			;;
		esac
	done < <(find "$systemd" -maxdepth 1 -type l)
fi

# Unlink dotfiles (excluding the ones in Dropbox)
cry "... Unlinking dotfiles"
while read -r link; do
	case $(readlink -f "$link") in
	"$share"/*|"$dropbox"/*|"$vagrant"/*)
		[[ -z ${VERBOSE:-} ]] || cry "        $link"

		rm -f "$link"
		;;
	esac
done < <(find "$HOME" -type l \( -not -path ''"$dropbox"'/*' \))

# Perform daemon reload if deactivating occurs
if [[ -n ${need_daemon_reload:-} ]]; then
	cry "... Reloading daemon"

	systemctl --user daemon-reload || true
	systemctl --user reset-failed || true
fi
