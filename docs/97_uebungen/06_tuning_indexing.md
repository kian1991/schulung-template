---
title: "Übungen: Tuning & Indexing"
---

# Übungen: Tuning, Indexing & Profiling

## Aufgabe 1: The Slow Query
Führe folgende Query aus (ohne Index):
```sql
SELECT * FROM salaries WHERE salary = 60117;
```
1.  Miss die Zeit.
2.  Nutze `EXPLAIN`. Welchen `type` siehst du? (`ALL`?)
3.  Erstelle einen Index auf `salary`.
4.  Miss die Zeit erneut.
5.  Nutze `EXPLAIN` erneut. Welchen `type` siehst du jetzt? (`ref`?)

## Aufgabe 2: Composite Index
Wir suchen oft nach Mitarbeitern anhand von Vor- und Nachname.

```sql
SELECT * FROM employees WHERE last_name = 'Facello' AND first_name = 'Georgi';
```

1.  Erstelle einen Index `idx_name` auf `(last_name, first_name)`.
2.  Prüfe mit `EXPLAIN`, ob er genutzt wird.
3.  Prüfe folgende Query: `SELECT * FROM employees WHERE first_name = 'Georgi';`. Wird der Index genutzt? Warum (nicht)?

## Aufgabe 3: Sorting Optimization
```sql
SELECT * FROM employees ORDER BY hire_date LIMIT 10;
```
1.  Prüfe `EXPLAIN`. Siehst du `Using filesort`?
2.  Wie bekommst du das `filesort` weg? (Tipp: Index auf `hire_date`).

## Aufgabe 4: App-Side Profiling (Bun)
Schreibe ein kleines Bun-Skript.
1.  Führe eine Query aus, die 100.000 Zeilen lädt (z.B. `SELECT * FROM salaries LIMIT 100000`).
2.  Miss die Zeit für die Query (`await db...`).
3.  Miss die Zeit für das Verarbeiten (z.B. durchloopen und summieren).
4.  Was dauert länger? Transfer oder Verarbeitung?

## Bonusübungen

1.  **Invisible Index:** Mache einen deiner Indizes "unsichtbar" (`ALTER TABLE ... ALTER INDEX ... INVISIBLE`). Prüfe mit `EXPLAIN`, ob er nun ignoriert wird.
2.  **Prefix Index:** Die Spalte `last_name` ist VARCHAR. Erstelle einen Index, der nur die ersten 3 Zeichen indiziert. Prüfe die Größe des Index im Vergleich zum vollen Index (Theorie).
3.  **Force Index:** Zwinge MySQL bei einer Query mittels `FORCE INDEX (index_name)`, einen bestimmten Index zu nutzen, auch wenn der Optimizer einen anderen (oder Full Table Scan) bevorzugen würde. Vergleiche die Performance.
4.  **Covering Index:** Erstelle eine Query, die *nur* Spalten abfragt, die im Index enthalten sind. Prüfe im EXPLAIN, ob `Using index` (nicht `Using index condition`!) steht. Das ist extrem schnell.
5.  **Index Merge:** Schreibe eine Query mit `WHERE a=1 OR b=2`. Wenn beide Spalten indiziert sind, kann MySQL einen "Index Merge" machen. Prüfe das EXPLAIN.
6.  **Analyze Table:** Führe `ANALYZE TABLE employees` aus. Das aktualisiert die Statistiken für den Optimizer. Wann sollte man das tun?
7.  **Optimizer Hints:** Nutze einen Optimizer Hint (z.B. `/*+ MAX_EXECUTION_TIME(1000) */`), um eine Query abzubrechen, wenn sie zu lange dauert.
8.  **Duplicate Index:** Suche (manuell oder per Tool) nach redundanten Indizes in der Datenbank (z.B. Index A auf `(col1)` und Index B auf `(col1, col2)`). Index A ist redundant.
9.  **Cardinality:** Prüfe die Kardinalität (Anzahl eindeutiger Werte) deiner Indizes mit `SHOW INDEX FROM table`. Warum ist eine hohe Kardinalität gut für Indizes?
10. **Performance Schema:** (Fortgeschritten) Aktiviere einen Consumer im Performance Schema und versuche, Details zu deiner letzten Query dort zu finden.
