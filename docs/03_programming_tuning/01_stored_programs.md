---
title: "Stored Routines, Triggers & Events"
---

Heute wird Logik vom Applikations-Code (TypeScript) direkt in die Datenbank verlagert. Das ist ein mächtiges Werkzeug, aber auch ein zweischneidiges Schwert.

## 1. Stored Routines: Code in der DB

### Pro & Contra

| Pro | Contra |
| :--- | :--- |
| **Performance:** Weniger Daten müssen über das Netzwerk. | **Debugging:** Schwer zu debuggen (kein `console.log`). |
| **Sicherheit:** User darf Prozedur ausführen, aber Tabellen nicht lesen. | **Version Control:** Code liegt in der DB, nicht im Git (außer man nutzt Migrations). |
| **Konsistenz:** Logik ist für alle Clients (Web, App, Admin) gleich. | **Vendor Lock-in:** Schwerer zu PostgreSQL o.ä. zu wechseln. |

### Stored Procedure
Eine Prozedur wird mit `CALL` aufgerufen. Sie kann Daten ändern und Ergebnisse zurückliefern.

```sql
DELIMITER // -- Das Semikolon muss als Trennzeichen temporär geändert werden

CREATE PROCEDURE give_raise(
    IN p_dept_no CHAR(4), 
    IN p_percent DECIMAL(5,2)
)
BEGIN
    -- Logik kapseln
    UPDATE salaries s
    JOIN dept_emp de ON s.emp_no = de.emp_no
    SET s.salary = s.salary * (1 + p_percent / 100)
    WHERE de.dept_no = p_dept_no 
      AND s.to_date > NOW(); -- Nur aktuelle!
      
    -- Feedback geben
    SELECT CONCAT('Updated salaries for department ', p_dept_no) as msg;
END //

DELIMITER ;
```

### Aufruf
```sql
CALL give_raise('d005', 10.00);
```

### Deep Dive: Parameter (IN, OUT, INOUT)

MySQL kennt drei Arten von Parametern. Das ist wichtig, um zu verstehen, wie Daten fließen.

#### 1. IN (Input)
*   **Bedeutung:** Wert geht *rein*.
*   **Verhalten:** Die Prozedur kann ihn lesen und intern ändern, aber die Änderung bleibt *in* der Prozedur.
*   **Default:** Wenn nichts angegeben ist, ist es `IN`.
*   **Use Case:** Filter, IDs, Rechenwerte.

In unserem Beispiel `give_raise` nutzen wir nur `IN`, weil wir Daten verarbeiten, aber nichts zurückgeben müssen (außer einer Message via SELECT).

#### 2. OUT (Output)
*   **Bedeutung:** Wert geht *raus*.
*   **Verhalten:** Der Caller übergibt eine Variable (ohne Wert), die Prozedur füllt sie.
*   **Use Case:** Berechnete Ergebnisse zurückgeben (statt SELECT).

**Beispiel:**
```sql
CREATE PROCEDURE count_employees(IN p_dept CHAR(4), OUT p_count INT)
BEGIN
    SELECT COUNT(*) INTO p_count FROM dept_emp WHERE dept_no = p_dept;
END;
```

**Aufruf:**
```sql
CALL count_employees('d005', @anzahl);
SELECT @anzahl;
```

#### 3. INOUT (Input & Output)
*   **Bedeutung:** Wert geht *rein*, wird geändert und geht *raus*.
*   **Use Case:** Zähler, Akkumulatoren, Modifikation eines Wertes.

**Beispiel:**
```sql
CREATE PROCEDURE adjust_score(INOUT p_score INT)
BEGIN
    SET p_score = p_score + 10;
END;
```

**Aufruf:**
```sql
SET @score = 50;
CALL adjust_score(@score);
SELECT @score; -- 60
```

### Zusammenfassung

| Typ | Richtung | Caller sieht Änderung? | Typischer Zweck |
| :--- | :--- | :--- | :--- |
| **IN** | Rein | Nein | Filter, IDs (Standard) |
| **OUT** | Raus | Ja | Ergebnisse zurückgeben |
| **INOUT** | Rein & Raus | Ja | Werte modifizieren |

