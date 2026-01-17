---
title: Kursübersicht
sidebar_position: 0
slug: /
---

# MySQL/MariaDB für fortgeschrittene Entwickler

Willkommen zum Experten-Kurs! Wir lassen die Grundlagen hinter uns und tauchen tief in die Architektur, Performance-Optimierung und fortgeschrittene Entwicklung mit **aktuellen LTS Versionen** von MySQL und MariaDB ein.

Dieser Kurs ist speziell für Entwickler konzipiert, die performante, skalierbare und sichere Datenbank-Anwendungen bauen müssen.

## Zielgruppe & Voraussetzungen

Du solltest mit `SELECT`, `INSERT`, `UPDATE` und einfachen `JOIN`s bereits sicher umgehen können. Wir fokussieren uns auf:
*   **Migration:** Strategien für den Wechsel von MySQL zu MariaDB.
*   **Performance:** Query Tuning, Index-Strategien und Profiling (inkl. PMM).
*   **Programmierung:** Business-Logik direkt in der Datenbank (Stored Procedures, Triggers).
*   **Internals:** Transaktionen, Locks und Isolation Levels verstehen.

## Agenda

### Modul 1: Advanced SQL & Transaction Management
Wir starten mit dem Fundament für komplexe Anwendungen. Wie verhalten sich Daten unter Last und im Mehrbenutzerbetrieb?
*   **Verbindung & Tools:** CLI Profi-Tipps (`mysql`, `mysqladmin`).
*   **Complex Queries:** Deep Dive in `JOIN`-Typen, `UNION` Strategien und Subquery-Optimierung.
*   **ACID & Transaktionen:** Was passiert bei `ROLLBACK` und `COMMIT` wirklich?
*   **Locking:** Deadlocks verstehen und vermeiden (Row-Level Locking, Shared vs. Exclusive).

### Modul 2: Data Management & Migration
Daten sind das Gold deines Unternehmens. Wir lernen, sie effizient zu bewegen und zu transformieren.
*   **Import/Export:** Umgang mit großen Dumps (`mysqldump`, `mysqlimport`).
*   **Migration Strategy:** **Special Focus:** Wir migrieren einen Datensatz live von MySQL zu MariaDB und prüfen die Kompatibilität.
*   **Advanced Features:** Views, Materialized Views Workarounds, Virtual Columns.
*   **Special Types:** JSON, GIS (Geodaten) und Volltextsuche.

### Modul 3: Programming, Tuning & PMM
Der "Performance-Tag". Wir automatisieren Logik und finden jeden Flaschenhals.
*   **Stored Programs:** Variablen, Stored Procedures, Functions und Error Handling (`SIGNAL`).
*   **Automation:** Trigger und Events (der interne Cronjob).
*   **Dynamic SQL:** Dynamische Code-Generierung.
*   **Profiling & Tuning:** `EXPLAIN` verstehen, Schema-Optimierung.
*   **Monitoring:** **Special Focus:** Setup und Nutzung von **PMM (Percona Monitoring and Management)** zur Analyse von Slow Queries.

## Tech Stack & Setup

Wir nutzen eine moderne, containerisierte Umgebung.

*   **MySQL LTS** (Container)
*   **MariaDB LTS** (Container)
*   **PMM Server 2.x** (Container)
*   **Bun (TypeScript)** für Skripte und Client-Simulationen.

### Szenario: Employees Database (Extended)
Wir arbeiten mit einem erweiterten Datensatz der "Employees" Datenbank (`~300k` Datensätze), um echte Performance-Effekte messbar zu machen.
