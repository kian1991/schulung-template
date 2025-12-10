---
title: "04 Docker Compose"
---

## Die `docker-compose.yml`

Alles wird in einer YAML-Datei definiert.

```yaml


services:
  webapp:
    build: .             # Baut das Dockerfile im aktuellen Ordner
    ports:
      - "3000:3000"
    environment:
      - DB_HOST=database #DNS Name = Service Name
    depends_on:
      - database

  database:
    image: postgres:alpine
    environment:
      POSTGRES_PASSWORD: secretpassword
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:               # Definiert das Volume (Managed by Docker)
```

## Die Befehle

Einfacher geht's nicht:

| Befehl | Was passiert? |
| :--- | :--- |
| [`docker compose up`](https://docs.docker.com/reference/cli/docker/compose/up/) | Baut Images, erstellt Netzwerke, Volumes und startet alle Container (Vordergrund). |
| `docker compose up -d` | Das Gleiche, aber im Hintergrund (Detached). |
| [`docker compose down`](https://docs.docker.com/reference/cli/docker/compose/down/) | Stoppt und **löscht** Container und Netzwerke. (Volumes bleiben!). |
| `docker compose down -v` | Löscht AUCH die Volumes (Alles weg!). |
| [`docker compose ps`](https://docs.docker.com/reference/cli/docker/compose/ps/) | Zeigt Status des Stacks. |
| [`docker compose logs`](https://docs.docker.com/reference/cli/docker/compose/logs/) -f | Zeigt Logs aller Services aggregiert. |

## DNS Magic

In Compose wird automatisch ein Netzwerk für den Stack erstellt.
Jeder Service ist unter seinem Service-Namen (`webapp`, `database`) erreichbar.
Kein IP-Raten, keine manuellen Links.

:::info[Environment Variables]
Nutze `.env` Dateien neben der YAML. Compose liest die automatisch.
YAML: `POSTGRES_PASSWORD: ${DB_PASS}`
:::

-> [Hier geht's zur Übung](../uebungen/compose/01_wordpress.md)
