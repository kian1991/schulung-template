---
title: "02 Dockerfile"
---

## Was ist ein Dockerfile?

Ein `Dockerfile` ist der Bauplan für ein Image.
Es ist eine einfache Textdatei mit Befehlen, die Docker Zeile für Zeile abarbeitet.
Jede Zeile erzeugt einen neuen **Layer** im Image Filesystem.

## Die Befehls-Referenz (Vokabeln)

Hier sind die wichtigsten Instruktionen, die du kennen musst:

| Befehl | Zweck | Layer? | Beispiel |
| :--- | :--- | :--- | :--- |
| **`FROM`** | Basis-Image. Muss die erste Zeile sein. | Ja | `FROM node:alpine` |
| **`WORKDIR`** | Setzt das Arbeitsverzeichnis ("cd"). | Nein | `WORKDIR /app` |
| **`COPY`** | Kopiert Dateien vom Host in den Container. | Ja | `COPY . .` |
| **`RUN`** | Führt Befehle *während des Builds* aus (Installation). | Ja | `RUN apt-get update` |
| **`ENV`** | Setzt permanente Umgebungsvariablen. | Ja | `ENV PORT=80` |
| **`ARG`** | Setzt Variablen nur für den *Build-Prozess* (flüchtig). | Nein | `ARG VERSION=1.0` |
| **`EXPOSE`** | Doku-Hinweis: "Ich höre auf Port X". Tut technisch nichts. | Nein | `EXPOSE 80` |
| **`CMD`** | Standard-Startbefehl (kann überschrieben werden). | Nein | `CMD ["node", "app.js"]` |
| **`ENTRYPOINT`** | Hauptprozess, der *immer* ausgeführt wird. | Nein | `ENTRYPOINT ["/app/start.sh"]` |

---

## Deep Dive: CMD vs. ENTRYPOINT

Das ist die wichtigste Unterscheidung, die oft falsch gemacht wird.

### 1. `CMD` (Der Vorschlag)
"Führe das aus, wenn der User nichts anderes sagt."

```dockerfile
CMD ["echo", "Hallo"]
```
- `docker run my-image` -> "Hallo"
- `docker run my-image Tschüss` -> "Tschüss" (CMD wird komplett ersetzt!)

Nutze `CMD` für Default-Parameter.

### 2. `ENTRYPOINT` (Das Gesetz)
"Führe das IMMER aus. Hänge User-Eingaben hinten an."

```dockerfile
ENTRYPOINT ["echo"]
CMD ["Hallo"]
```
- `docker run my-image` -> "Hallo" (ENTRYPOINT + CMD)
- `docker run my-image Tschüss` -> "Tschüss" (ENTRYPOINT + User Input)

Nutze `ENTRYPOINT` für Binaries, die feststehen (z.B. `git`, `python`, `npm`), oder für **Setup-Skripte**.

### 3. Der "Image als Binary" Pattern (Best Practice)

Eine coole Anwendung von ENTRYPOINT ist es, ein Image wie ein fertiges Programm (Binary) wirken zu lassen.
Beispiel Redis:

```dockerfile
ENTRYPOINT ["redis-server"]
CMD ["--help"]
```

- Startest du `docker run my-redis`, wird `redis-server --help` ausgeführt.
- Startest du `docker run my-redis --port 6379`, wird `redis-server --port 6379` ausgeführt.

Das Argument des Nutzers wird einfach an das Binary angehängt. Das fühlt sich sehr professionell an!

### 4. Der Default Entrypoint (`/bin/sh -c`)

Wusstest du? Wenn du gar keinen Entrypoint setzt, nutzt Docker standardmäßig `/bin/sh -c`.
Das ist der Grund, warum `RUN npm install` funktioniert -> Docker führt eigentlich `/bin/sh -c "npm install"` aus.

Das ist auch der Grund für die **Shell Form vs. Exec Form** Problematik:
- `CMD node app.js` -> Docker macht daraus `/bin/sh -c "node app.js"`.
- `/bin/sh` erlaubt uns zwar Variablen (`$HOME`) zu nutzen, leitet aber Signale nicht weiter.

Deshalb: Wenn du ein Programm starten willst, nutze immer `["exec", "form"]`, damit umgehst du die Shell.


---

## Das Entrypoint-Skript Pattern

Oft muss man vor dem Start noch Dinge tun:
- Warten bis die Datenbank da ist.
- Config-Dateien generieren.
- Rechte anpassen.

Dafür nutzt man ein Shell-Skript als Entrypoint.

**Dockerfile:**
```dockerfile
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "app.js"]
```

**entrypoint.sh:**
```bash
#!/bin/sh
# 1. Setup Logic
echo "Checking DB connection..."
if [ ! -f config.json ]; then
    echo "{}" > config.json
fi

# 2. ÜBERGABE an den eigentlichen Prozess
# 'exec' ist magisch: Es ersetzt den Shell-Prozess durch den CMD-Befehl.
# Damit wird 'node app.js' zu PID 1.
exec "$@"
```

---

## Der Build-Prozess & Layer Caching

Wenn du `docker build` ausführst:
1. Docker lädt den **Build Context** (alles im Ordner) an den Daemon.
2. Er geht das Dockerfile Zeile für Zeile durch.
3. Für jede Zeile schaut er: "Habe ich diesen Layer schon im Cache?"

### Optimierung: Caching nutzen

**Schlecht:**
```dockerfile
COPY . .
RUN npm install
```
Änderst du nur ein Leerzeichen in `README.md`, bricht der Cache bei `COPY . .`. Der teure `RUN npm install` muss neu laufen.

**Gut:**
```dockerfile
COPY package.json .
RUN npm install
COPY . .
```
Jetzt läuft `npm install` nur, wenn sich `package.json` ändert. Code-Änderungen sind super schnell.

---

## Multi-Stage Builds

Wir wollen kleine Images. Der Go-Compiler (800MB) hat im Produktions-Image nichts verloren.

```dockerfile
# Stage 1: Builder (Hat alle Tools)
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp .

# Stage 2: Runtime (Hat nur das Nötigste)
FROM alpine:latest
WORKDIR /app
# Wir klauen das fertige Binary aus Stage 1
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

Ergebnis: Ein 10MB Image statt 800MB.

## Best Practices

1. **`.dockerignore`**: Erstelle diese Datei! Schreibe `node_modules`, `.git`, `.env` hinein. Docker soll diese Dateien nicht sehen.
2. **User**: Standardmäßig bist du `root` im Container. Das ist unsicher.
   ```dockerfile
   RUN adduser -D myuser
   USER myuser
   ```
3. **Tags**: Vermeide `latest` in Produktion. Nutze `node:20-alpine`, damit du weißt, was drin ist.
