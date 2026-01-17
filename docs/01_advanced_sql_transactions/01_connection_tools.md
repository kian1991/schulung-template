---
title: "Verbindung & Tools"
---

# Verbindung, Setup & CLI Tools

Vergiss GUIs für einen Moment. Echte Power-User und Skripte nutzen die CLI. Wir schauen uns die wichtigsten Tools an, die MySQL und MariaDB mitbringen.




## Verbindung zur Datenbank aufbauen

Der Klassiker `mysql` ist mächtiger als man denkt.

### Der Login

```bash
mysql -u root -p
```

:::tip[Secure Password]
Vermeide es, das Passwort direkt im Befehl mitzugeben (`-pSecret`). Es taucht sonst in der `history` auf. Nutze lieber Konfigurationsdateien oder den Prompt.
:::

### Wichtige Flags für Entwickler

*   `--safe-updates`: Verhindert `UPDATE` oder `DELETE` ohne `WHERE` Klausel oder Limit.
*   `--xml` / `--html`: Gibt Query-Ergebnisse direkt in Format X aus.
*   `-e "QUERY"`: Führt ein Query aus und beendet sich (perfekt für Shell-Skripte).

```bash
# Beispiel: Quick Check ohne Shell zu öffnen
mysql -u user -pDBNAME -e "SELECT count(*) FROM employees;"
```

## Die Tool-Suite

Neben dem Client gibt es Helfer für Administration und Daten.

### mysqladmin
Ein Admin-Tool für Server-Operationen.
*   Check, ob der Server lebt: `mysqladmin ping`
*   Prozessliste anzeigen: `mysqladmin processlist`
*   Status-Variablen: `mysqladmin extended-status`

### mysqlshow
Schneller Überblick über Datenbanken, Tabellen und Spalten.
```bash
mysqlshow -u root -p employees
```

### mysqldump & mysqlimport
(Dazu mehr in **Modul 2** beim Thema Migration & Backup).

## Konfigurationsdateien (`.my.cnf`)
Statt Passwörter zu tippen, legst du sie sicher in deinem Home-Verzeichnis ab.

```ini
# ~/.my.cnf
[client]
user=myuser
password=mypassword
host=localhost
```
_Rechte nicht vergessen: `chmod 600 ~/.my.cnf`!_


## 3. Setup der Umgebung

Wir wollen keine Zeit mit Installationen verschwenden. Deshalb nutzen wir **Docker**.

Hier sind alle benötigten Dateien: [assets.zip](../assets.zip)

### Schritt 1: Docker Container starten

Es ist ein `docker-compose.yml` vorbereitet, das zwei Dienste liefert:
1.  **MySQL 8.0:** Die Datenbank selbst.
2.  **phpMyAdmin:** Eine Web-Oberfläche zur Verwaltung.

Wechsle in das `assets` Verzeichnis und starte die Container:

```bash
docker-compose up -d
```

:::tip[Troubleshooting]
Falls der Port 3306 belegt ist (z.B. durch eine lokale MySQL Installation), stoppe deinen lokalen Server oder ändere den Port in der `docker-compose.yml` auf `3307:3306`.
:::

### Schritt 2: Verbindung testen

1.  **phpMyAdmin öffnen:**
    Gehe in deinem Browser auf [http://localhost:8080](http://localhost:8080).

2.  **Einloggen:**
    * **System:** MySQL
    * **Server:** `mysql` (Das ist der Service-Name im Docker-Netzwerk)
    * **Username:** `root`
    * **Password:** `root`
    * **Database:** `app_db`

3.  **Bun (TypeScript) testen:**
    Wir nutzen Bun als Laufzeitumgebung für unsere Skripte.
    
    ```bash
    # Dependencies installieren
    bun install

    # Test-Skript starten
    bun run index.ts
    ```
    
    Wenn du `Hello World` in der Konsole siehst, bist du bereit!

:::tip[Link zur Employees-Datenbank]
[Employees](https://github.com/datacharmer/test_db)
:::
