---
title: "03 Volume Backups & Sidecars"
---

## Szenario

Du hast einen Container ("Blackbox"), der wichtige Daten in ein Volume schreibt.
Aber: Der Container hat keine Shell (`/bin/sh` fehlt). Du kommst nicht mit `docker exec` rein.
Wie kommst du an die Daten, um ein Backup zu machen?

## Deine Mission

Wir klauen die Daten aus dem Hintereingang.

1. **Das Setup:**
   Erstelle ein Volume `tresor` und befülle es mit einer Datei `gold.txt` (HINT: Nutze einen temporären Container dazu).

2. **Das Problem:**
   Stell dir vor, der `tresor` ist jetzt an einen Container gebunden, in den du nicht reinkommst (z.B. ein geschlossener App-Server).

3. **Der Einbruch (Sidecar Pattern):**
   Wir starten einen **zweiten** Container (unseren Fluchtwagen), der *ebenfalls* das Volume `tresor` mountet.
   Zusätzlich mounten wir das aktuelle Verzeichnis (`.`), um die Beute sichern zu können.

   Ziel: Erstelle ein `.tar` Archiv vom Volume-Inhalt und speichere es auf deinem Host.
   Tipp: `tar cvf /backup/beute.tar /pfad/im/container`.

4. **Der Check:**
   Schau in dein aktuelles Verzeichnis. Da sollte jetzt `beute.tar` liegen.
   Entpacke es. Hast du die Goldbarren?

## Lernziel

Daten gehören nicht dem Container, sondern dem Volume.
Du kannst Volumes an beliebig viele Container gleichzeitig hängen.
Das ist der Standard-Weg, um Backups von Docker-Volumes zu machen: Ein temporärer "Sidecar"-Container, der das Volume liest und ein Tarball schreibt.
