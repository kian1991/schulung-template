---
title: "Übungen: Views & Virtual Columns"
---

## Aufgabe 1: Die "Current Employees" View
Die Tabellen `dept_emp` und `salaries` enthalten Historien. Das nervt bei täglichen Abfragen.

**Ziel:** Erstelle eine View `v_current_employees`.
*   Sie soll **nur** aktuelle Daten enthalten (`to_date > NOW()`).
*   **Spalten:** `emp_no`, `first_name`, `last_name`, `current_salary`, `current_dept_name`.

```sql
SELECT * FROM v_current_employees WHERE last_name = 'Facello';
```

## Aufgabe 2: Virtual Column für Namen
Es wird oft nach dem vollen Namen gesucht oder dieser angezeigt.

**Ziel:**
1.  Füge der Tabelle `employees` eine Generated Column `full_name` hinzu.
2.  Definition: `CONCAT(first_name, ' ', last_name)`.
3.  Entscheide: `VIRTUAL` oder `STORED`? (Tipp: Wenn danach gesucht werden soll, ist STORED + Index besser).

## Aufgabe 3: Reporting View
**Ziel:** Erstelle eine View `v_dept_stats`, die pro Abteilung folgende Metriken liefert:
*   Anzahl der Mitarbeiter
*   Durchschnittsgehalt
*   Summe aller Gehälter

**Frage:** Ist diese View performant? Was passiert, wenn man `SELECT * FROM v_dept_stats` macht? (Antwort: MySQL berechnet die Aggregation jedes Mal neu -> Teuer!)

## Bonusübungen

1.  **WITH CHECK OPTION:** Erstelle eine View für Mitarbeiter der Abteilung 'Sales'. Füge die Option `WITH CHECK OPTION` hinzu. Versuche nun, über diese View einen Mitarbeiter in 'Marketing' einzufügen.
2.  **Updatable View:** Versuche, das Gehalt eines Mitarbeiters direkt über die View `v_current_employees` zu ändern. Funktioniert das? Warum (nicht)?
3.  **Index auf Virtual Column:** Erstelle einen Index auf die `full_name` Spalte aus Aufgabe 2 (falls sie STORED ist, oder direkt auf den Ausdruck bei MySQL 8+). Prüfe mit EXPLAIN, ob eine Suche nach dem vollen Namen nun den Index nutzt.
4.  **Security Definer View:** Erstelle eine View, die auf eine Tabelle zugreift, auf die der aktuelle User keinen Zugriff hat. Definiere die View mit `SQL SECURITY DEFINER`. Kann der User die View lesen?
5.  **View auf View:** Erstelle eine View `v_managers`, die auf `dept_manager` basiert. Erstelle dann eine View `v_current_managers`, die auf `v_managers` basiert und nur aktuelle filtert.
6.  **Algorithm Merge vs. Temptable:** Zwinge MySQL bei einer View-Erstellung, den Algorithmus `TEMPTABLE` zu nutzen (`CREATE ALGORITHM=TEMPTABLE VIEW ...`). Prüfe mit `EXPLAIN`, wie sich der Zugriff ändert.
7.  **Generated Column (Date):** Erstelle eine Generated Column `hire_year` in `employees`, die nur das Jahr des Einstellungsdatums enthält. Indiziere diese Spalte.
8.  **Check Option Cascaded:** Erstelle eine View mit `WITH CASCADED CHECK OPTION`, die auf einer anderen View basiert. Versuche, Daten einzufügen, die die Bedingung der Basis-View verletzen.
9.  **JSON in Virtual Column:** Extrahiere einen Wert aus einem JSON-Feld in eine Virtual Column und indiziere diese. (Nutze die Tabelle aus der JSON-Übung).
10. **Materialized View Workaround:** Da MySQL keine nativen Materialized Views hat: Erstelle eine Tabelle `mv_dept_stats` und fülle sie mit dem Ergebnis einer komplexen Aggregation. Schreibe ein Event, das diese Tabelle alle 5 Minuten aktualisiert.
