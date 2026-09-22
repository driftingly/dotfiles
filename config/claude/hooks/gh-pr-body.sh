#!/bin/bash
#
# PreToolUse hook (Bash, filtered to gh): block GitHub writes that break the
# CLAUDE.md rules. PRs, issues, and comments must not mention Claude Code, and
# PR descriptions must not carry a "Test plan" section.

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

printf '%s' "$cmd" | grep -qE 'gh +(pr|issue) +(create|edit|comment)' || exit 0

problems=""
if printf '%s' "$cmd" | grep -qiE 'claude code|claude\.com/claude-code|generated with .?\[?claude'; then
    problems="${problems}mentions Claude Code; "
fi
if printf '%s' "$cmd" | grep -qiE '(^|[^[:alnum:]])test plan'; then
    problems="${problems}includes a Test plan section; "
fi

[ -z "$problems" ] && exit 0

reason="Blocked by ~/.claude/hooks/gh-pr-body.sh: this gh command ${problems%; }. CLAUDE.md forbids that in PR descriptions, PR comments, and issue comments. Remove the offending text and run it again."

jq -nc --arg r "$reason" '{
    hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $r
    }
}'
