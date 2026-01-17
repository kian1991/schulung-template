---
title: "Übungen: Stored Programs"
---

# Übungen: Stored Procedures, Triggers & Events

## Aufgabe 1: Die "Hire" Prozedur
**Ziel:** Vereinfache das Einstellen neuer Mitarbeiter.
*   Erstelle eine Procedure `hire_employee`.
*   **Parameter:** `first_name`, `last_name`, `gender`, `birth_date`, `dept_name`, `title`, `salary`.
*   **Logik:**
    1.  Neue `emp_no` generieren (MAX + 1).
    2.  Insert in `employees`.
    3.  Insert in `dept_emp` (mit `dept_no` lookup).
    4.  Insert in `titles`.
    5.  Insert in `salaries`.
    6.  Alles in einer Transaktion!

## Aufgabe 2: Salary Protection Trigger
**Ziel:** Verhindere, dass das Gehalt gesenkt wird.
*   Erstelle einen `BEFORE UPDATE` Trigger auf `salaries`.
*   Wenn `NEW.salary < OLD.salary`, wirf einen Fehler (`SIGNAL SQLSTATE '45000'`).

## Aufgabe 3: Audit Event
**Ziel:** Lösche alte Audit-Logs automatisch.
*   Nimm an, wir haben eine Tabelle `audit_log` mit `created_at`.
*   Erstelle ein Event, das jede Nacht läuft und Einträge löscht, die älter als 1 Jahr sind.

## Aufgabe 4: Cursor Loop
**Ziel:** Berechne einen Bonus für alle Mitarbeiter.
*   Erstelle eine Prozedur `calculate_bonuses`.
*   Nutze einen Cursor, um über alle Mitarbeiter zu iterieren.
*   Wenn der Mitarbeiter länger als 10 Jahre dabei ist -> Bonus in eine separate Tabelle `bonuses` schreiben.

## Bonusübungen

1.  **OUT Parameter:** Schreibe eine Prozedur `get_dept_stats`, die für eine gegebene `dept_no` drei Werte zurückgibt (OUT Parameter): Min-Gehalt, Max-Gehalt und Durchschnittsgehalt.
2.  **Security Context:** Erstelle eine Prozedur, die auf eine Tabelle zugreift, auf die der normale User keinen Zugriff hat. Nutze `SQL SECURITY DEFINER`, damit der User die Prozedur trotzdem erfolgreich ausführen kann.
3.  **Show Create:** Nutze `SHOW CREATE PROCEDURE hire_employee` (oder den Namen deiner Prozedur), um dir den Quellcode und die Einstellungen der Prozedur anzeigen zu lassen.
4.  **Error Handling (Resignal):** Fange eine Exception in einem Handler, logge sie in eine Tabelle und wirf sie dann erneut (`RESIGNAL`), damit der Aufrufer auch merkt, dass etwas schiefging.
5.  **Dynamic SQL (Prepared):** Schreibe eine Prozedur, die einen Tabellennamen als Parameter nimmt und die Anzahl der Zeilen in dieser Tabelle zurückgibt (Dynamisches SQL nötig!).
6.  **Deterministic:** Markiere eine Funktion als `DETERMINISTIC` (wenn sie es ist). Prüfe, ob das Auswirkungen auf die Performance hat (Query Cache, Optimizer).
7.  **Trigger Cascade:** Erstelle einen Trigger A, der eine Tabelle ändert, auf der Trigger B liegt. Prüfe, ob Trigger B feuert.
8.  **Event Scheduling:** Erstelle ein Event, das *einmalig* in 5 Minuten läuft und dann automatisch gelöscht wird (`ON COMPLETION NOT PRESERVE`).
9.  **Stored Procedure calling Stored Procedure:** Lagere Teil-Logik in eine Sub-Prozedur aus und rufe diese aus der Haupt-Prozedur auf.
10. **User Variables:** Nutze User-Variablen (`@my_var`), um Werte zwischen zwei Prozedur-Aufrufen innerhalb derselben Session zu teilen.
