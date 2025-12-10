---
title: "04 Container Communication via Volumes"
---

## Szenario

Microservices müssen oft Dateien austauschen (z.B. Logfiles, Reports).
Wir bauen zwei Container, die über ein Volume kommunizieren.

## Deine Mission

   Erstelle ein Volume `shared-pipe`.

2. **Der Schreiber (Writer):**
   Starte einen Container ("Writer"), der alle 5 Sekunden einen Zeitstempel in eine Datei `/exchange/log.txt` schreibt.
   Nutze dazu ein Volume `shared-pipe`.

3. **Der Leser (Reader):**
   Starte einen zweiten Container ("Reader"), der diese Datei "live" mitliest (`tail -f`).
   Er muss dasselbe Volume nutzen.

4. **Beobachtung:**
   Schau dir die Logs des Readers an. Du solltest die Zeitstempel des Writers sehen.

5. **Aufräumen:**
   Stoppe beide. Wenn du den Writer löschst, kann der Reader immer noch die alten Logs lesen (solange er läuft oder das Volume existiert).

## Lernziel

Volumes entkoppeln Daten vom Lebenszyklus der Prozesse.
Container können Volumes nutzen, um asynchron Daten auszutauschen (Lose Kopplung).
