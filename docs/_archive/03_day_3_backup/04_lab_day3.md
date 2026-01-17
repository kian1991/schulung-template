---
title: "Lab: Tuning & Logic"
---


Zum Abschluss wird alles zusammengebracht: Logik in der DB und Performance-Optimierung.

## Aufgabe 1: Die Gehaltserhöhung (Stored Procedure)

Logik soll gekapselt werden. Schreibe eine Prozedur `raise_salary_by_dept`.

**Anforderungen:**
1.  Parameter: `dept_name` (String), `percentage` (Decimal).
2.  Logik:
    * Finde die `dept_no` zum Namen. Wenn nicht gefunden -> Fehler werfen!
    * Erhöhe das Gehalt aller **aktuellen** Mitarbeiter dieser Abteilung um X Prozent.
    * Gib zurück, wie viele Mitarbeiter betroffen waren.
3.  Teste es in phpMyAdmin mit `CALL raise_salary_by_dept('Sales', 10);`.

## Aufgabe 2: Der Audit Log (Trigger)

Vertrauen ist gut, Kontrolle ist besser. Es muss bekannt sein, wenn sich Gehälter ändern.

1.  Erstelle Tabelle `salary_audit` (`id`, `emp_no`, `old_salary`, `new_salary`, `changed_at`).
2.  Schreibe einen `AFTER UPDATE` Trigger auf die `salaries` Tabelle.
3.  Der Trigger soll **nur** feuern, wenn sich das Gehalt wirklich geändert hat (`OLD.salary != NEW.salary`).
4.  Teste es, indem du ein Gehalt manuell änderst und dann in `salary_audit` schaust.

## Aufgabe 3: The Slow Query Challenge

Es wird eine Query simuliert, die ein Entwickler "mal eben schnell" geschrieben hat, die aber die DB killt.

**Die Query:**
"Finde alle Gehälter, die (durch 12 geteilt) größer als 5000 sind."

```sql
SELECT * FROM salaries WHERE salary / 12 > 5000;
```

1.  Führe die Query aus und miss die Zeit.
2.  Führe `EXPLAIN` aus. Was siehst du bei `type`? (Tipp: `ALL` ist schlecht).
3.  **Warum** nutzt MySQL den Index auf `salary` nicht? (Tipp: Rechenoperation auf der Spalte).
4.  **Optimiere die Query!** Schreibe sie so um, dass MySQL den Index nutzen kann.
5.  Miss die Zeit erneut.

## Aufgabe 4: Integration mit Bun

Rufe deine Stored Procedure aus Aufgabe 1 via Bun auf.

```typescript
import { SQL } from "bun";

const db = new SQL("mysql://root:root@localhost:3306/app_db");

try {
    // Hinweis: Bun SQL unterstützt CALL Syntax
    const result = await db`CALL raise_salary_by_dept(${'Marketing'}, ${5.5})`;
    console.log("Erfolg:", result);
} catch (e) {
    console.error("Fehler:", e);
}
```
