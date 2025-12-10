---
title: "03 Tools (Traefik & Co.)"
---

## Traefik

Du hast 5 Services. Alle wollen Port 80. Geht nicht.
Du brauchst einen **Reverse Proxy**. Nginx geht, aber die Konfiguration ist statisch.
Wenn ein Container startet/stoppt, muss Nginx das wissen.

**Traefik** lauscht auf den Docker Socket.
Sobald du einen Container startest, erkennt Traefik ihn und konfiguriert das Routing automatisch. Magie.

Konfiguration passiert via "Labels" am Container:

```yaml
services:
  whoami:
    image: traefik/whoami
      - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
```

### Wichtige Labels

Traefik konfiguriert sich über Labels am **Ziel-Container**.

1. **Der Router (Wann?):**
   `traefik.http.routers.<name>.rule=Host('example.local')`
   Bestimmt, *wann* Traffic hier landet.

2. **Der Service (Wohin?):**
   Traefik rät den Port (er nimmt den ersten EXPOSE Port). Wenn dein Container aber auf Port 3000 hört (wie viele Node Apps), musst du es ihm sagen:
   `traefik.http.services.<name>.loadbalancer.server.port=3000`

3. **Middleware (Wie?):**
   Auth, Compress, Redirects.
   `traefik.http.routers.<name>.middlewares=auth`

### Dashboard

Starte Traefik mit `--api.insecure=true`, um auf Port 8080 das Dashboard zu sehen. Extrem hilfreich beim Debuggen!

## Weitere Tools

### Portainer
Eine grafische Oberfläche für Docker. Nett für Einsteiger, aber in Produktion oft ein Sicherheitsrisiko (weil Vollzugriff auf Docker Socket).

### LazyDocker
Ein Terminal-UI (TUI) für Docker. Extrem mächtig und schnell. Empfehlung!
