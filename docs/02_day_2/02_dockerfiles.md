---
title: "02 Creating Images (Dockerfile)"
---

## Das Dockerfile

Ein `Dockerfile` ist das Rezept, aus dem Docker ein Image backt.

Beispiel für eine kleine Web-App:

```dockerfile
# 1. Base Image: Wir fangen nicht bei Null an
FROM node:18-alpine

# 2. Arbeitsverzeichnis setzen
WORKDIR /app

# 3. Dependencies kopieren & installieren
# Trick: Erst nur package.json kopieren!
COPY package.json .
RUN npm install

# 4. Restlichen Code kopieren
COPY . .

# 5. Welches Kommando soll beim Start ausgeführt werden?
CMD ["node", "server.js"]
```

## Der Build

```bash
docker build -t my-web-app:v1 .
```

- `-t`: Tag (Name:Version).
- `.`: Build Context (wo liegt das Dockerfile?).

## Layer Caching (Performance Hack)

Docker führt jede Zeile im Dockerfile als neuen "Layer" aus. Das Geniale: Wenn sich nichts geändert hat, nimmt er den Cache.

Deshalb die Reihenfolge oben:
1. `COPY package.json`
2. `RUN npm install`
3. `COPY . .`

Wenn wir nur unseren Code ändern (`server.js`), bleibt `package.json` gleich. Docker erkennt: "Aha, Layer 1 und 2 sind identisch zum letzten Build. Ich nehme den Cache!" -> `npm install` dauert 0 Sekunden.

Würden wir *erst* alles kopieren (`COPY . .`) und *dann* installieren, würde jede Code-Änderung den Cache ungültig machen und `npm install` würde jedes Mal laufen. 😱

## Multi-Stage Builds (Größe sparen)

Für Go, Java oder C++ brauchen wir den Compiler nur zum *Bauen*, nicht zum *Ausführen*.

```dockerfile
# Stage 1: Build
FROM golang:1.21-alpine AS builder
WORKDIR /src
COPY . .
RUN go build -o myapp main.go

# Stage 2: Runtime (winziges Image)
FROM alpine:latest
WORKDIR /root/
# Wir kopieren nur das Binary rüber!
COPY --from=builder /src/myapp .
CMD ["./myapp"]
```

Ergebnis: Ein Image von 10 MB statt 800 MB.

## Best Practices

:::warning[.dockerignore]
Erstelle IMMER eine `.dockerignore`-Datei (wie `.gitignore`). Pack dort `node_modules`, `.git`, `.env` rein. Das verhindert, dass Müll in den Build Context kopiert wird.
:::

- **Image Tags:** Nutze spezifische Versionen (`node:18` statt `node:latest`).
- **User:** Lauf nicht als Root! (Dazu später mehr).
