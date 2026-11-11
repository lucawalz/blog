# Contributing

Conventions for writing, citing and crediting on this blog.

## Citations

- Inline links are the default.
- Numbered Markdown footnotes are used only for precise claims: thesis figures, papers, quotes, benchmarks.
- No general "Sources and further reading" list at the end of posts.
- Footnote format: author or organisation, "Title", site or publisher, year, link.

Example:

```markdown
Roughly 70 % of pods restarted within a minute.[^1]

[^1]: Example Org, "Pod Restart Study", example.org, 2025, <https://example.org/pod-restarts>.
```

- Open-source software is linked on first mention in each post.

## Quotes

- One fitting quote per post or series part, as a blockquote with the person's name.
- Every quote is verified at its source before publishing.

## Credits and licences

- Third-party designs (3D prints and similar) carry the title, author, link to the source and the licence, named and linked (Creative Commons TASL).
- A note is added when the design was modified.
- Each design's licence is checked individually; MakerWorld's default is its own licence, not Creative Commons.
- Product links are plain manufacturer or shop links. The blog uses no affiliate links.

## Images

- Images are the author's own unless credited.
- Every image has alt text.

## Code and configs

- Code blocks carry a language label.
- No real secrets, IP addresses or internal hostnames.

## Corrections

- Factual errors are fixed in place with a dated "Update:" note in the post.
- Typos are fixed silently.

## Reporting mistakes

- Email contact@lucawalz.dev or open an issue in this repository.

## Comments and discussions

- Comments and discussions follow the [code of conduct](CODE_OF_CONDUCT.md).

## Maintenance

- Before the first note is published, set `draft: false` in `content/notes/_index.md` so the notes page and its menu entry appear.
- After a major PaperMod update, compare `layouts/rss.xml` and `layouts/_partials/post_meta.html` with their originals in `themes/PaperMod` and carry over upstream changes.
- `sh tools/check-site.sh` checks the site structure.
