---
title: "Übungen: Funktionen & JSON"
---

# Übungen: Funktionen, Window Functions & JSON

## Aufgabe 1: Window Functions (Ranking)
**Ziel:** Erstelle eine Rangliste der bestbezahlten Mitarbeiter **pro Abteilung**.
*   **Tabelle:** `salaries`, `dept_emp`
*   **Funktion:** `RANK()` oder `DENSE_RANK()`
*   **Partitionierung:** Nach `dept_no`
*   **Sortierung:** Nach `salary DESC`
*   **Ausgabe:** `dept_no`, `emp_no`, `salary`, `rank`

## Aufgabe 2: Window Functions (Lag)
**Ziel:** Analysiere die Gehaltsentwicklung von Mitarbeiter 10001.
*   Zeige für jeden Gehaltseintrag an, wie hoch das **vorherige** Gehalt war und wie groß die Differenz ist.
*   **Funktion:** `LAG(salary) OVER (ORDER BY from_date)`

## Aufgabe 3: JSON Basics
Wir haben keine JSON-Tabelle in `employees`, also erstellen wir eine temporäre zum Üben.

```sql
CREATE TEMPORARY TABLE user_configs (
    id INT PRIMARY KEY,
    config JSON
);

INSERT INTO user_configs VALUES 
(1, '{"theme": "dark", "notifications": {"email": true, "sms": false}}'),
(2, '{"theme": "light", "notifications": {"email": false, "sms": true}}');
```

1.  Finde alle User, die das "dark" Theme nutzen.
2.  Finde alle User, die SMS-Benachrichtigungen aktiviert haben.
3.  Ändere bei User 1 das Theme auf "light" (nutze `JSON_SET` oder `JSON_REPLACE`).

## Aufgabe 4: Eigene Funktion (Stored Function)
**Ziel:** Schreibe eine Funktion `get_years_employed(p_emp_no INT)`.
*   Sie soll zurückgeben, wie viele Jahre ein Mitarbeiter schon in der Firma ist.
*   **Logik:** Differenz zwischen `hire_date` und `NOW()` (oder `to_date` bei Ehemaligen).
*   **Tipp:** `TIMESTAMPDIFF(YEAR, start, end)` ist hilfreich.

## Bonusübungen

1.  **JSON_TABLE:** Nutze `JSON_TABLE`, um das JSON aus Aufgabe 3 temporär in eine relationale Struktur (Spalten: `theme`, `email_notif`) zu verwandeln und abzufragen.
2.  **NTILE:** Teile alle Mitarbeiter basierend auf ihrem aktuellen Gehalt in 4 Gruppen (Quartile) ein. Wer gehört zu den Top 25%?
3.  **Datums-Rechnung:** Berechne das genaue Alter aller Mitarbeiter in Tagen (`DATEDIFF`).
4.  **JSON_MERGE:** Füge zwei JSON-Objekte zusammen (z.B. Default-Config und User-Config). Nutze `JSON_MERGE_PATCH` (oder `PRESERVE`).
5.  **JSON Validation:** Nutze `JSON_VALID`, um zu prüfen, ob ein String valides JSON enthält.
6.  **JSON Search:** Finde den Pfad zu einem bestimmten Wert in einem JSON-Dokument mit `JSON_SEARCH`.
7.  **Regular Expressions:** Finde alle Mitarbeiter, deren Nachname mit einem Vokal beginnt und mit einem Vokal endet (`REGEXP`).
8.  **Coalesce:** Nutze `COALESCE`, um NULL-Werte in einer Abfrage durch einen Standardwert (z.B. "N/A") zu ersetzen.
9.  **Cast & Convert:** Konvertiere einen String "123.45" explizit in eine DECIMAL-Zahl und rechne damit.
10. **Random Samples:** Wähle zufällig 5 Mitarbeiter aus (`ORDER BY RAND() LIMIT 5`). Diskutiere die Performance bei großen Tabellen.
