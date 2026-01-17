---
title: "Lab 01: Audit Trigger"
---

# Lab: The Audit Trigger

Vertrauen ist gut, Kontrolle ist besser.

## Aufgabe

Erstelle eine Tabelle `salaries_history` (gleiche Struktur wie salaries + `deleted_at` Timestamp).
Schreibe einen **Trigger**, der jedes Mal, wenn ein Gehalt aus `salaries` **gelöscht** wird, eine Kopie in `salaries_history` anlegt.

## Test

1.  Lösche einen Eintrag aus `salaries`.
2.  Prüfe, ob er in `salaries_history` auftaucht.

<details>
<summary>Lösung</summary>

```sql
CREATE TABLE salaries_history LIKE salaries;
ALTER TABLE salaries_history ADD COLUMN deleted_at DATETIME;

DELIMITER //

CREATE TRIGGER before_salary_delete
BEFORE DELETE ON salaries
FOR EACH ROW
BEGIN
    INSERT INTO salaries_history (emp_no, salary, from_date, to_date, deleted_at)
    VALUES (OLD.emp_no, OLD.salary, OLD.from_date, OLD.to_date, NOW());
END //

DELIMITER ;
```
</details>
