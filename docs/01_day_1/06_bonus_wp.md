---
title: "06 Bonus: WordPress (The Hard Way)"
---

## Szenario

Du hast noch Zeit? Perfekt.
Wir bauen einen klassischen Stack aber ohne Docker Compose. Alles von Hand.
Das härtet dich ab.

## Ziel

- 1x MySQL Datenbank
- 1x WordPress
- Verbunden über ein eigenes Netzwerk.
- Erreichbar auf Port 8080.

## Schritte

### 1. Networking

Erstelle ein Netzwerk `blog-net`.

```bash
docker network create blog-net
```

### 2. Die Datenbank

Starte MySQL.
**Achtung:** MySQL beendet sich sofort, wenn du kein Root-Passwort setzt!

Schau auf [Docker Hub (MySQL)](https://hub.docker.com/_/mysql) nach den nötigen Variablen.

```bash
docker run -d \
  --name blog-db \
  --network blog-net \
  -e MYSQL_ROOT_PASSWORD=geheim \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wp_user \
  -e MYSQL_PASSWORD=wp_pass \
  mysql:latest
```

### 3. Das Frontend

Starte WordPress.
Es muss wissen, wo die Datenbank ist (`WORDPRESS_DB_HOST`).
Da sie im selben Netz sind, ist der Hostname gleich dem Containernamen: `blog-db`.

```bash
docker run -d \
  --name blog-wp \
  --network blog-net \
  -p 8080:80 \
  -e WORDPRESS_DB_HOST=blog-db \
  -e WORDPRESS_DB_USER=wp_user \
  -e WORDPRESS_DB_PASSWORD=wp_pass \
  -e WORDPRESS_DB_NAME=wordpress \
  wordpress:latest
```

### 4. Testen

Öffne [http://localhost:8080](http://localhost:8080).
Siehst du den Installer? Glückwunsch!

### 5. Troubleshooting (Expert Mode)

Falls es nicht geht:
1.  Haben beide das Netzwerk? [`docker network inspect`](https://docs.docker.com/reference/cli/docker/network/inspect/) blog-net.
2.  Was sagen die Logs? [`docker logs`](https://docs.docker.com/reference/cli/docker/container/logs/) blog-wp.
3.  DNS Check: Starte einen Troubleshooter ins Netz:
    `docker run -it --rm --network blog-net nicolaka/netshoot dig blog-db`
    Löst der Name zur IP auf?
