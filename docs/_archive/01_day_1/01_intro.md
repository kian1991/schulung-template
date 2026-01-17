---
title: "Einstieg & Grundlagen"
---

In den nächsten 3 Tagen werden wir gemeinsam tief in die Features von MySQL eintauchen. Dieser Kurs ist speziell für Entwickler konzipiert, die über einfaches `SELECT * FROM users` hinausgehen wollen. Wir nutzen moderne Tools wie **Docker** und **Bun (TypeScript)**, um praxisnah zu arbeiten.

## 1. Lernziele & Erwartungen

Das Ziel ist es, nicht nur SQL-Syntax zu lernen, sondern zu verstehen, wie man MySQL **effizient** in modernen Applikationen einsetzt.

**Was du nach Tag 1 können wirst:**
* Eine saubere lokale Entwicklungsumgebung mit Docker aufsetzen.
* Komplexe Datenstrukturen mit JOINs und Unions abfragen.
* Große Datenmengen performant importieren und exportieren.
* Deine Datenbank-Architektur mit Views und Virtual Columns sauber halten.

---

## 2. Warum MySQL?

MySQL ist nicht ohne Grund eine der beliebtesten Datenbanken der Welt.

:::info[Wusstest du schon?]
MySQL treibt riesige Plattformen wie Facebook, Uber und GitHub an. Es ist extrem skalierbar, wenn man es richtig benutzt.
:::

### Die Stärken
1.  **Verbreitung:** Es gibt für jedes Problem eine Lösung auf StackOverflow.
2.  **Performance:** Besonders bei Lese-Operationen (Read-Heavy Workloads) extrem schnell.
3.  **Flexibilität:** Mit JSON-Support und GIS-Features ist es mehr als nur eine relationale Datenbank.

---

---

## 4. Das Szenario: Employees Database

Wir arbeiten mit einem klassischen, aber komplexen Datensatz: Der **Employees Database**. Sie simuliert eine große Firmenstruktur mit ca. 300.000 Mitarbeitern.

Das Datenmodell besteht aus:
* **employees:** Die Stammdaten (Name, Geburtsdatum, etc.).
* **departments:** Die verschiedenen Abteilungen (Sales, Marketing, ...).
* **dept_emp:** Eine n:m Tabelle, die verknüpft, wer wann in welcher Abteilung gearbeitet hat.
* **salaries:** Eine Historie aller Gehaltszahlungen (Achtung: Viele Daten!).
* **titles:** Wer hatte wann welchen Jobtitel?

:::warning[Historische Daten]
Viele Tabellen haben `from_date` und `to_date` Spalten. Das bedeutet, wir sehen nicht nur den *aktuellen* Zustand, sondern die gesamte Historie. Das macht unsere Queries spannender!
:::
