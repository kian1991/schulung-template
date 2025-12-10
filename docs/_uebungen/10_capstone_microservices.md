---
title: "Übung 10: Capstone - The Microservice Zoo"
---

## Das Szenario

Wir bauen eine komplette Microservices-Architektur für einen Zoo.
Es gibt zwei Services:
1.  **Seal API**: Verwaltet die Robben (Seals). Nutzt PostgreSQL.
2.  **User API**: Verwaltet die Mitarbeiter. Nutzt MongoDB.

Alles soll über einen zentralen Eingang (**Traefik**) erreichbar sein.

## Deine Mission

Du hast den Quellcode in `docs/assets/seal-api` und `docs/assets/user-api`.
Aber keine Dockerfiles. Und keine Compose-Datei.
Das ist dein Job.

### Aufgabe 1: User API

Der Code liegt in `assets/user-api`. Es ist eine Bun App.
1. Schreibe ein `Dockerfile`.
   - Base Image: `oven/bun:latest`
   - Kopiere `package.json` (erstelle eine Dummy Datei `{"name": "user-api", "dependencies": {"hono": "^4.0.0", "mongodb": "^6.0.0"}}` wenn keine da ist, oder installiere es im Container).
   - Installiere Dependencies (`bun install`).
   - Kopiere den Code.
   - CMD: `bun run index.ts`.

### Aufgabe 2: Seal API

Der Code liegt in `assets/seal-api`. Auch Bun, aber wir wollen ein **Multi-Stage Build**.
1. Stage 1 (`build`): Dependency Installation.
2. Stage 2 (`release`): Nur `node_modules` und Code kopieren.
3. Base Image: `oven/bun:distroless` (oder alpine).

### Aufgabe 3: Infrastructure

Erstelle eine `docker-compose.yml`. Wir brauchen:
1.  **Traefik**:
    -   Ports: 80 (Web), 8080 (Dashboard).
    -   Docker Socket Mount.
2.  **Postgres** (für Seal API):
    -   Muss mit Daten befüllt werden! Mount das `init.sql` aus `assets/seal-api` nach `/docker-entrypoint-initdb.d/init.sql`.
    -   User/Passwort via Environment Variables.
3.  **MongoDB** (für User API):
    -   Einfacher Mongo Container.
4.  **Seal Service**:
    -   Baut aus deinem Dockerfile.
    -   Verbindet sich zu Postgres (siehe `index.ts` Code für Env Vars? Nein, Bun SQL nutzt meist Standard Env Vars wie `PGHOST`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`). Checke die Doku oder setze sie auf Verdacht!
    -   Traefik Label: `Host(seals.localhost)`.
5.  **User Service**:
    -   Baut aus deinem Dockerfile.
    -   Verbindet sich zu Mongo (Env Var `MONGO_URL`).
    -   Traefik Label: `Host(users.localhost)`.

### Aufgabe 4: Run & Test

1.  [`docker compose up`](https://docs.docker.com/reference/cli/docker/compose/up/) `--build`.
2.  Gehe auf `http://traefik.localhost` (Dashboard). Siehst du alle Services?
3.  Gehe auf `http://seals.localhost/seals`. Kommen Daten? (Wenn ja: Postgres Init hat geklappt!).
4.  Gehe auf `http://users.localhost/users`. Erstelle einen User per `curl -X POST`.

## Tipps

-   **Networking**: Alle müssen im selben Netz sein.
-   **Ports**: Die APIs hören intern auf Port 3000 (Seal) und 3001 (User). Du musst Traefik sagen, wo er hinhören soll, wenn es nicht Standard 80 ist!
    -   Label: `traefik.http.services.seal-service.loadbalancer.server.port=3000`
