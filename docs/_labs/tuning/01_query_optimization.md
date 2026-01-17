---
title: "Lab 01: Slow Query Hunt"
---

# Lab: Optimizer Challange

Finde den Flaschenhals.

## Szenario

Eine Tabelle `audit_logs` hat 1 Million Einträge.
Einer deiner Kollegen hat folgende Query gebaut, um alle Logs eines Users zu finden:

```sql
SELECT * FROM audit_logs WHERE SUBSTRING(message, 1, 5) = 'UserA';
```

## Deine Aufgabe

1.  Führe `EXPLAIN` auf diese Query aus. Was sagt die Spalte `type`?
2.  Optimiere die Query oder den Index, damit sie schneller wird (und der Index genutzt werden kann).

<details>
<summary>Lösung</summary>

**Problem:** Funktionen auf Spalten (`SUBSTRING(message...)`) verhindern Index-Nutzung! ("Sargable" Problem).

**Lösung A (Query ändern):**
```sql
-- Nutzt einen Index auf `message`, falls vorhanden
SELECT * FROM audit_logs WHERE message LIKE 'UserA%';
```

**Lösung B (Index anpassen - Moderne Versionen):**
Functional Index erstellen.
```sql
CREATE INDEX idx_user_msg ON audit_logs ((SUBSTRING(message, 1, 5)));
```
</details>
