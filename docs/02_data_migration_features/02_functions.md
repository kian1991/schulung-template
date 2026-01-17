---
title: "JSON & Window Functions"
---

# JSON & Window Functions

MySQL 8.0 hat Features eingeführt, die die Grenze zwischen relationalen und NoSQL-Datenbanken verschwimmen lassen.

## 1. JSON Support

Früher wurden dynamische Daten oft als Text gespeichert oder EAV (Entity-Attribute-Value) Tabellen gebaut (Grusel!). Heute nutzt man den nativen JSON Datentyp.

MySQL speichert JSON in einem optimierten Binärformat (schneller Zugriff auf einzelne Keys, kein Parsen des ganzen Textes nötig).

### Zugriff auf Daten
Man nutzt den Pfeil-Operator `->` (gibt JSON zurück) oder `->>` (gibt Text zurück, ohne Anführungszeichen).

```sql
SELECT 
    id, 
    data->>'$.name' as product_name, 
    data->'$.tags[0]' as first_tag
FROM products;
```

### Suchen in JSON
```sql
-- Finde alle Produkte, die den Tag "red" haben
SELECT * FROM products 
WHERE JSON_CONTAINS(data->'$.tags', '"red"');

-- Finde alle Produkte, wo der Preis > 50 ist
SELECT * FROM products
WHERE data->'$.price' > 50;
```

### Manipulation
JSON lässt sich atomar ändern, ohne dass der ganze String neu geschrieben werden muss.

```sql
UPDATE products 
SET data = JSON_SET(data, '$.price', 99.99, '$.status', 'active')
WHERE id = 1;
```

:::info[Wann JSON?]
Nutze JSON für **Attribute**, die sich je nach Produkt unterscheiden (z.B. T-Shirt Größe vs. Festplatten-Kapazität).
Nutze normale Spalten für **Metadaten**, nach denen oft gefiltert/sortiert wird (Preis, Erstellt am, Name).
:::

### MariaDB vs. MySQL 

MariaDB geht beim Thema JSON **bewusst einen anderen Weg** als MySQL. Zwar existiert in MariaDB ein `JSON` Datentyp, technisch ist er jedoch **kein binärer JSON-Typ**, sondern ein Alias für `LONGTEXT`.

1. **Speicherung:** `JSON` ist intern `LONGTEXT` mit optionaler Validierung.
2. **Validierung:** Gültigkeit von JSON wird über `CHECK` Constraints oder Funktionen wie `JSON_VALID()` sichergestellt.

```sql
-- MariaDB Syntax
CREATE TABLE user_settings (
    user_id INT PRIMARY KEY,
    settings JSON CHECK (JSON_VALID(settings))
);
```

*Vorteil:* Schnelleres Schreiben, da kein binäres JSON-Parsing und keine interne Repräsentation beim Insert erzeugt wird.
*Nachteil:* Langsameres Lesen bei komplexen Abfragen, da JSON bei jedem Zugriff zur Laufzeit geparst wird.

Quelle:
[https://mariadb.com/docs/server/reference/data-types/string-data-types/json](https://mariadb.com/docs/server/reference/data-types/string-data-types/json)

#### MariaDB Spezifische Funktionen

MariaDB stellt JSON-Funktionen bereit, die sich **konzeptionell und semantisch** von MySQL unterscheiden. Besonders wichtig ist die Trennung zwischen skalaren und strukturellen Rückgaben.

* `JSON_VALUE(json, path)`
  Extrahiert **einen skalaren Wert** (String, Number, Boolean).
  Liefert **keinen JSON-Typ**, sondern direkt einen SQL-Skalar.
  Implizite Typkonvertierung möglich.

* `JSON_QUERY(json, path)`
  Extrahiert ein **JSON-Objekt oder Array** und gibt es als JSON Text zurück.

```sql
-- Gib mir den Preis als echte Zahl (DECIMAL), nicht als String
SELECT CAST(JSON_VALUE(data, '$.price') AS DECIMAL(10,2))
FROM products;
```

Dieses Verhalten ist bewusst näher an SQL Standard JSON Funktionen angelehnt als an MySQLs Implementierung.

Quelle:
[https://mariadb.com/docs/server/reference/sql-functions/json-functions/](https://mariadb.com/docs/server/reference/sql-functions/json-functions/)

---


## 2. Window Functions

Das wohl mächtigste Feature für Analysen. Window Functions erlauben Berechnungen über eine Gruppe von Zeilen, **ohne** sie mit `GROUP BY` zu einer einzigen Zeile zusammenzufassen.

### Das Prinzip
`FUNCTION() OVER (PARTITION BY ... ORDER BY ...)`

### Beispiel 1: Ranking
"Gib mir die Top 3 Gehälter pro Abteilung."

Mit `GROUP BY` unmöglich. Mit Window Functions einfach:

```sql
SELECT 
    dept_no, 
    emp_no, 
    salary,
    RANK() OVER (PARTITION BY dept_no ORDER BY salary DESC) as ranking
FROM salaries;
```
Das Ergebnis behält alle Zeilen! Es gibt nur eine neue Spalte `ranking` (1, 2, 3, ...), die pro Abteilung neu bei 1 anfängt.

### Beispiel 2: Running Total (Laufende Summe)
"Wie hat sich der Umsatz über den Monat entwickelt?"

```sql
SELECT 
    date, 
    amount,
    SUM(amount) OVER (ORDER BY date) as running_total
FROM sales;
```

### Beispiel 3: Lead & Lag (Zeitreisen)
"Vergleiche den Umsatz heute mit dem von gestern."

```sql
SELECT 
    date, 
    revenue,
    LAG(revenue, 1) OVER (ORDER BY date) as yesterday_revenue,
    revenue - LAG(revenue, 1) OVER (ORDER BY date) as diff
FROM daily_sales;
```

#### Mini-Übung
> Nutze die `salaries` Tabelle.
> Zeige für jeden Mitarbeiter das aktuelle Gehalt und das Gehalt davor (nutze `LAG` über `from_date`).
