---
title: "02 The Mini API Stack"
---

## Szenario

Wir bauen eine moderne 3-Tier Web-Applikation.
1. **Frontend/Proxy:** Nginx (Static Content & Reverse Proxy).
2. **Backend:** Eine Bun (oder Node) API.
3. **Datenbank:** Postgres.

## Die Komponenten

### 1. Das Backend (`api/`)
Erstelle einen Ordner `api`.

**Der Code (`api/index.ts`):**

Wir nutzen den **nativen Bun SQL Client** (`import { sql } from "bun"`). 
Dieser braucht keine `package.json` und keine Installation! Er ist einfach da.

```typescript
import { sql } from 'bun';

console.log('Connecting to DB...');

const server = Bun.serve({
  port: 3000,
  async fetch(req) {
    const url = new URL(req.url);

    if (url.pathname === '/api' || url.pathname === '/api/') {
      return new Response(
        JSON.stringify({
          message: 'API is up. Try /api/status for health info.',
        })
      );
    }

    if (url.pathname === '/api/status') {
      // 1. Table erstellen (falls nicht da)
      await sql`CREATE TABLE IF NOT EXISTS hits (timestamp text)`;

      // 2. Insert Hit
      await sql`INSERT INTO hits (timestamp) VALUES (${new Date().toISOString()})`;

      // 3. Count Hits
      const result = await sql`SELECT count(*) FROM hits`;
      const count = result[0].count;

      return new Response(
        JSON.stringify({
          status: 'Alive',
          db_host: process.env.DB_HOST || 'Detected from ENV',
          total_hits: count,
        })
      );
    }

    return new Response('Not Found', { status: 404 });
  },
});

console.log(`Listening on localhost:${server.port}`);
```

### 2. Der Proxy (`nginx/`)
Erstelle einen Ordner `nginx`.
Erstelle eine `nginx.conf`:

```nginx
events {}
http {
    server {
        listen 80;
        
        # Statischer Content (Bonus, wenn du willst)
        location / {
            return 200 "Welcome to the Frontend!";
        }

        # Proxy zur API
        location /api/ {
            proxy_pass http://backend:3000;
        }
    }
}
```

## Deine Mission (compose.yml)

Schreibe die `docker-compose.yml`.

1. **Service `db`:**
   - Image: `postgres:alpine`.
   - Setze User/Passwort via ENV.
2. **Service `backend`:**
   - Image: `oven/bun:alpine`.
   - **Mount:** Binde den `api` Ordner in den Container (z.B. nach `/app`).
   - **Command:** `bun run /app/index.ts`.
   - **Env:** Der native Bun Client sucht automatisch nach `DATABASE_URL`.
     - `DATABASE_URL=postgres://user:password@db:5432/dbname`
     - (Ersetze user, password, dbname mit deinen Werten aus dem DB-Service).
   - Port: Muss *nicht* nach außen freigegeben werden (nur intern für Nginx).
3. **Service `proxy`:**
   - Image: `nginx:alpine`.
   - **Mount:** Binde deine `nginx.conf` nach `/etc/nginx/nginx.conf`.
   - **Port:** 8080 auf Host -> 80 im Container.
   - **Depends On:** Sollte auf `backend` warten.

## Test
1. `docker compose up`.
2. Gehe auf `http://localhost:8080/api/status`.
3. Du solltest das JSON sehen. `total_hits` sollte bei jedem Reload steigen!

**Lernziel:** Service Discovery (Nginx findet Backend), Volume Mounts für Config/Code und Multi-Container Setup.
