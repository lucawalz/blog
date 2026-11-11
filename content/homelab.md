+++
title = "Homelab"
draft = true
hiddenInRss = true
ShowToc = true
comments = false

[menus.main]
weight = 20
+++

Updated November 2026.

This is a first draft, built from the public notes in the [bedrock repository](https://github.com/lucawalz/bedrock). It is a small bare-metal Kubernetes cluster at home, and everything on it is rebuilt from Git.

## Hardware

- Three [Lenovo ThinkCentre M920q](https://psref.lenovo.com/Product/ThinkCentre/ThinkCentre_M920q) mini PCs: the cluster nodes. One runs the K3s control plane (and workloads too), the other two are workers.
- A [Raspberry Pi 4 Model B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/) with a PoE+ HAT: the router, gateway, firewall, DHCP and DNS for the lab. It also acts as the Tailscale subnet router.
- A 7.84 inch 1280x400 HDMI display on the Pi, showing a small Grafana dashboard. It is the frameless display recommended by the screen module below ([AliExpress listing](https://www.aliexpress.us/item/3256804800636801.html)).
- [TP-Link TL-SG108PE](https://www.tp-link.com/en/business-networking/easy-smart-switch/tl-sg108pe/) managed switch: carries the VLAN tags and powers the Pi over PoE.

All product links are plain manufacturer or shop links, not affiliate links.

### Printed parts

The rack is printed from designs by other makers. Each is used under the licence shown on its page.

- "[Lab Rax 10" Server Rack - 5U](https://makerworld.com/en/models/1294480-lab-rax-10-server-rack-5u)" by Michael Klements ([The DIY Life](https://the-diy-life.com/introducing-lab-rax-a-3d-printable-modular-10-rack-system/)), MakerWorld Exclusive License.
- "[Lab Rax Skadis Side Panels](https://makerworld.com/en/models/1490030-lab-rax-skadis-side-panels)" by clemon8, [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/), a remix of Lab Rax by Michael Klements.
- "[Lab Rax Sturdy Long Post Joiner](https://makerworld.com/en/models/1839684-lab-rax-sturdy-long-post-joiner)" by Kiwiworks, [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/), a remix of "Lab Rax Extension Side Panels & Post Joiner" by Michael Klements.
- "[Lenovo ThinkCentre Tiny M920Q 10-inch rack mount](https://makerworld.com/en/models/1808598-lenovo-thinkcentre-tiny-m920q-10-inch-rack-mount)" by Mixmeister, [CC BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/).
- "[10-inch rack panel for TL-SG108E](https://makerworld.com/en/models/1384014-10-inch-rack-panel-for-tl-sg108e)" by Dvidoo, [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/), a remix of "Mini Server Rack for TP-Link TL-SG108 Remix" by Sean Ryle. Designed for the TL-SG108E; it also fits the TL-SG108PE.
- "[Screen module for 10 inch rack + Raspberry Pi [2U]](https://makerworld.com/en/models/2233953-screen-module-for-10-inch-rack-raspberry-pi-2u)" by Ilan Kushnir, MakerWorld Standard Digital File License.

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
