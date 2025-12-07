---
title: "Docker Deep Dive"
slug: "/"
---

## Zielgruppe & Voraussetzungen

Dieser Kurs richtet sich an Entwickler (Frontend/Backend) und DevOps-Interessierte.
Du solltest fit im Umgang mit der Shell/Terminal sein.

## Tech Stack

Wir nutzen modernes Tooling:
- **Engine:** Docker Desktop (Mac/Windows) oder Docker Engine (Linux)
- **Code:** VS Code mit Docker Extension
- **App:** Wir bauen Services mit Bun (TypeScript) und Python – keine Sorge, du musst die Sprachen nicht perfekt können, der Fokus liegt auf der Containerisierung.

## Agenda

Der Kurs ist auf 3 Tage ausgelegt:

### Day 1: Foundations
Wir legen das Fundament. Keine Magie, nur Technik.

- **01 Intro:** Container vs. VM, Architecture, Installation.
- **02 Container Management:** CLI Basics, Limits (CPU/RAM), Logging, Restart Policies.
- **03 Image Basics:** Docker Hub, Tags, Image Inspection.
- **04 Networking Basics:** Bridge, Host, None. Isolation verstehen.
- **Lab:** "The Manual Way" - Wir starten eine Multi-Container App von Hand.

### Day 2: Construction
Vom Konsumenten zum Produzenten.

- **01 Storage:** Daten persistieren (Bind Mounts vs. Volumes).
- **02 Dockerfiles:** Eigene Images bauen, Caching verstehen, Multi-Stage Builds.
- **03 Docker Compose:** Infrastructure as Code für Container-Setups.
- **Lab:** "The Automated Way" - Fullstack Applikation mit Compose.

### Day 3: Production & Operations
Ready for the real world.

- **01 Private Registry:** Images sicher speichern und verteilen.
- **02 Security:** Rootless Container, Image Scanning, Best Practices.
- **03 Tools:** Traefik Proxy, Portainer UI.
- **04 K8s Outlook:** Was kommt nach Docker?
- **Lab:** "Production Ready" - Security Audits und Deployment.

:::tip[Unser Motto]
**Hands-on first, Theory second.** Wir tippen erst, dann erklären wir.
:::

## Setup

Bevor es losgeht, stelle sicher, dass Docker läuft:

```bash
docker version
```

Wenn du Client und Server Output siehst, bist du bereit.
