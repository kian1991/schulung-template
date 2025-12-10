---
title: "10 Bonus: CLI Ninja"
---

## Szenario

Du hast 50 Container. `docker ps` ist unlesbar. Du willst nur die IP-Adressen wissen.
Willkommen bei der **Formatierung**.

## Aufgabe 1: Pretty Print

Standard [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) ist chaotisch (Zeilenumbruch bei kleinen Fenstern).

1. Zeige nur ID und Image an:
   [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) --format "table {{.ID}}\t{{.Image}}"
2. Zeige nur den Namen und Status:
   [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) --format "table {{.Names}}\t{{.Status}}"

Pro-Tipp: Leg dir dafür einen Alias an oder konfiguriere `~/.docker/config.json`.

## Aufgabe 2: Inspect Chirurgie

[`docker inspect`](https://docs.docker.com/reference/cli/docker/container/inspect/) gibt riesiges JSON zurück. Wir wollen nur einen Wert.
Wir nutzen Go-Templates.

1. Starte einen Container: [`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) -d --name info-test nginx:alpine
2. Hole die **IP-Adresse**:
   [`docker inspect`](https://docs.docker.com/reference/cli/docker/container/inspect/) -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' info-test
3. Hole den **Status**:
   [`docker inspect`](https://docs.docker.com/reference/cli/docker/container/inspect/) -f '{{.State.Status}}' info-test

## Aufgabe 3: Batch Operations (The Nuclear Option)

Wie löscht man **alle** Container auf einmal?
Indem man den Output des einen Befehls als Input für den anderen nimmt.

1. Liste **nur die IDs** aller Container auf (`-q` = quiet):
   [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) -aq
2. Übergib diese Liste an `docker rm`:

   ```bash
   # ACHTUNG: Löscht alles!
   docker rm -f $(docker ps -aq)
   ```

   (In PowerShell: `docker ps -aq | ForEach-Object { docker rm -f $_ }`)

## Aufgabe 4: Filter

Ich will nur Container sehen, die "test" im Namen haben.

[`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) -f "name=test"

Oder nur gestoppte Container:
[`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/) -f "status=exited"

Das ist viel performanter als `grep`, weil Docker schon filtert.
