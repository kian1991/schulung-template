---
title: "PMM - Percona Monitoring"
---

# Software Profiling mit PMM

Percona Monitoring and Management (PMM) ist der Gold-Standard für Open-Source Datenbank-Monitoring.

## Architektur

PMM folgt einer klassischen **Client-Server-Architektur**:

1.  **PMM Server:** Die Kommandozentrale.
    *   **Grafana:** Zur Visualisierung (Dashboards).
    *   **VictoriaMetrics:** Speichert Time-Series-Daten (CPU, Disk I/O, MySQL Status).
    *   **ClickHouse:** Speichert Query-Daten für QAN (Query Analytics).
2.  **PMM Client:** Ein Agent (`pmm-agent`), der auf deinem Datenbank-Server läuft.
    *   Er managt Exporter wie `mysqld_exporter` (für Metriken) und `node_exporter` (für System-Daten).
    *   Er schickt die Daten verschlüsselt an den Server.

---

## Wie PMM Daten sammelt (Internals)

Woher weiß PMM, welche Query langsam ist? Es gibt zwei Hauptquellen.

### 1. Slow Query Log
Der klassische Weg. MySQL schreibt alle Queries, die länger als `long_query_time` dauern, in eine Datei.
*   **Vorteil:** Funktioniert immer und überall.
*   **Nachteil:** Teuer (Disk I/O), ungenau (nur "Zeit > X"), muss geparst werden.

### 2. Performance Schema (`perfschema`)
Der moderne Weg. MySQL instrumentiert sich selbst und hält Metriken im RAM (`performance_schema.*` Tabellen).
*   **Vorteil:** Extrem detailliert (Lock-Zeiten, Rows examined, Index usage), schnell (Memory), granular.
*   **PMM:** Nutzt standardmäßig `perfschema`, um Daten für QAN zu sammeln (`--query-source=perfschema`).

:::info[Warum Performance Schema?]
Das Performance Schema erlaubt Einblicke, die Logs nicht bieten: "Wartete diese Query auf einen Mutex?" oder "Hat sie einen Temp-Table auf Disk angelegt?".
:::

---

## Query Analytics (QAN)

Das QAN ist das Herzstück für Entwickler. Es beantwortet die Frage: **"Warum ist die DB langsam?"**

### Funktionsweise
PMM sammelt Rohdaten (z.B. 1000 Ausführungen von `SELECT * FROM users WHERE id = ?`) und aggregiert sie.

1.  **Fingerprinting:** PMM entfernt konkrete Werte.
    *   `SELECT * FROM users WHERE id = 5`
    *   `SELECT * FROM users WHERE id = 9`
    *   -> Werden zusammengefasst zu `SELECT * FROM users WHERE id = ?`.
2.  **Aggregation:** PMM zeigt dir:
    *   **Count:** Wie oft lief die Query? (z.B. 10.000 Mal/Sek)
    *   **Load:** Wie viel Zeit hat sie insgesamt auf dem Server "verbrannt"?

### Was tun, wenn es brennt?

1.  QAN öffnen und Zeitraum des Spikes markieren.
2.  Nach **Load** sortieren (nicht nach Einzel-Dauer!). Eine Query, die 10ms dauert, aber 1000x pro Sekunde läuft, ist oft schlimmer als eine, die 1x pro Stunde 5s dauert.
3.  Query anklicken -> **EXPLAIN** Tab prüfen.
4.  Optimieren (Index hinzufügen, Caching, Rewrite).
