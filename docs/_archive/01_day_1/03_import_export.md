---
title: "Import & Export"
---

# Import & Export von Daten

Als Entwickler muss man oft Daten von A nach B bewegen. Sei es ein Dump von der Produktion für lokales Debugging oder das Einspielen von Testdaten.

## 1. Export mit mysqldump

Das Standard-Tool, das bei jeder MySQL-Installation dabei ist. Es erzeugt SQL-Statements (`CREATE TABLE`, `INSERT`), um die Datenbank wiederherzustellen.

### Die wichtigsten Befehle

```bash
# 1. Alles exportieren (Struktur + Daten)
docker exec mysql-dev mysqldump -u root -proot app_db > dump.sql

# 2. Nur die Struktur (Schema) exportieren
# Nützlich, um eine saubere Dev-DB aufzusetzen
docker exec mysql-dev mysqldump -u root -proot --no-data app_db > schema.sql

# 3. Nur die Daten exportieren
# Nützlich für Backups von Konfigurationstabellen
docker exec mysql-dev mysqldump -u root -proot --no-create-info app_db > data.sql
```

### Performance-Tipps für Dumps

:::tip[Große Datenbanken]
Wenn du Gigabytes an Daten exportierst, beachte diese Flags:

* `--single-transaction`: Zwingend für InnoDB! Erzeugt einen konsistenten Snapshot, ohne die Tabellen zu sperren. Die App kann weiterlaufen.
* `--quick`: Zwingt `mysqldump`, die Zeilen einzeln vom Server zu lesen, statt alles in den RAM zu laden. Verhindert Out-of-Memory Fehler.
* `--routines --triggers --events`: Vergiss nicht, auch deine Stored Procedures und Trigger zu sichern!
:::

---

## 2. Import

### Der Standard-Weg (CLI)
Am einfachsten pipest du die SQL-Datei in den Client.

```bash
cat dump.sql | docker exec -i mysql-dev mysql -u root -proot app_db
```

### High Speed Import: LOAD DATA INFILE

Wenn du **wirklich** viele Daten (Millionen Zeilen) importieren musst (z.B. aus einer CSV-Datei), sind `INSERT` Statements zu langsam.

`LOAD DATA INFILE` liest eine Textdatei direkt und schreibt sie binär in die Tabellen. Das ist 10-20x schneller.

```sql
LOAD DATA INFILE '/var/lib/mysql-files/data.csv'
INTO TABLE employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Header überspringen
```

:::warning[Voraussetzungen]
1. Die Datei muss auf dem Server liegen (oder via Volume gemountet sein).
2. Der User braucht das `FILE` Privileg.
3. Die Einstellung `secure_file_priv` muss den Pfad erlauben.
:::

---

## 3. Häufige Fallstricke

### Encoding (UTF-8)
Nichts ist nerviger als kaputte Umlaute (`Ã¼` statt `ü`).
Stelle sicher, dass beim Export und Import das gleiche Charset genutzt wird.
`--default-character-set=utf8mb4` ist dein Freund.

### Max Allowed Packet
Wenn du große BLOBs (Bilder, PDFs) oder riesige `INSERT`-Batches hast, kann der Server die Verbindung kappen.
Fehler: `Packet for query is too large`.
Lösung: Erhöhe `max_allowed_packet` in der `my.cnf`.

#### Mini-Übung
> Prüfe in phpMyAdmin, wie groß `max_allowed_packet` aktuell eingestellt ist.
> *Tipp: SQL-Befehl `SHOW VARIABLES LIKE ...`*
