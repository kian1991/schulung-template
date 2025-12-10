---
title: "04 Capstone: The Production Stack"
---

## Szenario: "We go Live!"

Der Chef ist begeistert von deiner Mini-API. Aber:
1. "Das Log-Format ist furchtbar!" -> Wir brauchen `pino` (JSON Logger).
2. "Das Image ist zu groß!" -> Wir brauchen Multi-Stage Builds.
3. "Keine statischen Ports mehr!" -> Wir brauchen Traefik.
4. "Security!" -> Kein Root-User im Container.

Das ist deine finale Prüfung für Day 3.

## Step 1: Der Code (mit Dependencies)

Wir nutzen `pino` für schöne Logs. Das bedeutet, wir haben jetzt eine **echte Dependency** (`node_modules`), die wir installieren müssen.

Erstelle `app/package.json`:
```json
{
  "name": "pro-api",
  "module": "index.ts",
  "dependencies": {
    "pino": "^9.0.0"
  }
}
```

Erstelle `app/index.ts`:
```typescript
import { sql } from "bun";
import pino from "pino";

const logger = pino();
logger.info("Application starting...");

Bun.serve({
  port: 3000, // Interner Port
  async fetch(req) {
    const url = new URL(req.url);
    if (url.pathname === "/api") {
      logger.info({ msg: "Request received", path: url.pathname });
      
      // DB Check (Native Bun SQL)
      try {
        const result = await sql`SELECT 1 as alive`;
        return Response.json({ status: "OK", db: result[0].alive });
      } catch (err) {
        logger.error(err);
        return Response.json({ status: "Error" }, { status: 500 });
      }
    }
    return new Response("Not Found", { status: 404 });
  },
});
```

## Step 2: Das Dockerfile

Schreibe ein `Dockerfile`. Es **muss** folgende Kriterien erfüllen:
1. **Multi-Stage:**
   - Stage 1 (`base`): Installiert Dependencies (`bun install`).
   - Optional: Ihr koennt mit bun auch bundlen dann haben wir eine single executable 
   `bun build ./index.ts --outdir ./build`
   - Stage 2 (`release`): Kopiert *nur* `node_modules` und `index.ts`. (oder falls ihr gebunlet habt nur die `index.ts`)
2. **Security:**
   - Lege einen User `nodejs` an.
   - Wechsele zu diesem User (`USER nodejs`).
3. **Execution:**
   - Starte die App mit `CMD` oder `ENTRYPOINT`. Tipp: `bun run index.ts`

Schaue mal in die [docs](https://bun.com/docs/guides/ecosystem/docker) für bun zum Thema docker.

:::note[Lazy Dev]
Ihr könnt die pre-release stage weglassen.
:::

## Step 3: Infrastructure (Traefik)

Erstelle eine `docker-compose.yml`.

Hier ist der Traefik-Teil (geschenkt):
```yaml
services:
  traefik:
    image: traefik:v3.6.4
    command: --api.insecure=true --providers.docker
    ports:
      - "80:80"      # Web
      - "8080:8080"  # Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  # DEINE SERVICES HIER DRUNTER:
  
  # 1. Database (Postgres)
  # ...

  # 2. App
  # ...
```

**Anforderungen an den App Service:**
- **Build Context:** Nutze dein Dockerfile.
- **Ports:** KEINE Ports (`ports:`) mappen! Container sollen von außen nicht direkt erreichbar sein.
- **Labels:** Sage Traefik, dass er Requests an `api.localhost` an diesen Service leiten soll.
- **Env:** Übergib die DB-Credentials (`DATABASE_URL` etc.) via `env_file`

## Step 4: Verify

1. `docker compose up -d --build`
2. Öffne `http://traefik.localhost:8080` -> Siehst du deine App?
3. Öffne `http://api.localhost/api` -> Bekommst du JSON?
4. Schau die Logs an (`docker compose logs -f app`) -> Siehst du JSON-Logs von Pino?

## Bonus: Scaling

Traefik ist ein Load Balancer. Beweise es.
```bash
docker compose up -d --scale app=3
```

