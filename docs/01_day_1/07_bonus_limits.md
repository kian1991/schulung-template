---
title: "07 Bonus: Limits & Crash Test"
---

## Szenario

Container gieren nach RAM. Wenn du sie nicht einschränkst, nehmen sie sich alles.
Wir wollen sehen, was passiert, wenn wir den Hahn zudrehen.

## Aufgabe 1: Das RAM-Limit

Wir starten einen Container, der nur **6 Megabyte** RAM nutzen darf.

```bash
docker run -d \
  --name weakling \
  --memory="6m" \
  alpine sh -c "x=0; while true; do x=\$x\$x; done"
```
*(Dieser Befehl füllt eine Variable unendlich -> Memory Leak)*

### Beobachten

Schau dir die Stats an:
[`docker stats`](https://docs.docker.com/reference/cli/docker/container/stats/)

Warte kurz. Was passiert?

Prüfe den Container:
[`docker inspect`](https://docs.docker.com/reference/cli/docker/container/inspect/) weakling | grep OOMKilled

Wenn da `true` steht, hat der Kernel den Prozess beendet (OOMKilled). Das ist gut! Besser der Container stoppt als dein Server.

## Aufgabe 2: Stehaufmännchen (Restart Policies)

Normalerweise bleiben gestoppte Container gestoppt.
Wir wollen aber, dass unser Webserver immer läuft.

```bash
docker run -d \
  --name phoenix \
  --restart always \
  nginx:alpine
```

### Zerstörung

Finde den Hauptprozess (PID 1) im Container und töte ihn.
Oder einfacher: Stop ihn nicht gracefully, sondern erzwinge den Stop.

```bash
docker kill phoenix
```

Prüfe sofort [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/).
Du wirst sehen:
`STATUS: Up 2 seconds`

Er ist wieder da! Aber er hat eine neue Start-Zeit.
Schau dir [`docker inspect`](https://docs.docker.com/reference/cli/docker/container/inspect/) phoenix -> `RestartCount` an.

## Wann welche Policy?

- `no`: Standard. Bleibt aus. (Job-Container, DB Migrationen).
- `on-failure`: Nur wenn Exit-Code != 0. (Gut für Programme die crashen).
- `always`: Immer. Auch nach Docker-Daemon Neustart. (Webserver, DBs).
- `unless-stopped`: Wie always, außer DU hast ihn manuell gestoppt ([`docker stop`](https://docs.docker.com/reference/cli/docker/container/stop/)).