---


### Stored Function
Eine Funktion wird **in** einem SQL-Statement genutzt (wie `UPPER()` oder `NOW()`). Sie **muss** einen Wert zurückgeben.

```sql
CREATE FUNCTION get_manager_name(p_dept_no CHAR(4)) 
RETURNS VARCHAR(100) 
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_name VARCHAR(100);
    
    SELECT CONCAT(e.first_name, ' ', e.last_name) INTO v_name
    FROM employees e
    JOIN dept_manager dm ON e.emp_no = dm.emp_no
    WHERE dm.dept_no = p_dept_no AND dm.to_date > NOW()
    LIMIT 1;
    
    RETURN v_name;
END;
```

### Warum diese Keywords?
MySQL zwingt dich bei Stored Functions dazu, zu deklarieren:

1.  **Wie vorhersehbar ist das Ergebnis?**
    *   `DETERMINISTIC`: Gleicher Input = Gleicher Output (z.B. `1+1`). MySQL kann das Ergebnis cachen.
    *   `NOT DETERMINISTIC`: Ergebnis ändert sich (z.B. `NOW()`, `RAND()`).

2.  **Wie greift die Funktion auf Daten zu?**
    *   `NO SQL`: Nutzt kein SQL.
    *   `READS SQL DATA`: Liest nur (`SELECT`).
    *   `MODIFIES SQL DATA`: Schreibt (`INSERT`, `UPDATE`).
    *   `CONTAINS SQL`: Nutzt SQL, liest/schreibt aber keine Daten.

### Nutzung
```sql
SELECT get_manager_name('d005');
```


### Control Flow

Logik braucht Kontrollstrukturen. MySQL bietet die Klassiker:

**Compound Statements:**
* `IF ... THEN ... ELSE ... END IF;`
* `CASE ... WHEN ... THEN ... END CASE;`
* `WHILE ... DO ... END WHILE;`


## 2. Triggers: Automatische Reaktionen

Trigger feuern automatisch bei `INSERT`, `UPDATE` oder `DELETE`.

**Use Cases:**
* **Audit Logging:** Wer hat was geändert?
* **Validierung:** Daten prüfen, bevor sie gespeichert werden.
* **Berechnung:** Virtual Columns aktualisieren (bei komplexer Logik).

```sql
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    -- Validierung: Niemand darf in der Zukunft eingestellt werden
    IF NEW.hire_date > NOW() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Hire date cannot be in the future!';
    END IF;
END;
```

### Use Case: Live Materialized View (Inkrementelles Update)
Statt `SUM()` jedes Mal neu zu berechnen, halten wir eine Statistik-Tabelle aktuell.

```sql
CREATE TRIGGER update_sales_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    -- Den User-Umsatz sofort erhöhen
    UPDATE user_stats 
    SET total_spent = total_spent + NEW.amount 
    WHERE user_id = NEW.user_id;
END;
```

:::warning[Vorsicht]
Trigger sind "unsichtbar". Ein Entwickler wundert sich vielleicht, warum sein INSERT fehlschlägt oder warum plötzlich Daten in einer anderen Tabelle auftauchen. Dokumentiere Trigger gut!
:::

---

## 3. Events: Der eingebaute Cronjob

MySQL hat einen eigenen Scheduler. Perfekt für Aufräumarbeiten.

```sql
-- Muss aktiviert sein!
SET GLOBAL event_scheduler = ON;

CREATE EVENT clean_logs
ON SCHEDULE EVERY 1 DAY
STARTS '2024-01-01 03:00:00'
DO
    DELETE FROM logs WHERE created_at < NOW() - INTERVAL 30 DAY;

-- Beispiel 2: Pseudo Materialized View (Teure Reports nachts bauen)
CREATE EVENT refresh_daily_report
ON SCHEDULE EVERY 1 DAY STARTS '2025-01-01 03:00:00'
DO
BEGIN
    TRUNCATE TABLE sales_report_mv;
    
    INSERT INTO sales_report_mv
    SELECT category_id, SUM(amount) 
    FROM orders 
    GROUP BY category_id;
END;
```
