---
title: "Lab 01: The Great Migration"
---

# Lab: MySQL to MariaDB

Wir simulieren den Ernstfall. Du hast eine laufende MySQL Instanz und sollst diese auf MariaDB migrieren.

## Szenario

Wir haben eine Datenbank `legacy_app` mit einer Tabelle `user_settings`, die extrem viel JSON nutzt.

## Deine Aufgabe

1.  Starte den MySQL Container und erstelle die Test-Daten (siehe Code unten).
2.  Erstelle einen **logischen Dump** (bedenke die JSON-Kompatibilität!).
3.  Starte einen frischen MariaDB Container.
4.  Importiere die Daten.
5.  Verifiziere: Sind die JSON-Daten lesbar?
6.  **Bonus:** Erstelle einen User `app_user` in MySQL und migriere ihn nach MariaDB (Tipp: `pt-show-grants` oder manuell `CREATE USER`).

## Setup Code (MySQL)

```sql
CREATE DATABASE legacy_app;
USE legacy_app;

CREATE TABLE user_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50),
    preferences JSON
);

INSERT INTO user_settings (username, preferences) VALUES 
('Alice', '{"theme": "dark", "notifications": true}'),
('Bob', '{"theme": "light", "lang": "de"}');

CREATE USER 'app_user'@'%' IDENTIFIED BY 'secret123';
GRANT SELECT ON legacy_app.* TO 'app_user'@'%';
```

## Tipps

*   Dran denken: MySQL speichert JSON binär, MariaDB als `LONGTEXT` mit Check-Constraint. `mysqldump` sollte das regeln, aber schau dir das Dump-File genau an (`less dump.sql`).
*   Starte MariaDB am besten auf einem anderen Port (z.B. 3307) oder stoppe MySQL vorher.

<details>
<summary>Lösungshinweise</summary>

1.  **Dump:** `mysqldump -u root -p --databases legacy_app > dump.sql`
2.  **Grants:** `pt-show-grants` oder `SHOW CREATE USER 'app_user'@'%'; SHOW GRANTS FOR ...` -> Kopieren -> In MariaDB ausführen.
3.  **Import:** `mysql -u root -p -h 127.0.0.1 -P 3307 < dump.sql`
4.  **Verify:** `SELECT * FROM user_settings WHERE JSON_EXTRACT(preferences, '$.theme') = 'dark';`
</details>
