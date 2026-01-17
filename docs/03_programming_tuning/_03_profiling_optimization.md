---
title: "Profiling & Optimization"
---

# Profiling & Query Optimization

Warum ist mein Query langsam? Raten ist keine Strategie. Messen schon.

## EXPLAIN your Query

Das wichtigste Tool des DBAs.

```sql
EXPLAIN SELECT * FROM employees WHERE hire_date > '2000-01-01';
```

### Die wichtigsten Spalten

*   **type:**
    *   `ALL`: Full Table Scan (Böse!).
    *   `index`: Full Index Scan (Besser, aber immer noch Scan).
    *   `range`: Index Range Scan (Gut! Z.B. `> 'date'`).
    *   `ref` / `eq_ref`: Exakter Lookup (Sehr gut).
    *   `const`: Primary Key Lookup (Perfekt).
*   **key:** Welcher Index wird *wirklich* genutzt.
*   **rows:** Geschätzte Anzahl der Zeilen, die geprüft werden müssen.
*   **Extra:**
    *   `Using filesort`: Schlecht (Sortierung im Memory/Disk).
    *   `Using temporary`: Schlecht (Temp Table nötig).
    *   `Using index`: Perfekt ("Covering Index", Daten kommen nur aus RAM-Index).

## EXPLAIN ANALYZE

`EXPLAIN` schätzt nur. `EXPLAIN ANALYZE` führt das Query aus und misst echte Zeiten.

```sql
EXPLAIN ANALYZE SELECT ...
```
Output ist ein Baum mit Timing-Infos pro Schritt. Extrem mächtig.

## Schema Tuning

Oft liegt das Problem nicht am Query, sondern am Design.

1.  **Datentypen:** Brauchst du `BIGINT` (8 Byte) für einen Status (0 oder 1)? Nutze `TINYINT` (1 Byte).
    *   *Effekt:* Kleinerer Index -> Mehr passt in den RAM -> Weniger Disk I/O.
2.  **Indizes:**
    *   Multi-Column Indexe (`idx_name_dob (last_name, dob)`).
    *   "Leftmost Prefix Rule" beachten: Der Index oben hilft bei `last_name = 'X'`, aber NICHT bei `dob = 'Y'`.

## Performance Schema nutzen

Wenn `EXPLAIN` nicht reicht:
```sql
UPDATE performance_schema.setup_instruments SET ENABLED = 'YES', TIMED = 'YES';
-- ... Queries laufen lassen ...
SELECT * FROM performance_schema.events_statements_history_long;
```
Das ist "Low Level" Profiling. Für eine schönere Ansicht nutzen wir **PMM (nächstes Kapitel)**.
