#!/bin/sh
# Clone the code repositories listed in repos.txt into the code directory.
#
#   pixi run bootstrap   clone any repos that are missing
#   pixi run status      show the state of each repo (never clones or fetches)
#
# The code directory is ~/code/<project>, where <project> is the name of this project
# directory (e.g. ~/proj/sm -> ~/code/sm). CODE_DIR overrides it.
# A line's optional upstream=<url> field adds an `upstream` remote (for forks).
# Existing clones are never modified (no pull, reset, or delete), except that a
# missing `upstream` remote is added; an existing one is never changed.
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

# Add the `upstream` remote to $dest if it is missing, and fetch it
add_upstream() {
    printf 'upstream %s <- %s\n' "$path" "$upstream"
    git -C "$dest" remote add upstream "$upstream" &&
        git -C "$dest" fetch upstream </dev/null
}

failed=0
while read -r path url rest; do
    case $path in "" | "#"*) continue ;; esac
    dest="$code_dir/$path"

    # Optional fields: a bare branch name and/or upstream=<url>, in any order
    branch=
    upstream=
    set -f
    # shellcheck disable=SC2086  # split the optional fields on whitespace
    set -- $rest
    set +f
    for field; do
        case $field in
            upstream=*) upstream=${field#upstream=} ;;
            *=*) printf 'warning: %s: unknown field %s (ignored)\n' "$path" "$field" >&2 ;;
            *)
                if [ -z "$branch" ]; then
                    branch=$field
                else
                    printf 'warning: %s: extra field %s (ignored)\n' "$path" "$field" >&2
                fi
                ;;
        esac
    done

    current_upstream=
    if [ -d "$dest/.git" ]; then
        current_upstream=$(git -C "$dest" remote get-url upstream 2>/dev/null) || current_upstream=
    fi

    if [ "$mode" = status ]; then
        if [ -d "$dest/.git" ]; then
            printf '== %s (%s)\n' "$path" "$(git -C "$dest" describe --tags --always 2>/dev/null || echo '?')"
            git -C "$dest" status --short --branch
            if [ -n "$upstream" ]; then
                if [ -z "$current_upstream" ]; then
                    printf 'upstream: %s (MISSING, run pixi run bootstrap)\n' "$upstream"
                elif [ "$current_upstream" != "$upstream" ]; then
                    printf 'upstream: %s (DIFFERS from repos.txt: %s)\n' "$current_upstream" "$upstream"
                else
                    printf 'upstream: %s\n' "$upstream"
                fi
            fi
        else
            printf '== %s: MISSING (run pixi run bootstrap)\n' "$path"
        fi
        continue
    fi

    if [ -d "$dest/.git" ]; then
        printf 'present  %s\n' "$path"
        if [ -n "$upstream" ]; then
            if [ -z "$current_upstream" ]; then
                add_upstream || failed=1
            elif [ "$current_upstream" != "$upstream" ]; then
                printf 'warning: %s: upstream remote %s differs from repos.txt (%s); left unchanged\n' \
                    "$path" "$current_upstream" "$upstream" >&2
            fi
        fi
        continue
    fi

    printf 'cloning  %s <- %s\n' "$path" "$url"
    mkdir -p "$(dirname -- "$dest")"
    if [ -n "$branch" ]; then
        git clone --branch "$branch" -- "$url" "$dest" </dev/null || { failed=1; continue; }
    else
        git clone -- "$url" "$dest" </dev/null || { failed=1; continue; }
    fi
    if [ -n "$upstream" ]; then
        add_upstream || failed=1
    fi
done <"$manifest"

[ "$failed" -eq 0 ] || {
    echo "one or more clones or upstream remotes failed" >&2
    exit 1
}
