---
title: "02 Fort Knox"
---

## Szenario

Du bist Security Engineer. Entwickler wollen Container deployen. Du vertraust ihnen nicht.

## Aufgabe 1: Read-Only Filesystem

Start einen Nginx Container, der NICHT schreiben darf.
```bash
docker run --read-only -d --name secure-web nginx:alpine
```
Startet er? Nein/Vielleicht? Checke die Logs (`docker logs secure-web`).
Er wird sich beschweren, dass er Cache/PID files nicht schreiben kann.
**Fixe es mit temporären Volumes:**
```bash
docker run --read-only \
  --tmpfs /var/cache/nginx \
  --tmpfs /var/run \
  --tmpfs /etc/nginx/conf.d \
  -d --name secure-web-fixed nginx:alpine
```
*Versuche jetzt, per `docker exec` eine Datei im Container anzulegen (`touch /hacker.txt`). Geht das?*

## Aufgabe 2: Capabilities Dropping

Starte einen Container, der gar nichts darf.
```bash
docker run --rm -it --cap-drop=ALL alpine sh
```
- Versuche `date -s "2020-01-01"` (Zeit ändern).
- Versuche `chown 1000:1000 /bin/sh`.

Starte nun einen, der NUR `chown` darf:
```bash
docker run --rm -it --cap-drop=ALL --cap-add=CHOWN alpine sh
```
Geht `chown` jetzt? (Ja/Nein - probiere es an einer Datei in `/tmp`).

## Aufgabe 3: Der Nicht-Root User

Baue ein Dockerfile:
```dockerfile
FROM alpine
RUN adduser -D secur-o-matic
USER secur-o-matic
CMD ["whoami"]
```
Baue und starte es. Was gibt `whoami` aus?
Versuche im Dockerfile `apk add curl` *nach* dem `USER` Befehl. Geht das?
