---
title: "Stored Procedures & Fulltext"
---

# Stored Procedures & Fulltext Search

## 1. Fulltext Search

`LIKE '%wort%'` ist langsam (kein Index) und dumm (findet "Wörter" nicht bei "Wort").
Fulltext Search löst beides.

### Index erstellen
```sql
ALTER TABLE products ADD FULLTEXT(title, description);
```

### Suchen (Natural Language)
```sql
SELECT * FROM products 
WHERE MATCH(title, description) AGAINST('iPhone Case');
```
Dies sortiert automatisch nach Relevanz!

### Suchen (Boolean Mode)
Für Profis:
*   `+iPhone`: Muss vorkommen.
*   `-Case`: Darf nicht vorkommen.
*   `Apple*`: Wildcard am Ende.

```sql
SELECT * FROM products 
WHERE MATCH(title, description) AGAINST('+iPhone -Case' IN BOOLEAN MODE);
```

---

## 2. Stored Procedures

Warum Logik in die DB?
*   **Performance:** Weniger Roundtrips.
*   **Sicherheit:** Apps greifen nur auf Prozeduren zu, nicht auf Tabellen.
*   **Wartbarkeit:** DB-Logik zentral an einem Ort.

### Syntax & Konzepte

#### 1. Variablen
Variablen müssen am Anfang mit `DECLARE` deklariert werden.
```sql
DECLARE my_count INT DEFAULT 0;
SET my_count = 10;
```

#### 2. Parameter
*   `IN`: Daten gehen rein (Read-only).
*   `OUT`: Daten gehen raus (Return values).
*   `INOUT`: Beides.

```sql
CREATE PROCEDURE get_stats(IN p_id INT, OUT p_count INT)
BEGIN
    SELECT COUNT(*) INTO p_count FROM orders WHERE user_id = p_id;
END
```

#### 3. Control Flow (IF / WHILE)
Logik wie in jeder Programmiersprache.

```sql
IF my_count > 100 THEN
    UPDATE users SET is_vip = 1 WHERE id = p_id;
ELSE
    UPDATE users SET is_vip = 0 WHERE id = p_id;
END IF;
```

#### 4. Cursors (Looping)
Wenn du Zeile für Zeile verarbeiten musst (wie `foreach`).
Achtung: Langsam! Nur nutzen, wenn SQL nicht reicht.

```sql
DECLARE done INT DEFAULT FALSE;
DECLARE cur1 CURSOR FOR SELECT id FROM products;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur1;

read_loop: LOOP
    FETCH cur1 INTO p_id;
    IF done THEN
        LEAVE read_loop;
    END IF;
    -- Mach was mit p_id
END LOOP;

CLOSE cur1;
```

---

## 3. Triggers & Events

Während Stored Procedures manuell aufgerufen werden, laufen Triggers & Events automatisch.

### Triggers (Sofortige Reaktion)
Ein Trigger feuert bei Änderungen (`INSERT`, `UPDATE`, `DELETE`).
Man nutzt sie für Datenintegrität oder **Live-Materialized Views** (sofortiges Update).

```sql
-- Beispiel: Immer wenn eine Order reinkommt, User-Umsatz sofort aktualisieren
CREATE TRIGGER update_sales_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE user_stats 
    SET total_spent = total_spent + NEW.amount 
    WHERE user_id = NEW.user_id;
END;
```

### Events (Zeitgesteuert / "Cronjob")
Der "Pseudo Materialized View" Ansatz für teure Reports: Statt live (bremst Insert) lieber **nachts** neu berechnen.

```sql
-- Muss aktiviert sein
SET GLOBAL event_scheduler = ON;

-- Event: Jeden Tag um 03:00 Uhr
CREATE EVENT refresh_materialized_view
ON SCHEDULE EVERY 1 DAY STARTS '2025-01-01 03:00:00'
DO
BEGIN
    -- 1. Tabelle leeren (oder inkrementell updaten)
    TRUNCATE TABLE sales_report_mv;

    -- 2. Neu befüllen (Teure Query)
    INSERT INTO sales_report_mv
    SELECT category_id, SUM(amount) 
    FROM orders 
    GROUP BY category_id;
END;
```
