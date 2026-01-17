---
title: "Views & Virtual Columns"
---

# Views, Materialized Views & Virtual Columns

Wie hält man die Datenbank sauber und performant, wenn die Anforderungen komplexer werden?

## 1. Views (Sichten)

Eine View ist im Grunde eine **gespeicherte Query**, die wie eine Tabelle aussieht.

### Warum Views nutzen?

1.  **Abstraktion:** Deine Applikation muss nicht wissen, dass die Daten aus 5 verschiedenen Tabellen gejoined werden. Sie macht einfach `SELECT * FROM v_user_details`.
2.  **Sicherheit:** Du kannst einem User Zugriff auf eine View geben, aber den Zugriff auf die darunterliegenden Tabellen (z.B. mit Passwörtern) verweigern.
3.  **Refactoring:** Wenn du dein Tabellen-Schema änderst, kannst du die View anpassen, ohne dass der App-Code geändert werden muss.

```sql
CREATE OR REPLACE VIEW v_current_salaries AS
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date > NOW(); -- Logik "Was ist aktuell?" zentral gekapselt
```

:::info[Performance]
In MySQL sind Views (meistens) **keine** Performance-Optimierung. Die Query wird jedes Mal zur Laufzeit ausgeführt (Merge Algorithm).
:::

---

## 2. Materialized Views

In Datenbanken wie Oracle oder PostgreSQL gibt es "Materialized Views". Diese speichern das Ergebnis der Query physisch auf der Disk. Das ist extrem schnell beim Lesen, muss aber aktualisiert werden.

MySQL hat das **nicht eingebaut**. Aber es lässt sich simulieren!

**Das Pattern:**
1.  Erstelle eine echte Tabelle für das Ergebnis (`mv_report`).
2.  Fülle sie initial mit Daten.
3.  Aktualisiere sie regelmäßig (z.B. jede Nacht via Event oder sofort via Trigger).

```sql
-- 1. Zieltabelle
CREATE TABLE mv_sales_report (
    category VARCHAR(50),
    total_amount DECIMAL(10,2),
    PRIMARY KEY (category)
);

-- 2. Refresh (z.B. jede Nacht)
TRUNCATE TABLE mv_sales_report;
INSERT INTO mv_sales_report 
SELECT category, SUM(amount) 
FROM sales 
GROUP BY category;
```

---

## 3. Generated Columns (Virtual Columns)

Seit MySQL 5.7 gibt es `Generated Columns`

Stell dir vor, du hast eine Spalte, die sich automatisch aus anderen berechnet.

### Typ A: VIRTUAL (Default)
Wird **on-the-fly** beim Lesen berechnet.
* Verbraucht keinen Speicherplatz auf der Disk.
* Kostet etwas CPU beim Lesen.
* Gut für einfache Berechnungen (`price * quantity`).

### Typ B: STORED
Wird beim **Schreiben** (`INSERT`/`UPDATE`) berechnet und physisch gespeichert.
- Verbraucht Speicherplatz.
- Kostet Performance beim Schreiben.
- **Der Killer-Feature:** Du kannst einen **INDEX** darauf legen! Okay seit 8.0 geht das auch auf Virtual Columns.

### Use Case: JSON Indexing
MySQL ist ein hervorragender JSON Store. Aber wie sucht man effizient in JSON?

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    data JSON
);

-- Langsam (Full Scan)
SELECT * FROM users WHERE data->>'$.email' = 'test@example.com';

-- Die Lösung: Virtual Column + Index
ALTER TABLE users 
ADD COLUMN email VARCHAR(255) 
GENERATED ALWAYS AS (data->>'$.email') STORED;

CREATE INDEX idx_email ON users(email);

-- Jetzt nutzt MySQL automatisch den Index!
SELECT * FROM users WHERE email = 'test@example.com';
```

#### Mini-Übung
> Erstelle eine Tabelle `rectangles` mit `width` und `height`.
> Füge eine Virtual Column `area` hinzu, die automatisch die Fläche berechnet.
> Füge ein paar Zeilen ein und prüfe, ob `area` korrekt gefüllt wird.
