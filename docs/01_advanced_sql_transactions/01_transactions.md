---
title: "Transaktionen & Locking"
---

Heute verlassen wir die Welt der einfachen Abfragen und kümmern uns um **Datenintegrität**. Wie wird sichergestellt, dass die Daten auch dann korrekt sind, wenn der Server abstürzt oder 1000 User gleichzeitig darauf zugreifen?

## 1. Das Bank-Problem (ACID)

Stell dir vor, es werden 100€ an einen Freund überwiesen.
Das sind zwei Schritte in der Datenbank:
1.  `UPDATE accounts SET balance = balance - 100 WHERE id = ME;`
2.  `UPDATE accounts SET balance = balance + 100 WHERE id = FRIEND;`

**Was passiert, wenn nach Schritt 1 der Strom ausfällt?**
Das Geld ist weg, aber beim Freund nicht angekommen. Katastrophe!

Hier kommen **Transaktionen** ins Spiel. Jede relationale Datenbank (wie MySQL mit InnoDB) verspricht **[ACID](./02_acid_base.md)**:

### Syntax in MySQL

```sql
START TRANSACTION;

UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- ... hier könnte alles mögliche passieren ...
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

COMMIT; -- Erst jetzt wird es dauerhaft gespeichert
-- Oder: ROLLBACK; -- Macht alles rückgängig
```


---

## 2. Isolation Levels

Das "I" in ACID ist das komplizierteste. Wie stark sollen parallele Transaktionen voneinander abgeschottet sein?

MySQL bietet 4 Level. Sie lassen sich pro Session setzen: `SET SESSION TRANSACTION ISOLATION LEVEL ...`

### 1. READ UNCOMMITTED (Dirty Read)
"Ich sehe alles, auch das, was noch nicht fertig ist."
* **Gefahr:** Man liest Daten von einer Transaktion, die später vielleicht `ROLLBACK` macht. Die Daten waren also nie real.
* **Nutzen:** Fast nie. Nur für grobe Statistiken ("Ungefähr wie viele Rows?").

### 2. READ COMMITTED
"Ich sehe nur das, was wirklich committet wurde."
* Das ist der Standard in PostgreSQL und Oracle.
* **Phänomen:** Wenn die gleiche SELECT-Query zweimal in einer Transaktion ausgeführt wird, könnten unterschiedliche Ergebnisse kommen (weil zwischendurch jemand anderes committet hat).

### 3. REPEATABLE READ (MySQL Standard)
"Ich lebe in meiner eigenen Zeitblase."
* Wenn eine Transaktion gestartet wird, macht MySQL quasi einen "Snapshot".
* Egal was andere machen (löschen, einfügen, ändern), man sieht immer den Stand vom Beginn der Transaktion.
* **Vorteil:** Konsistente Reports.

### 4. SERIALIZABLE
"Einer nach dem anderen."
* Extrem striktes Locking. Wenn gelesen wird, können andere nicht schreiben.
* **Nachteil:** Langsam und viele Timeouts.

---

## 3. Locking & Deadlocks

Um Isolation zu garantieren, muss MySQL Zeilen sperren (Locking).

### Pessimistic Locking
Es wird davon ausgegangen, dass es Konflikte geben wird. Deshalb wird die Zeile gesperrt, **bevor** sie gelesen/bearbeitet wird.

```sql
START TRANSACTION;
-- "SELECT ... FOR UPDATE" sperrt die Zeilen exklusiv.
-- Niemand anderes kann sie ändern oder sperren, bis die Transaktion fertig ist.
SELECT * FROM products WHERE id = 1 FOR UPDATE;

-- Jetzt kann man sicher sein, dass der Bestand sich nicht geändert hat.
UPDATE products SET stock = stock - 1 WHERE id = 1;
COMMIT;
```

### Das Deadlock-Problem
Ein Deadlock ist eine Pattsituation.

* Transaktion A hält Lock auf Zeile 1 und will Zeile 2.
* Transaktion B hält Lock auf Zeile 2 und will Zeile 1.
* **Ergebnis:** Beide warten ewig.

MySQL erkennt das automatisch und bricht eine der beiden Transaktionen ab (Fehler 1213).

:::tip[Umgang mit Deadlocks]
Deadlocks sind in komplexen Apps normal.
1.  **Reihenfolge:** Versuche, Tabellen/Zeilen immer in der gleichen Reihenfolge zu sperren.
2.  **Retry:** Baue in der Applikation eine Logik ein, die bei Fehler 1213 die Transaktion einfach nochmal probiert.
:::
