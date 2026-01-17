---
title: "MySQL vs MariaDB"
---

# Inkompatibilitäten & Feature-Unterschiede

Hier ist eine strukturierte und sachliche Zusammenfassung der Unterschiede und Inkompatibilitäten zwischen MariaDB Rolling und MySQL 8.0 (basierend auf der offiziellen MariaDB-Dokumentation).

[Quelle](https://mariadb.com/docs/release-notes/community-server/about/compatibility-and-differences/mariadb-vs-mysql-features)

## 1. Grundsätzliche Positionierung

MariaDB versucht weiterhin hohe Kompatibilität zu MySQL zu halten, trotzdem existieren wichtige Unterschiede auf Funktionsebene und im Verhalten der Systeme.

## 2. Zusätzliche Storage Engines (nur in MariaDB)

MariaDB Rolling bietet zusätzliche Storage Engines, die MySQL nicht unterstützt:
*   **ColumnStore:** Für verteilte Datenverarbeitung und Analytics.
*   **MyRocks:** Eine Engine mit hoher Kompression, optimiert für Flash-Storage.
*   **S3 Storage Engine:** Ermöglicht das Archivieren von Tabellen in z. B. Amazon S3.
*   **Weitere:** CONNECT, SEQUENCE, Spider, FederatedX, OQGRAPH, SphinxSE u. a.

## 3. Erweiterte MariaDB-Funktionen (fehlen in MySQL)

MariaDB enthält mehrere Erweiterungen, die in MySQL fehlen:
*   **Relationale Vektorfunktionen**
*   **Galera-Cluster-Integration:** Synchroner Multi-Master Cluster.
*   **Zeitbasierte Tabellen:** System-Versioned, Application-Time Period und Bitemporal Tables ("Zeitreisen" in SQL).
*   **Flashback-DML-Rollback:** Rückgängigmachen von Änderungen ohne Backup-Restore.
*   **Oracle-Kompatibilitätsmodi:** Erleichtert die Migration von Oracle DBs (PL/SQL Support).
*   **Sequences:** Echte Sequenz-Objekte (`CREATE SEQUENCE`).
*   **RETURNING-Klauseln:** `INSERT ... RETURNING id`.
*   **Dynamische Spalten:** NoSQL-artiges Schema.
*   **Oracle-ähnliche Features:** z. B. `EXECUTE IMMEDIATE`.
*   **Erweiterte JSON-Funktionen**
*   **Mehr Kollationen und Zeichenunterstützung**
*   **Fortschritte beim Optimizer**
*   **Zusätzliche Daten- und Index-Typen:** wie `UUID`, `INET4/6`.
*   **Progress-Reporting:** für Operationen wie `ALTER TABLE`.
*   **Mehr Kommandos:** z. B. erweiterte `FLUSH`-Funktionen.

## 4. Wichtige funktionale Inkompatibilitäten

### JSON-Handling
*   **Speicherung:** MariaDB speichert JSON intern als Text (`LONGTEXT`), nicht als binäres JSON wie MySQL.
*   **Operatoren:** Bestimmte JSON-Operatoren (`->`, `->>`) aus MySQL werden teils unterschiedlich oder gar nicht unterstützt (kontextabhängig).
*   **Vergleich:** Vergleichsverhalten von JSON unterscheidet sich.
*   **Validierung:** Bei falschen JSON-Eingaben gibt MariaDB oft eine Warnung und `NULL` zurück, MySQL strikt einen Fehler.

### Rollen und Berechtigungen
*   **Auth:** MariaDB unterstützt keine Authentifizierung via Rollen (Mapping von User auf Rolle beim Login), MySQL schon.
*   **Schema:** Unterschiedliche Darstellung von Rollen in `INFORMATION_SCHEMA`.
*   **Tabellen:** Zusätzliche Rollen-Tabellen in MySQL fehlen in MariaDB.

### Performance Schema
*   MySQL aktiviert `performance_schema` standardmäßig.
*   MariaDB hat diese in Docker deaktiviert (Bare Metal aktiv).

:::tip[Aktivieren]

per Config

```ini
[mysqld]
performance_schema = ON
```
:::

### Standardbinaries
*   MariaDB verwendet andere Binärdateinamen (`mariadbd` statt `mysqld`).

## 5. Technische Unterschiede im Verhalten

*   **Befehle:** MariaDB Rolling implementiert bestimmte Befehle (z. B. `FLUSH TABLES`) anders.
*   **Abbruch:** In MariaDB kann jede Query abgebrochen werden, in MySQL nur `SELECT`.
*   **Parameter:** Unterschiedlicher Umgang mit Optionen, z. B. kürzere vs vollständige Parametererkennung.

## 6. Authentifizierung und Replikation

*   **GTID:** Nicht kompatible GTID-Implementierungen zwischen MariaDB und MySQL. Replikation ist oft schwierig.
*   **Passwörter:** Nutzer mit dem MySQL-SHA256-Passwortalgorithmus (`caching_sha2_password`) funktionieren nicht in MariaDB Rolling.

## 7. Nicht unterstützte MySQL-Funktionen in MariaDB

*   Lateral Derived Tables
*   CIDR-Notation für Accounts
*   MySQL X Plugin (Document Store API)
*   `CREATE TABLESPACE` für InnoDB
*   `SELECT FOR SHARE` (MySQL Syntax) ist in MariaDB Rolling so nicht verfügbar (nutze `LOCK IN SHARE MODE`).
*   Ngram und MeCab Full-Text-Parser Plugins fehlen.

## 8. Unterschiede bei Systemvariablen und Metadaten

*   Unterschiede im `INFORMATION_SCHEMA`.
*   Unterschiede bei unterstützten Zeichensätzen und Kollationen.
*   Einige Syntax-Unterschiede bei DDL-Operationen (z. B. `SHOW CREATE TABLE`).

## 9. Praktische Auswirkungen

### Migration und Kompatibilität
Wo MariaDB als Drop-in-Ersatz fungieren kann, bleibt bestehen, aber bei neueren MySQL-Funktionen oder speziellen Feature-Sets kann es zu Inkompatibilitäten kommen (z. B. JSON, Rollen, Replikation).

### Einsatzszenarien
*   **MariaDB** eignet sich dort, wo erweiterte Engines und Funktionen benötigt werden.
*   **MySQL** wird typischerweise dort bevorzugt, wo Oracle-Enterprise-Features oder bestimmte Standard-Funktionen kritisch sind.

---

## Zusammengefasst

MariaDB Rolling und MySQL 8.0 sind eng verwandt, aber nicht identisch. MariaDB hat zusätzliche Storage Engines und Funktionen, während MySQL einige Standardfeatures und Enterprise-Tools bietet, die MariaDB nicht oder anders implementiert. Insbesondere bei JSON-Handling, Rollenmanagement, Authentifizierung, Replikationsmodellen und bestimmten SQL-Funktionen bestehen klare Unterschiede, die bei Migrationen und im Betrieb berücksichtigt werden müssen.
