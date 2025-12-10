---
title: "03 Traefik Proxy"
---

## Was ist Traefik?

[Traefik](https://traefik.io/) ist ein moderner "Cloud Native" Edge Router.
Er ist der beliebteste Reverse Proxy für Docker-Setups.

### Das Problem mit Nginx
Nginx ist toll, aber statisch. Jedes Mal, wenn du einen neuen Container startest, müsstest du:
1. Die IP des Containers herausfinden.
2. `nginx.conf` editieren.
3. `nginx -s reload` ausführen.

### Die Traefik Lösung
Traefik hängt am **Docker Socket**. Es "sieht", was passiert.
Container gestartet? Traefik generiert Konfiguration.
Container gestoppt? Traefik löscht die Route.

---

## Die Konfiguration (Labels)

Traefik wird **dezentral** konfiguriert. Du schreibst "Labels" an deine Container.
Die Syntax ist immer: `traefik.<provider>.<type>.<name>.<property>`

### 1. Der Router (`routers`)
Der Router entscheidet, **OB** ein Request zu diesem Container darf.
Wichtigste Property: `rule`.

- `traefik.http.routers.my-app.rule=Host('app.localhost')`
- `traefik.http.routers.my-app.rule=Host('example.com') && Path('/api')`

### 2. Der Service (`services`)
Der Service entscheidet, **WOHIN** der Request im Container geht.
Traefik "rät" oft den Port (erster EXPOSE Port). Wenn das falsch ist, musst du helfen:

- `traefik.http.services.my-app.loadbalancer.server.port=3000`

### 3. EntryPoints
Wo hören wir? `web` (80) oder `websecure` (443).

- `traefik.http.routers.my-app.entrypoints=websecure`

---

## Beispiel: Dashboard Routing

Standardmäßig läuft das Traefik Dashboard auf Port 8080 (unsicher).
Wir wollen es aber unter `traefik.localhost` erreichen, genau wie unsere anderen Apps.

Wir müssen Traefik **sich selbst** labeln!

```yaml
services:
  reverse-proxy:
    image: traefik:v3.6.4
    command: --api.insecure=true --providers.docker
    ports:
      - "80:80"     # HTTP Port
      # Port 8080 mapping wir NICHT mehr nach außen!
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    labels:
      - "traefik.enable=true"
      # Router Regel:
      - "traefik.http.routers.dashboard.rule=Host(`traefik.localhost`)"
      # Service: Das Dashboard läuft intern auf Port 8080
      - "traefik.http.services.dashboard.loadbalancer.server.port=8080"

  whoami:
    image: traefik/whoami
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
```

Jetzt hast du unter `http://traefik.localhost` das Dashboard und unter `http://whoami.localhost` deine App. Alles über Port 80.
