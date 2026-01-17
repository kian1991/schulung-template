---
title: "Dynamic SQL & Error Handling"
---

# Dynamic SQL & Error Handling

Wenn man zur Laufzeit nicht weiß, wie die Tabelle heißt...

## Dynamic SQL (Prepared Statements)

In Stored Procedures kann man Statements dynamisch zusammenbauen ("String Concatenation").
**Achtung:** SQL Injection Risiko beachten, auch intern!

```sql
SET @table_name = 'orders_2024';
SET @query = CONCAT('SELECT count(*) FROM ', @table_name);

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
```

**Use Case:** Generische Import-Prozeduren oder dynamische Suchfilter, bei denen Spaltenbezeichner variabel sind.

## Exceptions & Fehlerbehandlung

"Fail silently" ist keine Option. Wir fangen Fehler ab.

### Handlers

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    INSERT INTO error_log VALUES ('Something went wrong', NOW());
    RESIGNAL; -- Fehler weiterwerfen an den Aufrufer
END;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
```

### SIGNAL (Eigene Fehler werfen)

Wie `throw new Exception()` in Java/PHP.

```sql
IF credit_limit < 0 THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Kreditlimit kann nicht negativ sein', 
        MYSQL_ERRNO = 9001;
END IF;
```
`SQLSTATE '45000'` ist der Standard für "User Defined Exception".
