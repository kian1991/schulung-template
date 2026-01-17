---
title: "Tuning & Profiling"
---

# Tuning & Profiling

"Die Datenbank ist langsam." - Der Satz, den jeder Entwickler fürchtet. Heute lernen wir, wie wir das beheben.

## 1. EXPLAIN (Der Röntgenblick)

Bevor wild Indizes erstellt werden, frage MySQL, *wie* es die Query ausführen will.
Setze einfach `EXPLAIN` vor die Query.

```sql
EXPLAIN SELECT * FROM employees WHERE last_name = 'Facello';
```

### Die wichtigsten Spalten

| Spalte | Wert | Bedeutung | Gut/Schlecht |
| :--- | :--- | :--- | :--- |
| **type** | `ALL` | **Full Table Scan**. MySQL liest JEDE Zeile. | 🔴 Sehr Schlecht (außer bei winzigen Tabellen) |
| | `index` | Full Index Scan. Liest den ganzen Index. | 🟠 Naja |
| | `range` | Nutzt Index für einen Bereich (`>`, `BETWEEN`). | 🟢 Gut |
| | `ref` | Nutzt Index für exakten Match. | 🟢 Sehr Gut |
| | `const` | Primary Key Lookup (max 1 Treffer). | 🟢 Perfekt |
| **key** | `NULL` | Kein Index genutzt. | 🔴 Schlecht |
| **rows** | `1000` | MySQL *schätzt*, dass es 1000 Zeilen prüfen muss. | Je weniger, desto besser |
| **Extra** | `Using filesort` | Muss Ergebnisse extra sortieren (CPU intensiv). | 🟠 Vermeiden wenn möglich |
| | `Using temporary` | Erstellt temporäre Tabelle (RAM/Disk). | 🟠 Vermeiden |

---

## 2. Profiling (Die Stoppuhr)

`EXPLAIN` zeigt den Plan. `PROFILING` zeigt die Realität.

```sql
-- 1. Aktivieren
SET profiling = 1;

-- 2. Query ausführen
SELECT ...; 

-- 3. Report ansehen
SHOW PROFILES;
-- Query_ID | Duration | Query
-- 1        | 0.500    | SELECT ...

-- 4. Details ansehen
SHOW PROFILE FOR QUERY 1;
```
Hier sieht man genau: 
* `Sending data`: Zeit für Netzwerk-Transfer.
* `Creating sort index`: Zeit für CPU-Sortierung.
* `Waiting for table lock`: Zeit für Warten auf andere.

### Software Profiling (App-Side)

Oft liegt das Problem gar nicht in der Datenbank.
* **N+1 Problem:** Die Datenbank ist schnell (0.1ms), wird aber 10.000 Mal aufgerufen.
* **Large Payloads:** Die Query dauert 10ms, aber das Übertragen von 50MB JSON dauert 2 Sekunden.

**Lösung:** Messe auch im Applikations-Code!

```typescript
console.time("db_query");
const users = await db`SELECT * FROM users`;
console.timeEnd("db_query"); // -> db_query: 12.4ms
```

---

## 3. Schema Tuning Best Practices

### Datentypen
Nutze immer den kleinstmöglichen Typ.
* `TINYINT` (1 Byte) statt `INT` (4 Byte) für Status-Flags (0/1).
* `VARCHAR(20)` statt `VARCHAR(255)` wenn bekannt ist, dass es kurz ist (hilft bei Temp Tables im RAM).

### Normalisierung vs. Denormalisierung
* **3. Normalform:** Keine Redundanz. Gut für Schreib-Performance (nur 1 Stelle ändern).
* **Denormalisierung:** Redundanz erlauben (z.B. `customer_name` auch in `orders` Tabelle speichern).
    * **Vorteil:** Spart JOINs beim Lesen -> Schneller.
    * **Nachteil:** Bei Namensänderung muss man an 2 Stellen updaten.

:::tip[Faustregel]
Starte normalisiert. Denormalisiere nur gezielt, wenn es Performance-Probleme gibt.
:::

### Indizes
* **Composite Indexes:** Ein Index über `(last_name, first_name)`.
    * Hilft bei `WHERE last_name = 'X'`.
    * Hilft bei `WHERE last_name = 'X' AND first_name = 'Y'`.
    * Hilft **NICHT** bei `WHERE first_name = 'Y'` (Links-Präfix-Regel)!
