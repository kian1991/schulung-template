---
title: "08 Bonus: Pro CLI Tools"
---
v

## Aufgabe 1: Der Einbruch (`docker cp`)

Manchmal musst du schnell eine Config-Datei aus einem Container holen oder patchen, ohne Volumes zu haben.

1. Starte einen Nginx:
   `docker run -d --name webserver nginx:alpine`
2. Erstelle lokal eine Datei `index.html` mit Inhalt "Hacked by Docker CLI".
3. Kopiere sie in den laufenden Container:
   `docker cp index.html webserver:/usr/share/nginx/html/index.html`
4. Prüfe es via Curl oder Browser (Port Forwarding vergessen? Nutze `docker exec webserver cat ...`).

## Aufgabe 2: Spurensicherung (`docker diff`)

Was hat sich im Container verändert?
Führe `docker diff webserver` aus.

Du wirst sehen:
- `C` (Changed): `/usr/share/nginx/html`
- `A` (Added): `.../index.html` (oder C, je nach Base Image).

Das ist extrem nützlich, wenn ein Container sich komisch verhält und du wissen willst, welche Dateien er zur Laufzeit geschrieben hat.

## Aufgabe 3: Snapshot (`docker commit`)

Man kann auch Container manuell "frieren".

1. Installiere `curl` im Nginx Container (Alpine):
   `docker exec webserver apk add --no-cache curl`
2. Prüfe, ob es geklappt hat (`docker exec webserver curl --version`).
3. Erstelle ein Image aus diesem Zustand:
   `docker commit webserver my-hacked-nginx:v1`
4. Stoppe und lösche den alten `webserver`.
5. Starte das neue Image. Ist `curl` noch da?

:::info[Historie]
So hat man früher Images gebaut. Heute nutzen wir **Dockerfiles** (Tag 2), weil `commit` nicht reproduzierbar ist (niemand weiß, was du getippt hast). Aber um mal eben einen Stand zu sichern, ist es goldwert.
:::

## Aufgabe 4: Offline Transport (`save` & `load`)

Wie kriegst du ein Image auf einen Server ohne Internet (Air-Gapped)?

1. Speichere dein Image als Tar-Archiv:
   `docker save -o my-image.tar my-hacked-nginx:v1`
2. Lösche das Image aus Docker:
   `docker rmi my-hacked-nginx:v1`
3. Lade es aus der Datei wieder rein:
   `docker load -i my-image.tar`

Das file `my-image.tar` könntest du jetzt auf einen USB-Stick ziehen.
