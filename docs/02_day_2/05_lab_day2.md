---
title: "05 Lab: Day 2 Challenge"
---

## Szenario: Der Blog

Dein Marketing-Team braucht einen Blog. Sofort.
Wir nutzen **WordPress**.
WordPress braucht eine Datenbank (**MySQL** oder **MariaDB**).

**Anforderungen:**
1. Erstelle eine `docker-compose.yml`.
2. Service `db`:
    - Image: `mysql:5.7` (oder 8.0/latest, pass auf Authentication Plugins auf).
    - Muss ein Volume haben, damit der Blog nicht gelöscht wird, wenn wir updaten.
3. Service `wordpress`:
    - Image: `wordpress:latest`.
    - Muss auf Port 8080 erreichbar sein.
    - Muss mit der Datenbank verbunden sein (Environment Variables!).
4. Der Stack muss mit `docker compose up -d` starten.

## Environment Variables Cheatsheet

Damit WordPress die DB findet, checke die Doku auf Docker Hub. Du brauchst meistens:
- **MySQL:** `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
- **WordPress:** `WORDPRESS_DB_HOST`, `WORDPRESS_DB_USER`, `WORDPRESS_DB_PASSWORD`, `WORDPRESS_DB_NAME`

:::tip[Hostnames]
Erinnere dich: In Compose ist der Hostname der Service-Name!
`WORDPRESS_DB_HOST` ist also einfach `db` (wenn dein Service `db` heißt).
:::

## Die Lösung

Versuche es erst selbst!

<details>
<summary>Auflösung zeigen</summary>

```yaml
version: '3.8'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    restart: always

  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    ports:
      - "8080:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress

volumes:
  db_data:
```

Starte es: `docker compose up -d`
Öffne: [http://localhost:8080](http://localhost:8080)

</details>

## Bonus: Traefik

Wenn du zu schnell warst:
Schalte **Traefik** davor, sodass der Blog unter `http://blog.localhost` erreichbar ist (ohne Port 8080).
Dafür musst du Labels am WordPress Container definieren.
