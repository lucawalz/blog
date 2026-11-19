# blog

[![build](https://github.com/lucawalz/blog/actions/workflows/build.yaml/badge.svg)](https://github.com/lucawalz/blog/actions/workflows/build.yaml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Hugo](https://img.shields.io/badge/Hugo-static-FF4088?logo=hugo&logoColor=white)

Static Hugo blog and project notes, served from the home-lab cluster

## Description

The source for lucawalz.dev, a Hugo static site using the PaperMod theme.
GitHub Actions builds it into a container image and pushes it to GHCR. The
home-lab cluster serves that image behind Traefik, and Cloudflare exposes it
publicly.

## Installation

### Theme

PaperMod is vendored as a git submodule under `themes/PaperMod`. Clone with
submodules, or initialize them after the fact:

```sh
git clone --recurse-submodules https://github.com/lucawalz/blog.git
# or
git submodule update --init --recursive
```

### One-time GHCR setup

The cluster pulls without a registry secret, so the package must be public.
After the first successful build, open the `blog` package under the GitHub
account's Packages and set its visibility to public.

## Usage

### Run locally

```sh
hugo server -D
```

The site is served at http://localhost:1313. Drafts show with `-D`.

### Check the site

```sh
tools/check-site.sh
```

The script copies the tracked files to a temporary directory, adds the
fixtures from `tools/fixtures`, builds the site with Hugo and asserts on the
generated HTML. It exits non-zero on the first failed assertion.

### Publishing

Pushing to `main` triggers `.github/workflows/build.yaml`, which builds the
multi-stage Dockerfile (Hugo build, then nginx) and pushes three tags to
`ghcr.io/lucawalz/blog`:

- `latest`
- the short commit SHA
- `main-<timestamp>-<short SHA>`

Renovate in the bedrock repo detects each new `main-<timestamp>-<short SHA>`
tag and merges the update automatically, so every build on `main` reaches the
cluster.

## Support

Open an issue at https://github.com/lucawalz/blog/issues for questions and
bugs. Report vulnerabilities through the process in [SECURITY.md](SECURITY.md).

## Contributing

Editorial conventions and the contribution flow are in
[CONTRIBUTING.md](CONTRIBUTING.md). Participation follows the
[code of conduct](https://github.com/lucawalz/.github/blob/main/CODE_OF_CONDUCT.md).

## Authors and acknowledgment

Written and maintained by [Luca Walz](https://github.com/lucawalz). The site
uses the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

## License

Released under the MIT License. See [LICENSE](LICENSE).

## Project status

Active.
