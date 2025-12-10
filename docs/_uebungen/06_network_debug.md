---
title: "Übung 6: Network Debugging"
---

## Szenario

Du hast zwei Container. Sie sollen sich pingen können. Aber es geht nicht. Finde den Fehler.

### Setup

Starte dieses Setup:

```bash
docker network create net-a
docker network create net-b

docker run -d --name service-1 --network net-a alpine sleep 3600
docker run -d --name service-2 --network net-b alpine sleep 3600
```

### Aufgabe

1. Versuche von `service-1` den `service-2` zu pingen. (`docker exec -it service-1 ping service-2`)
2. Analysiere das Problem.
3. Fixe es, OHNE die Container neu zu starten.

<details>
<summary>Lösung</summary>

Das Problem: Sie sind in verschiedenen Netzwerken. Isolation works!

Lösung:
Wir hängen `service-1` zusätzlich in `net-b` ein.

```bash
docker network connect net-b service-1
docker exec -it service-1 ping service-2
```
</details>
