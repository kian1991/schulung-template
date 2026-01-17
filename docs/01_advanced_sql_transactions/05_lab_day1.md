---
title: "Lab: Grundlagen"
---

## Vorbereitung

> Installiere BUN: `curl -fsSL https://bun.sh/install | bash`

1.  Stelle sicher, dass deine Docker-Container laufen (`docker-compose up -d`).
2.  Gehe in das `assets` Verzeichnis und installiere die Abhängigkeiten:

```bash
    cd assets
    bun install 
```

---

## Aufgabe 1: Der Import (Big Data)

Es werden Daten benötigt! Das "Employees" Dataset ist perfekt, um Performance zu testen.

1.  **Download:** Lade das Repository [test_db](https://github.com/datacharmer/test_db) herunter (ZIP oder git clone).
2.  **Import:** Importiere die `employees.sql` in deine Docker-Datenbank.
    * *Tipp:* Du kannst `mysql` lokal installieren oder den `mysql` Client im Docker-Container nutzen.
3.  **Check:** Prüfe in phpMyAdmin, ob die Tabellen da sind. `employees` sollte ca. 300.000 Zeilen haben.

---

## Aufgabe 2: Der "Big Join" mit Bun

Es soll eine komplexe Auswertung gefahren werden. Schreibe ein TypeScript-Skript `lab1_joins.ts`.

**Die Frage:**
"Wer sind die **aktuellen** Manager jeder Abteilung, wie heißen sie, und was verdienen sie **aktuell**?"

**Du brauchst:**
* `departments` (Abteilungsname)
* `dept_manager` (Verknüpfung Manager -> Abteilung)
* `employees` (Namen)
* `salaries` (Gehalt)

**Anforderungen:**
1.  Nutze `bun` für die Verbindung.
2.  Achte darauf, nur `to_date > NOW()` Einträge zu nehmen (sonst hast du auch Ex-Manager).
3.  Gib das Ergebnis schön formatiert in der Konsole aus (`console.table`).

```ts
// Skeleton
import { SQL } from "bun";

const db = new SQL("mysql://root:root@localhost:3306/employees");

async function main() {
    // Dein Code hier...
    // Beispiel: const result = await db`SELECT NOW()`;
    
    console.log("Ready to query!");
}
main();
```

---

## Aufgabe 3: JSON & Virtual Columns

Es wird ein modernes Logging-System simuliert.

1.  Erstelle eine Tabelle `app_logs` mit:
    * `id` (Auto Increment)
    * `created_at` (Timestamp)
    * `payload` (JSON)
2.  Schreibe ein Skript, das **10.000 Log-Einträge** generiert und einfügt.
    * Format: `{"level": "ERROR", "msg": "Something went wrong", "user_id": 123}`
    * Mische verschiedene Level (`INFO`, `WARN`, `ERROR`).
3.  **Benchmark 1:** Suche alle `ERROR` Logs mit einer normalen JSON Query (`WHERE payload->>'$.level' = 'ERROR'`). Miss die Zeit (nutze `console.time`).
4.  **Optimierung:**
    - Füge eine **Stored Generated Column** `log_level` hinzu.
    - Lege einen Index darauf.
5.  **Benchmark 2:** Suche erneut (jetzt über die neue Spalte).

:::tip[Bun Performance]
Bun ist sehr schnell. Um wirklich einen Unterschied zu messen, brauchst du vielleicht mehr als 10.000 Zeilen. Trau dich ruhig an 100.000!
:::
