---
title: "01 The LAMP Stack (WordPress)"
---

## Szenario

Dein Marketing-Team braucht einen Blog. Sofort.
Wir nutzen **WordPress**.
WordPress braucht eine Datenbank (**MySQL** oder **MariaDB**).

Dies ist der Klassiker aller Docker Compose Beispiele.

## Aufgabe

1. **Erstelle eine `docker-compose.yml`:**
2. **Service `db`:**
    - Image: `mysql:8.0` (oder `mariadb:latest`).
    - **Wichtig:** Setze ein Volume für `/var/lib/mysql`, sonst sind alle Blog-Posts nach einem Neustart weg!
    - Setze die Environment Variables (Root Password, User, DB Name).
3. **Service `wordpress`:**
    - Image: `wordpress:latest`.
    - Muss auf Port `8080` erreichbar sein.
    - Muss die Datenbank-Credentials kennen (Environment Variables).
4. **Verbindung:**
    - Die Services finden sich automatisch über den Service-Namen (DNS).
    - WordPress muss wissen, dass der DB-Host `db` heißt.

## Tipps
- Schau auf Docker Hub nach den ENV Variablen für `wordpress` und `mysql`.
- Nutze `docker compose up -d` zum Starten.
- Nutze `docker compose logs -f` wenn etwas nicht klappt.

## Bonus
Schalte **Traefik** davor (wenn du das schon kennst), oder versuche ein Admin-Tool wie **phpMyAdmin** als dritten Service hinzuzufügen.
