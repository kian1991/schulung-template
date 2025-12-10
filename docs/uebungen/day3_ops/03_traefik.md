---
title: "03 Traefik Routing"
---

## Szenario

Wir bauen einen "Mini-Cluster" auf deinem Laptop.
Statische Ports (8081, 8082, ...) nerven. Wir wollen sprechende Namen.
- `whoami.localhost` -> Container A
- `nginx.localhost` -> Container B

## Die Lösung

Erstelle eine `docker-compose.yml`:

```yaml
services:
  # Der Router
  traefik:
    image: traefik:v3.0
    command: --api.insecure=true --providers.docker
    ports:
      - "80:80"     # HTTP
      - "8080:8080" # Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  # App 1
  whoami:
    image: traefik/whoami
    labels:
      - "traefik.http.routers.my-whoami.rule=Host(`whoami.localhost`)"

  # App 2
  web:
    image: nginx:alpine
    labels:
      - "traefik.http.routers.my-nginx.rule=Host(`nginx.localhost`)"
```

## Tasks

1. Starte den Stack (`docker compose up -d`).
2. Öffne das Dashboard (`localhost:8080`). Siehst du die Router?
3. Öffne `http://whoami.localhost`. Landest du beim richtigen Container?
4. **Challenge:** Füge eine Basic-Auth Middleware hinzu (Recherche nötig: "Traefik BasicAuth Middleware Labels").
