---
title: "09 Bonus: Debugging Masterclass"
---

## Szenario

Es läuft nicht immer alles glatt.
Wir provozieren jetzt absichtlich Fehler, die dir im Alltag begegnen werden.
Ziel: Panik vermeiden, Logik anwenden.

## Aufgabe 1: Der Port-Konflikt

Der Klassiker: "Address already in use".

1. Starte einen Nginx auf Port 8080:
   `docker run -d -p 8080:80 --name web1 nginx:alpine`
2. Versuche, einen *zweiten* Nginx auf demselben Port zu starten:
   `docker run -d -p 8080:80 --name web2 nginx:alpine`

Lies die Fehlermeldung genau!
`Bind for 0.0.0.0:8080 failed: port is already allocated`.

3. Lösung: Starte den zweiten auf Port 8081.
   `docker run -d -p 8081:80 --name web2 nginx:alpine`

Merke: Der Container-Port (80) kann mehrfach existieren (in verschiedenen Containern). Der Host-Port (8080) ist exklusiv!

## Aufgabe 2: Sofortiger Crash (Exit 1)

Manchmal startet ein Container und stirbt sofort.

1. Versuche, ein Ubuntu im Hintergrund zu starten, ohne Befehl:
   `docker run -d --name sleepy_ubuntu ubuntu`
2. Checke [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/). Leer.
3. Checke `docker ps -a`. `STATUS: Exited (0)`.

Warum? Ein Container läuft nur, solange sein Hauptprozess läuft. Ubuntu (Bash) ohne Input beendet sich sofort.

**Lösung:** Gib ihm was zu tun (Sleep Loop) oder nutze `-it` (Interactive).
[`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) -d ubuntu sleep 300

## Aufgabe 3: Falsches Kommando

Wir wollen Python starten, vertippen uns aber.

[`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) python:slim phyton --version

Fehler: `docker: Error response from daemon: failed to create task for container: executable file not found in $PATH: unknown.`

Das bedeutet: Das Image ist okay, aber der Befehl (`phyton`), den du nach dem Image-Namen angegeben hast, existiert dort nicht.

## Aufgabe 4: Logs bei Start-Fehlern

Manchmal crasht die App intern.

1. Starte einen Container, der sofort crasht:
   `docker run -d --name crasher alpine sh -c "echo 'Critical Error Database missing'; exit 1"`
2. Er ist sofort weg (`docker ps -a` zeigt `Exited (1)`).
3. Wie findest du heraus, was passiert ist?
   [`docker logs`](https://docs.docker.com/reference/cli/docker/container/logs/) crasher

Logs sind dein erstes und wichtigstes Debugging-Tool!
