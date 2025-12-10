---
title: "03 Multi-Stage Builds"
---

## Das Problem: Große Images

In der Vergangenheit brauchte man zwei Dockerfiles, um kleine Images zu bauen:
1. `Dockerfile.build`: Enthält alle Tools, Compiler, Header-Files (riesig).
2. Ein Shell-Skript kopiert das fertige Binary aus dem ersten Container auf den Host.
3. `Dockerfile.run`: Enthält nur das Binary (klein).

Das war nervig ("Builder Pattern").
Seit Docker 17.05 gibt es **Multi-Stage Builds**. Alles passiert in *einem* Dockerfile.

## Die Lösung: Stages

Multi-Stage Builds erlauben mehrere `FROM` Anweisungen in einem Dockerfile.
Jedes `FROM` beginnt einen neuen, frischen Layer-Stack (Stage).
Du kannst Artefakte von einer Stage in die nächste kopieren. Alles andere wird weggeworfen.

### Beispiel: Go Applikation

Go ist kompiliert. Zum Bauen brauchst du den Compiler (ca 800MB). Zum Ausführen nur Linux (5MB).

```dockerfile
# --- Stage 1: Builder ---
# Wir geben der Stage einen Namen ("builder")
FROM golang:1.22-alpine AS builder

WORKDIR /src
COPY . .
# Wir bauen das Binary nach /src/myapp
RUN go build -o myapp main.go

# --- Stage 2: Runtime ---
# Wir starten komplett neu mit einem leeren Alpine Image
FROM alpine:latest

WORKDIR /app

# Der Magische Befehl: COPY --from
COPY --from=builder /src/myapp .

CMD ["./myapp"]
```

**Ergebnis:** Das finale Image enthält *nur* das Binary und das Alpine OS. Kein Go-Compiler, kein Source-Code, kein Cache. Nichts.

## Anwendungsfälle

### 1. Frontend (Node.js -> Nginx)
Die klassische Web-App.
- Stage 1: Node.js Image. Führt `npm install` und `npm run build` aus. Ergebnis: Ein `dist/` oder `build/` Ordner mit HTML/CSS/JS.
- Stage 2: Nginx Image. Kopiert den Ordner nach `/usr/share/nginx/html`.
- **Vorteil:** Kein `node_modules` Ordner (hunderte MB) im Produktions-Image!

### 2. Python (C-Extensions)
Viele Python-Bibliotheken (`numpy`, `pandas`, `psycopg2`) sind eigentlich C-Programme mit Python-Wrapper.
Zum Installieren brauchen sie oft einen C-Compiler (`gcc`), wenn kein passendes "Wheel" (Binary) vorliegt (häufig bei Alpine Linux der Fall).

- Stage 1: Installiert Compiler (gcc, musl-dev) und baut Dependencies in ein Virtualenv.
- Stage 2: Kopiert nur das Virtualenv (`/opt/venv`).
- **Vorteil:** Die riesige Toolchain (gcc, make) landet nicht im finalen Image.

## Warum machen wir das?

1.  **Größe:** Kleine Images laden schneller, starten schneller und kosten weniger Speicher.
2.  **Sicherheit:** Ein Angreifer findet im Container keinen Compiler (`gcc`, `go`, `javac`), keinen Source-Code und keine Git-History. Das erschwert Exploits massiv.
3.  **Caching:** Jede Stage hat ihren eigenen Cache.

## Fortgeschrittene Techniken

### Stop at Stage
Du kannst nur bis zu einer bestimmten Stage bauen (z.B. zum Testen):
`docker build --target builder .`

### Externe Images
Du kannst sogar aus komplett fremden Images kopieren:
`COPY --from=nginx:alpine /etc/nginx/nginx.conf /app/nginx.conf`
