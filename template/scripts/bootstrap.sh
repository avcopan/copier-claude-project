#!/bin/sh
# Clone the code repositories listed in repos.txt into the code directory.
#
#   pixi run bootstrap   clone any repos that are missing
#   pixi run status      show the state of each repo (never clones)
#
# The code directory is ~/code/<project>, where <project> is the name of this project
# directory (e.g. ~/proj/sm -> ~/code/sm). CODE_DIR overrides it.
# Existing clones are never modified: no pull, reset, or delete.
set -eu

project_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
manifest="$project_dir/repos.txt"
code_dir=${CODE_DIR:-"$HOME/code/$(basename -- "$project_dir")"}
case $code_dir in
    "~"/*) code_dir="$HOME/${code_dir#"~/"}" ;;
    "~") code_dir=$HOME ;;
esac

mode=${1:-clone}
case $mode in
    clone | status) ;;
    *)
        echo "usage: $0 [status]" >&2
        exit 2
        ;;
esac

[ "$mode" = status ] && printf 'code directory: %s\n' "$code_dir"

failed=0
# shellcheck disable=SC2034  # 'rest' swallows any trailing fields
while read -r path url branch rest; do
    case $path in "" | "#"*) continue ;; esac
    dest="$code_dir/$path"
    if [ "$mode" = status ]; then
        if [ -d "$dest/.git" ]; then
            printf '== %s (%s)\n' "$path" "$(git -C "$dest" describe --tags --always 2>/dev/null || echo '?')"
            git -C "$dest" status --short --branch
        else
            printf '== %s: MISSING (run pixi run bootstrap)\n' "$path"
        fi
        continue
    fi
    if [ -d "$dest/.git" ]; then
        printf 'present  %s\n' "$path"
        continue
    fi
    printf 'cloning  %s <- %s\n' "$path" "$url"
    mkdir -p "$(dirname -- "$dest")"
    if [ -n "${branch:-}" ]; then
        git clone --branch "$branch" -- "$url" "$dest" </dev/null || failed=1
    else
        git clone -- "$url" "$dest" </dev/null || failed=1
    fi
done <"$manifest"

[ "$failed" -eq 0 ] || {
    echo "one or more clones failed" >&2
    exit 1
}
