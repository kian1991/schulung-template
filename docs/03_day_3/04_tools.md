---
title: "04 Tools & Operations"
---

Neben der Registry, Security und dem Proxy gibt es weitere Tools, die den Docker-Alltag erleichtern.

## Portainer (UI Dashboard)

Viele mögen die Kommandozeile (`docker ps`) nicht.
[Portainer](https://www.portainer.io/) ist ein mächtiges Web-Interface für Docker.

- Container starten/stoppen per Klick.
- Logs im Browser lesen.
- Exec Console im Browser.
- Stacks (Compose Files) im Browser editieren.

Starten ist ein Einzeiler:
```bash
docker run -d -p 9000:9000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    portainer/portainer-ce
```
Gehe auf `localhost:9000`.

:::warning[Security Risiko]
Portainer hat vollen Zugriff auf den Docker Socket. Wer Portainer kontrolliert, ist faktisch Root auf deinem Server.
Schütze es gut (starkes Passwort, nicht öffentlich ins Netz)!
:::

## Watchtower (Auto Updates)

Was passiert, wenn ein neues Image (`v2`) herauskommt?
Manuell `docker pull` und `docker compose up -d` ist mühsam.

[Watchtower](https://containrrr.dev/watchtower/) automatisiert das.
Es prüft regelmäßig, ob es neuere Images für deine laufenden Container gibt.
Wenn ja:
1. Pull neues Image.
2. Stop Container.
3. Start Container (mit den gleichen Einstellungen).

```bash
docker run -d \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower
```
Dies aktualisiert ALLE Container. Du kannst es auch auf einzelne beschränken.

## LazyDocker (Terminal UI)

Für die CLI-Liebhaber, die mehr Komfort wollen: [LazyDocker](https://github.com/jesseduffield/lazydocker).
Ein Terminal-Grafik-Interface (TUI). Extrem schnell, Maus-Support, coole Graphen.
Sehr zu empfehlen für Entwickler!
