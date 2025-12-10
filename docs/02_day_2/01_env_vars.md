---
title: "02 Environment Variables"
---

## Konfiguration von außen

Apps sollten **nicht** hartcodierte Werte haben (z.B. Datenbank-Passwörter im Code).
Die Lösung: **Environment Variables (ENV Vars)**.

Das Prinzip der **12-Factor App**: Config gehört ins Environment, nicht in den Code.

## 1. ENV zur Build-Zeit (Dockerfile)

Du kannst Variablen direkt im Image setzen. Sie sind dann immer verfügbar.

```dockerfile
FROM python:slim
ENV APP_COLOR=blue
CMD ["python", "app.py"]
```

### Exkurs: `ARG` vs `ENV`
- `ENV`: Ist persistent. Auch im laufenden Container verfügbar.
- `ARG`: Ist nur **während des Builds** verfügbar (z.B. Software-Versionen). Verpufft danach.


## 2. ENV zur Laufzeit (CLI)

Du kannst Werte beim Starten überschreiben. Das ist der Standard-Weg.

```bash
docker run -e APP_COLOR=red my-app
```

Das `-e` Flag (oder `--env`) überschreibt alles, was im Dockerfile steht.

## Mini-Übung 1: Überschreiben

1. Starte ein Node-Image und lass dir die Variable ausgeben:
   `docker run node:alpine printenv NODE_VERSION`
2. Jetzt setze eine eigene Variable:
   `docker run -e MEIN_NAME=Kian node:alpine printenv MEIN_NAME`

## 3. ENV Files (`.env`)

Wenn du 20 Variablen hast, wird der CLI Befehl unlesbar.
Lösung: Eine Datei (meist `.env`), die du injizierst.

**Datei `.env`:**
```bash
DB_HOST=localhost
DB_USER=root
SECRET_KEY=12345
```

**Befehl:**
```bash
docker run --env-file .env my-app
```

## Mini-Übung 2: File Injection

1. Erstelle eine Datei `config.list`:
   ```bash
   USER=admin
   ROLE=superuser
   ```
2. Starte einen Container und prüfe, ob die Werte da sind:
   `docker run --env-file config.list alpine printenv`

## Sicherheitshinweis

Schreibe **niemals** Secrets (Passwörter, API Keys) direkt in das Dockerfile (`ENV PASSWORD=secret`). Jeder, der das Image hat, kann `docker history` machen und das Passwort sehen!
Nutze ENV Vars im Dockerfile nur für Defaults (z.B. `PORT=8080`), aber injiziere Secrets immer erst zur Laufzeit via `-e` oder `--env-file`.
