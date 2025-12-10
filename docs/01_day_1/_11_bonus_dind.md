---
title: "11 Bonus: Docker Socket"
---

## Szenario

Du hast sicher schon mal gehört: "Wir mounten den Docker Socket".
Aber was bedeutet das? Und warum ist das gefährlich?

## Hintergrund

Der Docker CLI Befehl (`docker ...`) spricht gar nicht direkt mit Containern. Er spricht mit der API des **Docker Daemons** (`dockerd`).
Diese Kommunikation läuft über einen Unix Socket: `/var/run/docker.sock`.

Wenn wir diesen Socket in einen Container "reinreichen", kann der Container den Docker Daemon des Hosts steuern.
Das ist wie `sudo` ohne Passwort.

## Aufgabe 1: Inception

Wir starten einen Container, der Docker installiert hat, aber **keinen eigenen Daemon** hat. Stattdessen darf er unseren Daemon nutzen.

1. Starte ein Docker Image:
   ```bash
   docker run -it -v /var/run/docker.sock:/var/run/docker.sock docker:cli sh
   ```
2. Jetzt bist du *im* Container.
3. Tippe: [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/).
   Du siehst die Container deines Hosts! (Auch diesen "docker:cli" Container selbst).
4. Tippe: [`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) hello-world.
   Der Daemon auf deinem Host wird angewiesen, `hello-world` zu starten. Er startet *neben* deinem Container, nicht *darin*.

## Warum macht man das?

- **CI/CD:** Jenkins Agenten laufen im Container, müssen aber Images bauen und pushen.
- **Monitoring:** Portainer oder Traefik müssen wissen, welche Container laufen.

## Die Gefahr

Wenn ein Angreifer diesen Container übernimmt (z.B. durch eine Lücke in der Web-App), kann er:
[`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) -v /:/host alpine ...
...und hat plötzlich **Root-Zugriff auf dein gesamtes Dateisystem**.

Deshalb: Vorsicht mit dem Docker Socket!
