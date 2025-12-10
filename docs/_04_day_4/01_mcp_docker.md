---
title: "01 MCP & Docker"
---

## Was ist MCP?

Das **Model Context Protocol (MCP)** ist ein offener Standard, der es KI-Modellen ermöglicht, sicher mit lokalen Daten und Tools zu interagieren.

Stell dir vor, du fragst ChatGPT: "Wie ist der Status meiner letzten Git-Commits?". ChatGPT kann das nicht wissen.
Mit MCP kannst du einen "Git Server" starten, der diese Info bereitstellt.

### Das Problem

MCP Server sind oft kleine Python- oder Node.js-Skripte.
- "Ich brauche Python 3.11!"
- "Ich brauche Node 20!"
- "Ich brauche `pip install pandas`!"

Wenn du 10 verschiedene Tools nutzen willst, hast du 10 verschiedene Environments auf deinem Laptop. Chaos.

### Die Lösung: Docker

Wir packen den MCP Server in einen Container.
Die Kommunikation läuft über **Stdio** (Standard Input/Output).

```bash
# So ruft der KI-Client (z.B. Claude Desktop) den Server auf
docker run -i --rm mcp-server-git
```

- `-i`: Interactive. Verbindet den Stdin/Stdout Stream des Clients mit dem Container.
- `--rm`: Wegwerfen nach Gebrauch.
- Das Host-System bleibt sauber!

## Stdio vs. SSE

MCP unterstützt zwei Transport-Arten:
1.  **Stdio:** Perfekt für lokale Nutzung (Desktop Apps). Docker eignet sich hier ideal (`docker run -i`).
2.  **SSE (Server-Sent Events):** HTTP-basiert. Wenn der Server remote läuft. Hier verhält sich Docker wie ein normaler Webserver (`-p 8080:80`).
