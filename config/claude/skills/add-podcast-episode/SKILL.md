---
name: add-podcast-episode
description: Add a new podcast episode markdown file to the Tighten blog. Use when the user wants to add a new Business of Laravel or Pragmatic AI episode.
disable-model-invocation: true
allowed-tools: Write, Read, Bash(test:*), Bash(ls:*), Bash(grep:*), Bash(perl:*), Bash(sed:*), Bash(cat:*), Bash(wc:*), Bash(mv:*)
---

# Create podcast episode

Create a new podcast episode markdown file in `source/_blog_posts/`. Two podcasts are supported.

| Key | Name | preview_image |
|---|---|---|
| `bol` | Business of Laravel | `assets/images/insights/bol-logo-preview.png` |
| `pragmatic-ai` | Pragmatic AI | `assets/images/insights/pragmatic-ai-logo.jpg` |

## Why this skill is structured this way

Transcripts run 50KB+. If the assistant emits a transcript through the Write tool, every word is an output token and the file write takes minutes. The transcript MUST be supplied as a `.txt` file path. Process it on disk with `perl`/`grep`/`cat` and append the result. Do NOT Read the transcript into context, and do NOT echo its contents.

## Workflow

Collect inputs one field at a time. Show the field name, an example or default if relevant, then wait for the answer.

Fields, in order:

1. **Podcast key** (`bol` or `pragmatic-ai`)
2. **Filename slug** (e.g. `ep1 Ian Landsman HelpSpot and Laravel`). Normalize per the rules below.
3. **Publish date** (`YYYY-MM-DD`)
4. **Title** (full episode title)
5. **Authors** (comma-separated list of author keys; default `matt-stauffer`)
6. **Transistor embed ID** (e.g. `360eb232`)
7. **Estimated time in minutes** (integer)
8. **Intro** (paste inline — typically a few short paragraphs plus a link list)
9. **Transcript file path.** Ask the user to drag the `.txt` transcript file into the chat; the absolute path will appear as text. They can also type a path. Inline pastes are not supported — if the user pastes transcript text instead of a path, ask them to drag a `.txt` file.

## Intro handling

The intro is short, so handle it inline. Apply these rules to whatever the user provides:

1. Accept markdown as is when links are already formatted as `- [Label](URL)` bullets.
2. Convert plain-text label lines into markdown links. If the user gives lines like `Matt Stauffer on X` with no URL, ask for the URL. Do not guess URLs.
3. Strip the Tighten website link. Remove any link whose URL host is `tighten.com` (with or without `www.` and any path), or whose visible label is `Tighten Website` or just `Tighten`. Remove the entire bullet line.
4. Normalize spacing. Trim trailing whitespace, one blank line between paragraphs, one blank line before the link list.

If after stripping there are no links left, that is fine.

## Slug normalization

Lowercase, replace any run of non-alphanumeric characters (other than hyphens) with a single hyphen, collapse repeated hyphens, strip leading and trailing hyphens. Example: `ep1 Ian Landsman HelpSpot and Laravel` → `ep1-ian-landsman-helpspot-and-laravel`.

## Assembly

Output path: `source/_blog_posts/{podcast_key}-{slug}.md`, relative to the repo root. Always quote paths in shell commands in case they contain spaces.

### Step 1: Verify the transcript file

```
test -f "{transcript_path}" && case "{transcript_path}" in *.txt) echo ok;; *) echo "not a .txt file";; esac
```

If the file does not exist or is not `.txt`, stop and ask the user for a valid path.

### Step 2: Check for overwrite

```
test -f "source/_blog_posts/{podcast_key}-{slug}.md" && echo exists || echo new
```

If it exists, ask the user before continuing.

### Step 3: Clean and bold the transcript on disk

Run a single `perl -0777` pass that strips Google Doc viewer chrome and bolds speaker lines. Output goes to a tmp file. The assistant never reads the transcript bytes.

**Critical: the perl script MUST be wrapped in single quotes, exactly as shown.** The `$1` backreference is a perl variable, not a shell variable. If you wrap the script in double quotes, bash will expand `$1` to the empty string and the replacement becomes `****`, which silently strips every speaker name. Do not rewrite, reformat, or re-quote this command.

```
perl -0777 -pe '
  s/\r\n/\n/g;
  s/\A(?:\s*(?:[^\n]*\.(?:txt|docx?)|Page|\d+|\/|[^\n]*%)\s*\n|[^\S\n]*\n)+//;
  s/\n+Displaying [^\n]*\.\s*\z//;
  s/^([A-Z][A-Za-z]+(?: [A-Z][A-Za-z]+)*:)\s*$/**$1**/gm;
' "{transcript_path}" > /tmp/episode-transcript-cleaned.txt
```

What the regex does:
- `\r\n` → `\n` to normalize line endings.
- The first `\A` substitution strips leading viewer chrome: lines that are a filename ending in `.txt`/`.doc`/`.docx`, or only `Page`, only digits, only `/`, ending in `%`, or blank. It stops as soon as it hits a non-chrome line (the first real content line).
- The second substitution strips a trailing `Displaying ...` viewer footer plus trailing whitespace.
- The third substitution bolds any line whose entire content is `<Name>:` (one or more capitalized words). Lines already in `**Name:**` form are skipped because they start with `*`.

### Step 3a: Verify (mandatory, not optional)

Run both checks. They take a fraction of a second and catch the `$1`-expansion bug above and any other silent breakage.

```
grep -c '^\*\*[^*][^*]*:\*\*$' /tmp/episode-transcript-cleaned.txt
grep -c '^\*\*\*\*$' /tmp/episode-transcript-cleaned.txt
```

- The first count must be `> 0` (at least one speaker line was bolded). If it is `0`, the speaker regex did not match — stop and investigate.
- The second count must be `0`. Any hits mean `$1` was expanded to empty and speaker names were stripped — stop, fix the quoting, and rerun the perl step before continuing.

### Step 4: Write the head (frontmatter + intro + transcript heading)

Use the Write tool to create the final file with this content. It is small — frontmatter plus the intro only. End with `## Transcript` followed by a blank line so the appended transcript starts on its own line.

```
---
extends: _layouts.blog
section: content
author: [{author1}, {author2}, ...]
preview_image: {preview_image for the chosen podcast}
publish_date: {YYYY-MM-DD}
title: "{title}"
embed: '<iframe width="100%" height="180" frameborder="no" scrolling="no" seamless="" src="https://share.transistor.fm/e/{embed_id}?color=FFFFFF&background=30343C"></iframe>'
estimated_time: {minutes} minute podcast
post_type: podcast
---

{intro paragraphs and bulleted links, Tighten link removed}

## Transcript

```

Notes on the template:
- The `embed` value is single-quoted YAML; the iframe HTML inside uses double quotes.
- The title is double-quoted. If the title contains a double quote, escape it by doubling it (`""`) per YAML rules, or rephrase.

### Step 5: Append the cleaned transcript

```
cat /tmp/episode-transcript-cleaned.txt >> "source/_blog_posts/{podcast_key}-{slug}.md"
```

### Step 6: Report

Print the relative path of the file you created. Optionally `wc -l` it as a sanity check.

## Example

User: `/add-podcast-episode`

Assistant asks for podcast key. User: `pragmatic-ai`.
Assistant asks for slug. User: `ep14 someone interesting`.
... fields proceed in order. For the transcript field, the user drags `ep14-transcript.txt` into the chat and the absolute path appears. Assistant runs the verify, perl, write, and cat steps and reports `source/_blog_posts/pragmatic-ai-ep14-someone-interesting.md`.
