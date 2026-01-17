---
title: "MySQL Cheatsheet"
---

# MySQL Cheatsheet

Eine schnelle Referenz für die wichtigsten SQL-Befehle und Funktionen.

## 1. Grundlegende Abfragen (SELECT)

Daten abrufen ist die häufigste Operation.

```sql
-- Alle Spalten
SELECT * FROM employees;

-- Spezifische Spalten
SELECT first_name, last_name FROM employees;

-- Duplikate entfernen
SELECT DISTINCT title FROM titles;

-- Limitieren (Pagination)
SELECT * FROM employees LIMIT 10 OFFSET 20;
```

## 2. Filtern (WHERE)

Daten einschränken.

```sql
-- Exakter Match
SELECT * FROM employees WHERE gender = 'M';

-- Vergleichsoperatoren
SELECT * FROM salaries WHERE salary > 50000;
SELECT * FROM salaries WHERE salary BETWEEN 40000 AND 60000;

-- Liste von Werten
SELECT * FROM employees WHERE emp_no IN (10001, 10002, 10003);

-- Muster (LIKE)
-- % = beliebig viele Zeichen, _ = genau ein Zeichen
SELECT * FROM employees WHERE first_name LIKE 'Mar%'; -- Startet mit Mar
SELECT * FROM employees WHERE last_name LIKE '%son'; -- Endet mit son

-- NULL Prüfung
SELECT * FROM employees WHERE birth_date IS NOT NULL;
```

## 3. Sortieren (ORDER BY)

```sql
-- Aufsteigend (Standard)
SELECT * FROM employees ORDER BY hire_date ASC;

-- Absteigend
SELECT * FROM employees ORDER BY hire_date DESC;

-- Mehrere Spalten
SELECT * FROM employees ORDER BY last_name ASC, first_name ASC;
```

## 4. Aggregation & Gruppierung

Daten zusammenfassen und analysieren.

### Aggregat-Funktionen

| Funktion | Beschreibung |
| :--- | :--- |
| `COUNT(*)` | Zählt alle Zeilen (inkl. NULL). |
| `COUNT(col)` | Zählt Zeilen, wo `col` nicht NULL ist. |
| `SUM(col)` | Summiert Werte. |
| `AVG(col)` | Berechnet den Durchschnitt. |
| `MAX(col)` | Findet den größten Wert. |
| `MIN(col)` | Findet den kleinsten Wert. |

```sql
SELECT COUNT(*) FROM employees;
SELECT AVG(salary) FROM salaries WHERE to_date > NOW();
```

### GROUP BY

Gruppiert Zeilen mit gleichen Werten, um Aggregationen pro Gruppe durchzuführen.

```sql
-- Anzahl Mitarbeiter pro Titel
SELECT title, COUNT(*) 
FROM titles 
WHERE to_date > NOW() 
GROUP BY title;

-- Durchschnittsgehalt pro Abteilung
SELECT dept_no, AVG(salary) 
FROM dept_emp 
JOIN salaries USING (emp_no)
GROUP BY dept_no;
```

### HAVING

Filtert **nach** der Aggregation (wo `WHERE` nicht funktioniert).

```sql
-- Nur Abteilungen mit mehr als 10.000 Mitarbeitern
SELECT dept_no, COUNT(*) as emp_count
FROM dept_emp
GROUP BY dept_no
HAVING emp_count > 10000;
```

## 5. Daten Manipulation (DML)

```sql
-- Einfügen
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
VALUES (999999, '1990-01-01', 'Max', 'Mustermann', 'M', NOW());

-- Aktualisieren
UPDATE salaries 
SET salary = salary * 1.05 
WHERE emp_no = 10001 AND to_date > NOW();

-- Löschen
DELETE FROM employees WHERE emp_no = 999999;
```

## 6. Nützliche Funktionen

### String
*   `CONCAT(a, ' ', b)`: Verbindet Strings.
*   `UPPER(s)` / `LOWER(s)`: Groß-/Kleinschreibung.
*   `LENGTH(s)`: Länge in Bytes (`CHAR_LENGTH` für Zeichen).
*   `SUBSTRING(s, start, len)`: Teilstring extrahieren.
*   `TRIM(s)`: Leerzeichen entfernen.

### Datum & Zeit
*   `NOW()`: Aktuelles Datum + Zeit.
*   `CURDATE()`: Nur aktuelles Datum.
*   `DATEDIFF(end, start)`: Differenz in Tagen.
*   `DATE_ADD(date, INTERVAL 1 DAY)`: Datum rechnen.
*   `YEAR(date)`, `MONTH(date)`, `DAY(date)`: Teile extrahieren.

### Logik
*   `COALESCE(val1, val2, ...)`: Gibt den ersten Nicht-NULL Wert zurück.
*   `IFNULL(val, default)`: Wenn val NULL ist, nimm default.

## 7. Common Table Expressions (CTE)

Temporäre "Tabellen" für eine Query (ab MySQL 8.0). Macht komplexe Queries lesbarer.

