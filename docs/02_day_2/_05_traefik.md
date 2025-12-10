---
title: "05 Traefik"
---

## Was ist Traefik?

[Traefik](https://traefik.io/) (ausgesprochen wie "Traffic") ist ein moderner HTTP Reverse Proxy und Load Balancer.
Im Gegensatz zu Nginx, der oft statisch konfiguriert wird (`nginx.conf`), ist Traefik **dynamisch**.

### Das "Cloud Native" Problem
In einer Docker-Welt starten und stoppen Container ständig. IP-Adressen ändern sich.
Ein klassischer Nginx müsste jedes Mal neu konfiguriert und reloaded werden.

### Die Traefik Lösung
Traefik hört auf den **Docker Socket**.
Wenn du einen Container startest, sieht Traefik das sofort und konfiguriert sich selbst neu. Ohne Neustart.
  
---

## Die Kern-Konzepte

Traefik hat eine klare Architektur:

1.  **EntryPoints:** Die Türen zur Welt. Meist Port `80` (HTTP) und `443` (HTTPS).
2.  **Routers:** Die Wegweiser. Analysieren den Request (z.B. Host `blog.localhost`) und entscheiden, wohin er gehen soll.
3.  **Middlewares:** Die Filter. Können Requests verändern, bevor sie ankommen (z.B. BasicAuth, HTTPS Redirect, Komprimierung).
4.  **Services:** Das Ziel. Laufen oft als Load Balancer vor deinen Containern.

---

## Konfiguration via Labels

Das Geniale: Du konfigurierst Traefik **nicht** in einer zentralen Datei, sondern **direkt am Container**, den es betrifft.

### Beispiel Stack

```yaml
services:
  # 1. Der Traefik Container
  reverse-proxy:
    image: traefik:v3.0
    command: --api.insecure=true --providers.docker # Aktiviert Dashboard & Docker
    ports:
      - "80:80"     # Der Web-Traffic
      - "8080:8080" # Das Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock # WICHTIG: Socket mounten

  # 2. Deine App
  whoami:
    image: traefik/whoami
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.my-router.rule=Host(`whoami.localhost`)"
```

### Erklärung der Labels
- `traefik.enable=true`: "Traefik, bitte beachte mich!"
- `traefik.http.routers.my-router.rule=...`: "Wenn jemand auf `whoami.localhost` kommt, schick ihn zu mir."

Docker restartet? Traefik merkt es.
Du skalierst auf 5 Instanzen? Traefik load-balanced automatisch (Round Robin).

---

## Das Dashboard

Wenn du Traefik mit `--api.insecure=true` startest, kannst du unter `http://localhost:8080` ein mächtiges Dashboard sehen.
Es zeigt dir alle erkannten Router, Services und Middlewares visualisiert an.

## Wann Traefik vs. Nginx?

- **Nginx:** Perfekt für statischen Content (HTML/CSS), Caching und als klassischer Webserver.
- **Traefik:** Perfekt als "Edge Router" vor deinen Docker-Containern.

**Best Practice:** Traefik vorne als Türsteher, der den Traffic an die Docker-Container verteilt.
