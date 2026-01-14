# Bash Rules

**Experience** - Advanced

## General

- **Language** - Even if the conversation language is different (e.g., Turkish), everything within the code (comments,
  variables, file names) is **always in English**.
- **Level** - Tailor explanations to the specified experience level; skip basics.
- **Simplicity** - Avoid verbose code unless it improves readability.

## Style

- **Indent** - 1 tab (8 spaces). Do NOT convert tabs to spaces.
- **Scope** - Use `local` for local vars, `readonly` for globals.
- **Conditions** - Always use `[[ ... ]]`. Use `&&`/`||` instead of `-a`/`-o`.
- **Quotes** - Quote only necessary elements (e.g., `"$HOME"/path/to/file`).
- **Ops** - Use `$(...)` for capture, `=` for string equality.
- **Case** - No indent for case patterns, 1 tab for body.

  ```bash
  case $var
  # pattern
  a)
  	# body
  	...
  ;;
  esac
  ```


- **Alphabetize** arrays, dicts, assignments, and functions if order is irrelevant.
- **Comments** - Code should be self-documenting. If you need a comment to explain WHAT the code does, consider
  refactoring to make it clearer. Unacceptable comments:
  - Comments that repeat what code does
  - Commented-out code (delete it)
  - Obvious comments ("increment counter")
  - Comments instead of good naming
  - Comments about updates to old code (e.g. `# now supports xyz`)
  ```

## Patterns

- **Shebang** - `#!/usr/bin/env bash`
- **Init** - `set -Eeuo pipefail; shopt -s nullglob; [[-z ${TRACE:-}]] || set -x; unset CDPATH; IFS=$' \n'`
- **Error Handling**

  ```bash
  abort() {
  	warn "E: $*"
  	exit 1
  }

  warn() {
  	echo -e "$*" >&2
  }
  ```

- **Main function** - Use `main() { ... }` and call `main "$@"`.
- **Efficiency** - Use shell substitution (`${0##*/}`) over external tools (`basename`)
- **Silence** - If the command offers a quiet option for silent operation, use that option, ie. `grep -q`; otherwise,
  use the `&>/dev/null` shell redirection.
- **Arrays** - Use `mapfile` for output capture: `mapfile -t arr < <(CMD)`.
- **Temp Files** - Use `mktemp` + `trap`.

  ```bash
  local tempfile
  tempfile=$(mktemp) || exit
  trap 'err=$? && rm -f "'"$tempfile"'" || exit $err' EXIT HUP INT QUIT TERM
  ```

- **Temp Dirs**

  ```bash
  local tempdir
  tempdir=$(mktemp -d) || exit
  trap 'err=$? && rm -rf "'"$tempdir"'" || exit $err' EXIT HUP INT QUIT TERM
  ```

## Gotchas

- **Local** - `local x=$(...)` swallows exit codes. Define `local x` first, then assign.
- **Unbound** - With `set -u`, use `${var:-}` to avoid errors on unbound vars.
