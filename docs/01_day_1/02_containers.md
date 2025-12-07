---
title: "02 Management & CLI"
---

## Der erste Container

Starte den Klassiker:

```bash
docker run hello-world
```

Was ist passiert?
1. Docker Client hat Daemon gefragt: "Hast du das Image `hello-world`?"
2. Daemon: "Nö." -> Pullt es vom Docker Hub.
3. Daemon startet Container aus dem Image.
4. Container führt Code aus ("Hello from Docker!").
5. Container beendet sich (Exit 0).

## Container Lifecycle: Run, Stop, Start, RM

Wichtige Befehle, die du im Schlaf können musst:

| Befehl | Funktion |
| :--- | :--- |
| `docker run` | Erstellt Container + Startet ihn. |
| `docker create` | Erstellt ihn nur (selten genutzt). |
| `docker start` | Startet einen *existierenden*, gestoppten Container. |
| `docker stop` | Sendet SIGTERM (freundlich), dann SIGKILL. |
| `docker rm` | Löscht einen gestoppten Container. |
| `docker ps` | Zeigt *laufende* Container. |
| `docker ps -a` | Zeigt *alle* Container (auch gestoppte). |

### Background Mode (Detached)

Webserver willst du nicht im Vordergrund haben. Nutze `-d`:

```bash
docker run -d --name nginx -p 8080:80 nginx:alpine
```

- `-d`: Detached (Hintergrund).
- `--name`: Gibt ihm einen lesbaren Namen (sonst random name).
- `-p 8080:80`: Mappt Port 8080 auf meinem Laptop auf Port 80 im Container.

Check it: [http://localhost:8080](http://localhost:8080)

## Was passiert im Container?

Wie kommen wir "rein"?

```bash
# Befehl im laufenden Container ausführen
docker exec -it nginx sh
```

- `-i`: Interactive (STDIN offen halten).
- `-t`: TTY (Pseudo-Terminal simulieren).

Jetzt bist du *im* Container. Schau dich um: `ls /`, `whoami`.
Mit `exit` kommst du wieder raus. Der Container läuft weiter!

## Logs & Debugging

Wenn was nicht geht:

```bash
docker logs mein-nginx
docker logs -f mein-nginx  # Follow stream (wie tail -f)
```

:::tip[Pro-Tipp]
Nutze `docker stats`, um CPU und RAM Verbrauch aller Container live zu sehen.
:::

## Aufräumen

Docker ist wie eine Party: Wenn man nicht aufräumt, klebt irgendwann der Boden.

```bash
# Alles stoppen und löschen, was wir gerade gemacht haben
docker rm -f nginx
```

:::warning[Nuke it all]
Für den "großen Hausputz" (Vorsicht!): `docker system prune -a`. Das löscht alles, was nicht läuft oder benutzt wird.
:::
