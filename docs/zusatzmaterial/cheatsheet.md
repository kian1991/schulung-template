---
title: "Docker Cheatsheet"
---

# Docker Cheatsheet

## Basics & Lifecycle

| Befehl | Beschreibung |
| :--- | :--- |
| `docker run -d --name <name> <image>` | Container im Hintergrund starten |
| `docker run -it --rm <image> sh` | Wegwerf-Container für Tests |
| `docker ps` | Laufende Container anzeigen |
| `docker ps -a` | Alle Container anzeigen |
| `docker stop <name>` | Container stoppen |
| `docker rm <name>` | Container löschen |
| `docker logs -f <name>` | Logs live verfolgen |
| `docker exec -it <name> sh` | Shell im Container öffnen |

## Images

| Befehl | Beschreibung |
| :--- | :--- |
| `docker build -t <name>:<tag> .` | Image bauen |
| `docker image ls` | Images listen |
| `docker image prune` | Ungenutzte Images löschen |
| `docker history <image>` | Layer inspizieren |

## Netzwerke

| Befehl | Beschreibung |
| :--- | :--- |
| `docker network create <net>` | Netzwerk erstellen |
| `docker network connect <net> <cnt>` | Container nachträglich verbinden |
| `docker network inspect <net>` | Wer ist im Netzwerk? |

## Volumes

| Befehl | Beschreibung |
| :--- | :--- |
| `docker volume create <vol>` | Volume erstellen |
| `docker volume ls` | Volumes listen |
| `docker volume prune` | Unbenutzte Volumes löschen (Vorsicht!) |

## Docker Compose

| Befehl | Beschreibung |
| :--- | :--- |
| `docker compose up -d` | Stack starten (Detached) |
| `docker compose down` | Stack stoppen & löschen |
| `docker compose down -v` | ... und Volumes löschen (Alles weg!) |
| `docker compose logs -f` | Logs aller Services |
| `docker compose ps` | Status des Stacks |

## Clean Up (Nuke it)

```bash
docker system prune -a --volumes
```
Löscht ALLES, was nicht niet- und nagelfest ist.
