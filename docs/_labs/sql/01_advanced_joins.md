---
title: "Lab 01: Reporting Hell"
---

# Lab: Reporting Hell

Der Chef braucht Zahlen. Und zwar sofort.

## Szenario / Daten (Employees DB)

Nutze die Standard `employees` Datenbank.

## Deine Aufgabe

Erstelle einen Query, der folgendes liefert:
1.  Liste alle Abteilungen auf.
2.  Zähle, wie viele **aktuelle** Mitarbeiter (to_date = '9999-01-01') in jeder Abteilung sind.
3.  Berechne das **Durchschnittsgehalt** pro Abteilung.
4.  Sortiere nach Durchschnittsgehalt absteigend.
5.  **Challenge:** Filtere nur Abteilungen, die mehr als 10.000 Mitarbeiter haben.

## Tipps

*   Du brauchst `departments`, `dept_emp` und `salaries`.
*   Achte auf die `to_date` Spalte in `dept_emp` UND `salaries`! Wir wollen nur den *aktuellen* Stand.

<details>
<summary>Lösung</summary>

```sql
SELECT 
    d.dept_name,
    COUNT(de.emp_no) as num_employees,
    AVG(s.salary) as avg_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
WHERE de.to_date > NOW() 
  AND s.to_date > NOW()
GROUP BY d.dept_name
HAVING num_employees > 10000
ORDER BY avg_salary DESC;
```
</details>
