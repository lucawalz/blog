# blog

[![build](https://github.com/lucawalz/blog/actions/workflows/build.yaml/badge.svg)](https://github.com/lucawalz/blog/actions/workflows/build.yaml)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Hugo](https://img.shields.io/badge/Hugo-static-FF4088?logo=hugo&logoColor=white)

A static blog and project notes, served from the home-lab cluster.

## Description

The source for lucawalz.dev, a Hugo static site using the PaperMod theme.
GitHub Actions builds it into a container image and pushes it to GHCR. The
home-lab cluster serves that image behind Traefik, and Cloudflare exposes it
publicly.

## Theme

PaperMod is vendored as a git submodule under `themes/PaperMod`. Clone with
submodules, or initialize them after the fact:

```sh
git clone --recurse-submodules <repo-url>
# or
git submodule update --init --recursive
```

## Run locally

```sh
hugo server -D
```

The site is served at http://localhost:1313. Drafts show with `-D`.

## Publishing

Pushing to `main` triggers `.github/workflows/build.yaml`, which builds the
multi-stage Dockerfile (Hugo build, then nginx) and pushes two tags to
`ghcr.io/lucawalz/blog`:

- `latest`
- the short commit SHA

To roll the deployment, bump the image tag in the bedrock repo's manifests to
the new SHA. Pinning to a SHA keeps deploys reproducible; `latest` is a
convenience pointer.

## One-time GHCR setup

The cluster pulls without a registry secret, so the package must be public.
After the first successful build, open the `blog` package under the GitHub
account's Packages and set its visibility to public.

## License

Released under the MIT License. See [LICENSE](LICENSE).
