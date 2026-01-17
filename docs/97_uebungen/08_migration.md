---
title: "Übung 08: Der Umzug (MySQL -> MariaDB)"
---

# Der Umzug: Migration zu MariaDB

In dieser Übung simulieren wir den Umzug einer produktiven Datenbank von MySQL zu MariaDB. Da beide Systeme das gleiche Protokoll sprechen, ist der logische Export/Import (Dump) oft der sicherste Weg für kleinere bis mittlere Datenbanken.

## Szenario

Wir haben eine laufende MySQL-Instanz (mit der `employees` Datenbank) und wollen diese in eine frische MariaDB-Instanz umziehen.
Zusätzlich existiert eine `app_db`, die wir ebenfalls betrachten könnten, aber wir fokussieren uns erst auf `employees`.

---

## Aufgabe 1: Der "perfekte" Export

Nutze `mysqldump` (oder `mariadb-dump`), um die Datenbank `employees` zu exportieren.
Ein einfacher Dump (`mysqldump employees > dump.sql`) reicht in Produktion **nicht** aus! Warum?

1.  Er blockiert Tabellen (bei MyISAM).
2.  Er garantiert keinen consistent snapshot (bei InnoDB, wenn sich Daten während des Dumps ändern).
3.  Er vergisst vielleicht Stored Procedures oder Events.
4.  Er hat Probleme mit Binary Blobs, wenn das Encoding nicht stimmt.

### ToDo
Erstelle einen Befehl, der all diese Probleme löst.

<details>
<summary>Lösung anzeigen</summary>

```bash
mysqldump -u root -p \
 --single-transaction \
 --routines --triggers --events \
 --hex-blob \
 --default-character-set=utf8mb4 \
 --quick \
 employees > employees_migration.sql
```

**Erklärung der Flags:**
*   `--single-transaction`: **Der wichtigste Flag für InnoDB!** Startet eine Transaktion, liest den Snapshot konsistent, ohne Tabellen zu sperren. (Ohne das werden bei MyISAM Tabellen gelockt!).
*   `--routines --triggers --events`: Standardmäßig werden Stored Procs & Events oft nicht exportiert. Wir brauchen sie aber!
*   `--hex-blob`: Exportiert Binärdaten (`BINARY`, `BLOB`) als Hex-Strings (z.B. `0xA1B2...`). Verhindert Encoding-Salat.
*   `--quick`:  Liest Row-by-Row statt die ganze Tabelle in den RAM zu laden. Wichtig bei großen Tabellen.
*   `--default-character-set=utf8mb4`: Erzwingt, dass der Output UTF8mb4 ist (kein Latin1-Fallback).

</details>

---

## Aufgabe 2: Der Import

Nun spielen wir die Daten in die neue Instanz ein.

### ToDo
Importiere `employees_migration.sql` in die neue Datenbank. Was muss vorher existieren?

<details>
<summary>Lösung anzeigen</summary>

Die Datenbank muss leer existieren (falls sie nicht im Dump mit `CREATE DATABASE` steht):

```bash
# 1. DB anlegen
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS employees CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. Importieren
mysql -u root -p employees < employees_migration.sql
```

**Best Practices beim Import:**
*   **Netzwerk:** Pipe nutzen (`mysqldump ... | mysql ...`), um Disk-IO zu sparen, wenn beide Server erreichbar sind.
*   **Fehler:** Bei riesigen Dumps `mysql --force` nutzen? Nein! Besser: Skript stopt bei Fehler sofort.
*   **Performance:** Für riesige Imports: `ALTER TABLE ... DISABLE KEYS` (nur MyISAM) oder `autocommit=0` und `unique_checks=0` im Dump-Header (macht `mysqldump` meist automatisch).

</details>

---

## Aufgabe 3: Best Practices & Diskussion

Diskutiert folgende Fragen:

1.  **Warum kopieren wir nicht einfach den Daten-Ordner (`/var/lib/mysql`)?**
    *   *Antwort:* Funktioniert nur, wenn Versionen identisch sind. MySQL 8.0 File-Format ist **nicht** kompatibel mit MariaDB (andere System-Tabellen, Log-Formate).

2.  **Was, wenn die DB 500 GB groß ist?**
    *   *Antwort:* `mysqldump` ist Single-Threaded -> zu langsam.
    *   Alternative: **MySQL Shell Dump** (Parallel!) oder **MyDumper** (Parallel).
    *   Oder: Replikation aufsetzen und dann umschwenken (Minimal Downtime).

3.  **MariaDB vs MySQL Kompatibilität:**
    *   Achte auf JSON! MySQL speichert JSON binär, MariaDB als Text (Check Constraint). Ein Dump von MySQL 8 mit JSON könnte in MariaDB Warnungen werfen oder Syntax-Fehler bei generierten Columns haben.
