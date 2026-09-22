#!/bin/bash
#
# PostToolUse hook (Write|Edit): flag dash punctuation in Markdown.
#
# CLAUDE.md bans em dashes, en dashes, and spaced hyphens as punctuation in
# docs. This is advisory: the write has already happened, so exit 2 only feeds
# the finding back to Claude. Fenced code, inline code, and list bullets are
# ignored, since a dash there is syntax rather than punctuation.

input=$(cat)
file=$(printf '%s' "$input" | jq -r '.tool_response.filePath // .tool_input.file_path // empty')

case "$file" in
    *.md|*.mdx) ;;
    *) exit 0 ;;
esac

[ -f "$file" ] || exit 0

offenders=$(awk '
    /^[[:space:]]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    {
        line = $0
        gsub(/`[^`]*`/, "", line)
        sub(/^[[:space:]]*([-*+]|[0-9]+\.)[[:space:]]+/, "", line)
        sub(/^>[[:space:]]*/, "", line)
        if (index(line, "—") || index(line, "–") || line ~ / -{1,2} /)
            printf "  line %d: %s\n", NR, substr($0, 1, 120)
    }
' "$file")

[ -z "$offenders" ] && exit 0

cat >&2 <<MSG
Dash punctuation found in $file (CLAUDE.md: no em/en dashes or spaced hyphens in docs):
$offenders
Rephrase with periods, commas, or parentheses. If a dash is the subject of the
sentence (quoting the rule itself), leave it and move on.
MSG
exit 2
