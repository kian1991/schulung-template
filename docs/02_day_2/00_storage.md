---
title: "01 Storage & Persistence"
---

## Bind Mounts vs. Volumes

Es gibt zwei Hauptwege, Daten zu speichern:

### 1. Bind Mounts
Du mappst einen echten Pfad auf deinem Host in den Container.

```bash
docker run -v /Users/kian/my-project/src:/app/src node:alpine
```

- **Use Case:** Development. Ich ändere Code in VS Code auf dem Host, und er ist sofort im Container sichtbar (Live Reload).
- **Nachteil:** Abhängig vom Host-OS Pfad. Nicht portabel.

### 2. Volumes
Vollständig von Docker verwaltet. Speichern irgendwo tief in `/var/lib/docker/volumes` (auf Linux).

```bash
docker volume create my-db-data

docker run -d --name db -v my-db-data:/var/lib/mysql mysql:latest
```

- **Use Case:** Datenbanken, persistente App-Daten in Produktion.
- **Vorteil:** Portabel, sicherer, von Docker gemanaged.

### Syntax-Vergleich

Expliziter Style (`--mount` - empfehlenswert):
```bash
--mount type=bind,source=/Users/kian/code,target=/app
```

volume Style (`-v`):
- `-v /host/path:/container/path` (Bind Mount)
- `-v volume-name:/container/path` (Volume)

Zum Anfang reicht `-v` völlig aus.

## Wann nehme ich was?

| Szenario | Wahl | Warum? |
| :--- | :--- | :--- |
| **Datenbank Storage** | **Volume** | Performance (je nach OS), Trennung vom Host-FS |
| **Code Development** | **Bind Mount** | Ich will Code auf dem Host editieren und live sehen. |
| **Config File injizieren** | **Bind Mount** | Einzelne `nginx.conf` in den Container mappen. |
| **Tmp Files** | **Tmpfs** | Nur im RAM, schneller Zugriff, keine Persistenz nötig (z.B. Secrets). |

:::tip[Volume Pruning]
Vorsicht: `docker rm my-db` löscht NICHT das Volume. Das Volume bleibt verwaist zurück. Um aufzuräumen: [`docker volume prune`](https://docs.docker.com/reference/cli/docker/volume/prune/).
:::
