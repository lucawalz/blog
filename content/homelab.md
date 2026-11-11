+++
title = "Homelab"
draft = true
hiddenInRss = true
ShowToc = true
comments = false
+++

Updated November 2026.

This is a first draft, built from the public notes in the [bedrock repository](https://github.com/lucawalz/bedrock). It is a small bare-metal Kubernetes cluster at home, and everything on it is rebuilt from Git.

## Hardware

- Three Lenovo ThinkCentre m920q mini PCs: the cluster nodes. One runs the K3s control plane (and workloads too), the other two are workers.
- A Raspberry Pi: the router, gateway, firewall, DHCP and DNS for the lab. It also acts as the Tailscale subnet router.
- TP-Link TL-SG108PE managed switch: carries the VLAN tags and powers the Pi over PoE.
- Rack: [Lab Rax, a 3D-printable 10-inch rack by Michael Klements (The DIY Life)](https://the-diy-life.com/introducing-lab-rax-a-3d-printable-modular-10-rack-system/).

Licences of third-party designs still to be checked.

## Network

The Pi is the router. The servers sit on their own VLAN, and a separate DMZ VLAN is blocked towards both the cluster and the home network. From the home network the router forwards only the web ports of the service address into the cluster.

There are no open inbound ports from the internet. Public traffic, including this site, arrives through an outbound Cloudflare Tunnel, and I reach the admin side over Tailscale. Everything that is not public sits behind passkey single sign-on.

## Services

- Public: this blog, and a chat front end for local language models.
- Documents: a document archive (Paperless) with automatic OCR and tagging through an LLM gateway.
- Local AI: Ollama for local models, behind an OpenAI-compatible gateway (LiteLLM).
- Identity: Pocket ID for passkeys with an authenticating proxy in front of the admin pages.
- Monitoring: Prometheus, Grafana, Loki, Tempo and Alertmanager, with ntfy for notifications.
- Platform: Traefik for ingress, Longhorn for storage, CloudNativePG for databases, Kyverno for admission policy, with backups going off-site to Cloudflare R2.
- Dashboard: a Homepage start page for the lot.

## How changes get deployed

The nodes and the router are declared as NixOS flakes, including disk layout, and applied with `nixos-rebuild`. The cluster itself is reconciled by Flux from the bedrock repository, so a commit to `main` is the only way a change reaches it. Renovate opens the pull requests that keep dependencies up to date, and CI validates the manifests before anything merges.

In November 2026 I wiped the cluster and rebuilt it from the repository to prove that it works.

## Posts

The write-ups live in the [bedrock series](/series/bedrock/).
