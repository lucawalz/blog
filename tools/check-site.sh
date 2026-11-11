#!/bin/sh
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

rsync -a --exclude .git --exclude public --exclude resources --exclude .worktrees --exclude .superpowers "$ROOT"/ "$TMP"/
cp -R "$ROOT"/tools/fixtures/content/. "$TMP"/content/
cd "$TMP"
if [ -f content/homelab.md ]; then
	sed "s/^draft = true/draft = false/" content/homelab.md >content/homelab.md.tmp
	mv content/homelab.md.tmp content/homelab.md
fi
if [ -f content/notes/_index.md ]; then
	sed "s/^draft: true/draft: false/" content/notes/_index.md >content/notes/_index.md.tmp
	mv content/notes/_index.md.tmp content/notes/_index.md
fi
hugo --gc --minify -d "$TMP/public" >/dev/null

assert_contains() {
	if ! grep -qF -- "$2" "$1" 2>/dev/null; then
		echo "FAIL: assert_contains $1 '$2'" >&2
		exit 1
	fi
	echo "ok: assert_contains $1 '$2'"
}

assert_absent() {
	if [ ! -e "$1" ]; then
		echo "FAIL: assert_absent $1 (file missing)" >&2
		exit 1
	fi
	if grep -qF -- "$2" "$1"; then
		echo "FAIL: assert_absent $1 '$2'" >&2
		exit 1
	fi
	echo "ok: assert_absent $1 '$2'"
}

assert_absent_anywhere() {
	if grep -rqF -- "$1" public; then
		echo "FAIL: assert_absent_anywhere '$1'" >&2
		exit 1
	fi
	echo "ok: assert_absent_anywhere '$1'"
}

assert_exists() {
	if [ ! -e "$1" ]; then
		echo "FAIL: assert_exists $1" >&2
		exit 1
	fi
	echo "ok: assert_exists $1"
}

assert_contains public/index.html 'content="Luca Walz writes about backend systems, Kubernetes, NixOS and the homelab they run on."'
assert_contains public/posts/fixture-standalone/index.html 'class=paginav'
assert_exists public/series/bedrock/index.html
assert_contains public/posts/fixture-bedrock-2/index.html 'Part 2 of the <a href=/series/bedrock/>bedrock</a> series'
assert_contains public/posts/fixture-bedrock-2/index.html '/posts/fixture-bedrock-1/'
assert_contains public/posts/fixture-bedrock-1/index.html 'Part 1 of the <a href=/series/bedrock/>bedrock</a> series'
assert_contains public/posts/fixture-horizon-1/index.html 'Part 1 of the <a href=/series/horizon/>horizon</a> series'
assert_absent public/posts/fixture-horizon-1/index.html 'series-box-list'
assert_absent_anywhere 'fixture-bedrock-draft'
assert_absent public/posts/fixture-standalone/index.html 'series-box'
assert_contains public/series/bedrock/index.html 'Coming up'
assert_contains public/posts/fixture-bedrock-2/index.html 'Updated February 1, 2026'
assert_absent public/posts/fixture-standalone/index.html 'Updated'
assert_absent public/posts/fixture-bedrock-1/index.html 'Updated'
assert_contains public/tags/fixture-tag/index.html '<span>Note</span>'
assert_absent public/index.html 'fixture-note'
assert_absent public/index.xml 'fixture-note'
assert_contains public/notes/index.xml 'fixture-note'
assert_absent public/notes/fixture-note/index.html 'series-box'
assert_contains public/notes/index.html 'fixture-note'
assert_contains public/index.html '/notes/ title=Notes'
assert_absent public/posts/fixture-standalone/index.html '<span>Note</span>'
assert_exists public/homelab/index.html
assert_contains public/homelab/index.html 'href=/series/bedrock/'
assert_contains public/index.html '/homelab/ title=Homelab'
assert_contains public/posts/fixture-standalone/index.html 'class=footnotes'
assert_contains "$(ls public/assets/css/stylesheet.*.css)" '.footnotes'
