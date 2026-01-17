---
title: "Dynamic SQL & Debugging"
---

# Dynamic SQL & Debugging

Wenn schon programmiert wird, muss auch über die schwierigen Teile geredet werden.

## 1. Dynamic SQL (Prepared Statements)

Normalerweise sind SQL-Statements statisch. `SELECT * FROM users`.
Was aber, wenn der Tabellenname erst zur Laufzeit bekannt ist? Oder die WHERE-Klausel dynamisch zusammengebaut wird?

In Stored Procedures lassen sich SQL-Strings bauen und ausführen.

```sql
CREATE PROCEDURE count_rows(IN p_table_name VARCHAR(64))
BEGIN
    -- 1. String bauen
    SET @sql = CONCAT('SELECT COUNT(*) FROM ', p_table_name);
    
    -- 2. Vorbereiten
    PREPARE stmt FROM @sql;
    
    -- 3. Ausführen
    EXECUTE stmt;
    
    -- 4. Aufräumen
    DEALLOCATE PREPARE stmt;
END;
```

### Die Gefahr: SQL Injection
Auch in Stored Procedures ist man nicht sicher!

**BÖSE:**
`SET @sql = CONCAT('SELECT * FROM users WHERE name = "', p_user_input, '"');`
Wenn `p_user_input` nun `"; DROP TABLE users; --` ist, hat man ein Problem.

**GUT:**
Nutze Platzhalter `?`.
`SET @sql = 'SELECT * FROM users WHERE name = ?';`
`EXECUTE stmt USING @user_input;`

---

## 2. Error Handling

Was passiert, wenn ein `INSERT` fehlschlägt? In TypeScript nutzt man `try-catch`. In MySQL nutzt man `DECLARE HANDLER`.

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    -- Das ist der "catch" Block
    ROLLBACK;
    SELECT 'An error occurred, transaction rolled back' as error_msg;
END;

START TRANSACTION;
-- ... riskante Operationen ...
COMMIT;
```

## 3. Debugging

Das größte Manko von MySQL Stored Procedures: Es gibt keinen Debugger. Man kann keine Breakpoints setzen.

### Workaround 1: Select Debugging
Streue `SELECT` Statements ein, um Variablenwerte zu prüfen.

```sql
SELECT v_my_variable as 'DEBUG: Variable X';
```

### Workaround 2: Log Table
Erstelle eine Tabelle `debug_log` und schreibe Nachrichten hinein.

**Problem:** Wenn die Transaktion `ROLLBACK` macht, werden auch die Log-Einträge gelöscht!
**Lösung:** Nutze eine separate Connection oder (Hack) eine MyISAM Tabelle (unterstützt keine Transaktionen, daher bleiben Daten erhalten).
