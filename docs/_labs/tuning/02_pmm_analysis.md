---
title: "Lab 02: PMM Setup"
---

# Lab: PMM Setup & Analysis

Jetzt wird es ernst. Wir installieren Monitoring.

## Deine Aufgabe

1.  Prüfe, ob der PMM Server auf der VM läuft (`curl -I https://<PMM-VM-IP>` oder Login Check).
2.  Installiere den PMM Client auf deiner Datenbank-Instanz (siehe Modul 3).
3.  Verbinde den Client mit dem PMM Server.
4.  Erzeuge Last ("Noise").

## Load Script (Bun)

Erstelle eine Datei `loadtest.ts`:

```typescript
import { createConnection } from 'mysql2/promise';

const db = await createConnection({
    host: 'localhost', user: 'root', password: 'password', database: 'employees'
});

// Bad Query Loop
while(true) {
    await db.execute("SELECT * FROM salaries WHERE salary > 50000"); // Full Scan wenn kein Index auf Salary
    await new Promise(r => setTimeout(r, 100)); // 10ms Pause
}
```

## Analyse

1.  Öffne das PMM Dashboard (`http://localhost`).
2.  Gehe zu **Query Analytics (QAN)**.
3.  Finde die Query aus dem Skript.
4.  Wie viel "Load" verursacht sie?
5.  Füge einen Index hinzu (`CREATE INDEX idx_salary ON salaries(salary)`).
6.  Beobachte den Graphen. Geht der Load runter?
