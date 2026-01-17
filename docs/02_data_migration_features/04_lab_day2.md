---
title: "Lab: Advanced Features"
---

Heute wird es knifflig. Es werden echte Probleme (Deadlocks) simuliert und moderne Features (JSON Store) gebaut.

## Aufgabe 1: Der Deadlock Simulator

Ein Deadlock passiert selten zufällig beim Entwickeln. Er muss erzwungen werden, um zu lernen, wie man ihn behandelt.

**Ziel:** Schreibe ein Bun-Skript `lab2_deadlock.ts`, das zwei parallele Transaktionen startet, die sich gegenseitig blockieren.

**Ablauf:**
1.  Erstelle eine Tabelle `accounts` mit `id` und `balance`. Setze zwei Accounts (ID 1 und 2) ein.
2.  Nutze `Promise.all`, um zwei asynchrone Funktionen gleichzeitig zu starten (`tx1` und `tx2`).
3.  **Tx1:**
    * `START TRANSACTION`
    * `UPDATE accounts ... WHERE id = 1` (Lockt ID 1)
    * `await new Promise(r => setTimeout(r, 2000))` (Warte 2 Sekunden, damit Tx2 Zeit hat zu starten)
    * `UPDATE accounts ... WHERE id = 2` (Will Lock für ID 2 -> Wartet auf Tx2)
4.  **Tx2:**
    * `START TRANSACTION`
    * `UPDATE accounts ... WHERE id = 2` (Lockt ID 2)
    * `await new Promise(r => setTimeout(r, 2000))`
    * `UPDATE accounts ... WHERE id = 1` (Will Lock für ID 1 -> Wartet auf Tx1)
5.  **Ergebnis:** Fange den Fehler ab und gib aus, wer gewonnen hat.


:::tip[Doku]
Schaue in die Bun Doku: [SQL Transactions](https://bun.com/reference/bun/SQL/transaction)   
:::


## Aufgabe 2: JSON Produktkatalog

Es wird ein flexibler Shop gebaut.

1.  Erstelle Tabelle `products_json` (`id`, `name`, `attributes` JSON).
2.  Füge via Bun 5 Produkte ein. Nutze unterschiedliche Attribute!
    * Laptop: `{"ram": "16GB", "os": "macOS", "ports": ["usb-c", "hdmi"]}`
    * T-Shirt: `{"size": "L", "color": "blue", "material": "cotton"}`
3.  **Query 1:** Finde alle Produkte, die das Attribut `os` haben (egal welches).
4.  **Query 2:** Finde alle Produkte, die im Array `ports` den Wert `usb-c` haben (`JSON_CONTAINS`).
5.  **Update:** Ändere bei allen T-Shirts das Material auf "bio-cotton" (nutze `JSON_SET` oder `JSON_REPLACE`).

---

## Aufgabe 3: Fulltext Search Engine

1.  Nutze die `employees` Datenbank.
2.  Es soll in den `titles` gesucht werden.
3.  Erstelle einen `FULLTEXT` Index auf der Spalte `title`.
4.  Finde alle Mitarbeiter, die "Engineer" im Titel haben, aber **nicht** "Senior" oder "Assistant".
    * *Tipp: Boolean Mode nutzen!*
5.  Vergleiche die Performance (Laufzeit) mit einer normalen `LIKE '%Engineer%'` Suche.
