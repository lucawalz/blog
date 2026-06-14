# blog

The source for blog.syslabs.dev, a Hugo static site using the PaperMod theme.
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
