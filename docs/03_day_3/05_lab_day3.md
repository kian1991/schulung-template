---
title: "05 Lab: Day 3 Production Challenge"
---

## Szenario: Going Live

Der Blog aus Tag 2 läuft. Aber wir wollen mehr Professionalität.

**Anforderungen:**
1. **Proxy:** Nutze Traefik, um den Blog unter `http://blog.localhost` verfügbar zu machen (ohne Port 8080!).
2. **Dashboard:** Aktiviere das Traefik Dashboard unter `http://traefik.localhost`, um deine Services zu sehen.
3. **Security:** Der Datenbank-User darf **nicht** `root` sein (haben wir in Day 2 hoffentlich schon beachtet? Check es!).
4. **Scale:** Wir erwarten Last. Starte 3 Instanzen des WordPress Containers (Skalierung).

## Tipps

- Traefik braucht Zugriff auf `/var/run/docker.sock`.
- Traefik braucht Labels an den Containern (Wordpress), damit es weiß, wohin es routen soll.
- `docker compose up -d --scale wordpress=3` (Achtung: Geht das mit Ports? Wenn du Port 8080 gemappt hast, knallt es beim 2. Container! Traefik löst das, weil wir keine Host-Ports mehr mappen müssen).

## Lösungsskizze

```yaml
services:
  reverse-proxy:
    image: traefik:3.6.4
    command: --api.insecure=true --providers.docker
    ports:
      - "80:80"        # Der einzige Port, der offen ist!
      - "8080:8080"    # Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

```

## Bonus: Registry

1. Starte eine lokale Registry (`docker run -d -p 5000:5000 registry:3`).
2. Tagge dein WordPress Image (falls du ein eigenes hättest) und pushe es.
3. Simuliere einen "Production Pull".
