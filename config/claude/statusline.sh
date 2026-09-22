#!/bin/bash
#
# Claude Code status line: <repo>:<branch> | <model> | ctx: <percent>
# One jq call, since this runs on every render.

# Line-delimited, not tab: read treats tabs as collapsible whitespace, which
# would shift the fields whenever one of them is empty.
{ read -r cwd; read -r model; read -r ctx_pct; } < <(
    jq -r '
        .workspace.current_dir // "",
        .model.display_name // "",
        (.context_window.used_percentage // 0 | floor | tostring)
    '
)

cwd="${cwd:-$PWD}"

# Prefer the repo root name over the current directory, and add the branch.
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    location=$(basename "${root:-$cwd}")
    branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
    [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    [ -n "$branch" ] && location="$location:$branch"
else
    location="${cwd/#$HOME/~}"
fi

if [ "$ctx_pct" -ge 60 ]; then
    ctx_color='\033[01;31m' # red
elif [ "$ctx_pct" -ge 40 ]; then
    ctx_color='\033[01;33m' # yellow
else
    ctx_color='\033[01;32m' # green
fi

printf '\033[01;36m%s\033[00m' "$location"
[ -n "$model" ] && printf ' | \033[02m%s\033[00m' "$model"
printf ' | ctx: %b%s%%\033[00m' "$ctx_color" "$ctx_pct"