```sql
WITH high_earners AS (
    SELECT emp_no, salary 
    FROM salaries 
    WHERE salary > 100000 AND to_date > NOW()
)
SELECT d.dept_name, COUNT(*) as count
FROM high_earners he
JOIN dept_emp de ON he.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
GROUP BY d.dept_name;
```

## 8. JSON Support

MySQL unterstützt JSON nativ. Das ist extrem mächtig für flexible Datenstrukturen.

### Tabelle erstellen
```sql
CREATE TABLE user_settings (
    user_id INT PRIMARY KEY,
    settings JSON
);
```

### Daten einfügen
JSON muss als valider String übergeben werden.
```sql
INSERT INTO user_settings (user_id, settings)
VALUES (1, '{"theme": "dark", "notifications": {"email": true, "sms": false}}');
```

### Daten abfragen (Extract)
Es gibt zwei Wege: `JSON_EXTRACT` oder den Pfeil-Operator `->` (mit Anführungszeichen) bzw. `->>` (ohne Anführungszeichen).

```sql
-- Klassisch
SELECT JSON_EXTRACT(settings, '$.theme') FROM user_settings;

-- Kurzform (gibt "dark" mit Quotes zurück)
SELECT settings->'$.theme' FROM user_settings;

-- Unquoted (gibt dark ohne Quotes zurück - meistens das, was man will)
SELECT settings->>'$.theme' FROM user_settings;

-- Filtern nach JSON Werten
SELECT * FROM salaries;
```

### Daten ändern (Update)
Niemals den String manuell manipulieren! Nutze die JSON-Funktionen.

*   `JSON_SET`: Fügt hinzu oder überschreibt.
*   `JSON_REPLACE`: Überschreibt nur existierende Keys.
*   `JSON_INSERT`: Fügt nur neue Keys hinzu.

```sql
-- JSON_SET: Ändert 'theme' (existiert) UND fügt 'lang' hinzu (neu)
UPDATE user_settings
SET settings = JSON_SET(settings, '$.theme', 'light', '$.lang', 'de')
WHERE user_id = 1;

-- JSON_REPLACE: Ändert NUR 'theme', ignoriert 'new_key' (weil es nicht existiert)
UPDATE user_settings
SET settings = JSON_REPLACE(settings, '$.theme', 'blue', '$.new_key', 'ignored')
WHERE user_id = 1;

-- JSON_INSERT: Fügt NUR 'hero_image' hinzu, ignoriert 'theme' (weil es schon existiert)
UPDATE user_settings
SET settings = JSON_INSERT(settings, '$.hero_image', 'hero.jpg', '$.theme', 'red')
WHERE user_id = 1;
```

### Nützliche JSON Funktionen

| Funktion | Beschreibung |
| :--- | :--- |
| `JSON_KEYS(json)` | Gibt alle Keys als Array zurück. |
| `JSON_VALID(str)` | Prüft, ob der String valides JSON ist (0 oder 1). |
| `JSON_ARRAY(...)` | Erstellt ein JSON Array. |
| `JSON_OBJECT(...)` | Erstellt ein JSON Objekt. |
| `JSON_LENGTH(json)` | Gibt die Anzahl der Elemente zurück. |
| `JSON_REMOVE(json, path)` | Entfernt einen Key. |

```sql
-- Array erstellen: ["a", 1]
SELECT JSON_ARRAY('a', 1);

-- Objekt erstellen: {"key": "value"}
SELECT JSON_OBJECT('key', 'value');
```

### MariaDB Besonderheiten (JSON)
MariaDB hat keinen nativen JSON-Typ.

```sql
-- Tabelle erstellen (Constraint ist wichtig!)
CREATE TABLE user_settings (
    id INT PRIMARY KEY,
    settings LONGTEXT CHECK (JSON_VALID(settings))
);

-- Skalare Werte holen (Typ-sicher)
SELECT JSON_VALUE(settings, '$.theme') FROM user_settings;

-- Objekt/Array holen
SELECT JSON_QUERY(settings, '$.notifications') FROM user_settings;
```

## 9. Window Functions

Erlauben Berechnungen über Zeilen hinweg, ohne sie zu gruppieren (anders als `GROUP BY`).

### Syntax
```sql
Funktion() OVER (
    [PARTITION BY spalte] 
    [ORDER BY spalte]
)
```

### Ranking
*   `ROW_NUMBER()`: Fortlaufende Nummer (1, 2, 3, 4).
*   `RANK()`: Rang mit Lücken bei Gleichstand (1, 2, 2, 4).
*   `DENSE_RANK()`: Rang ohne Lücken bei Gleichstand (1, 2, 2, 3).

```sql
-- Rangliste der Gehälter pro Abteilung
SELECT 
    dept_no, 
    emp_no, 
    salary,
    RANK() OVER (PARTITION BY dept_no ORDER BY salary DESC) as rang
FROM salaries;
```

### Value Functions
*   `LAG(col, n)`: Wert der n-ten Zeile *davor*.
*   `LEAD(col, n)`: Wert der n-ten Zeile *danach*.

```sql
-- Vergleich mit dem Gehalt des Vorgängers (zeitlich)
SELECT 
    emp_no,
    salary,
    LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) as prev_salary
FROM salaries;
```
