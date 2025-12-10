---
title: "01 Data Persistence Basics"
---

## Szenario

Du bist der Admin einer Datenbank. Aber jedes Mal, wenn du den Server neu startest, sind alle Kundendaten weg. Dein Chef ist... unzufrieden.
Wir simulieren dieses Desaster, um zu verstehen, warum Volumes lebenswichtig sind.

## Deine Mission

1. **Der naive Versuch:**
   Starte eine Postgres-Datenbank *ohne* Volume. Setze das Passwort (`POSTGRES_PASSWORD`), aber mounte **kein** Volume.

2. **Daten erzeugen:**
   Verbinde dich in den Container (mit `docker exec`) und erstelle eine Tabelle sowie dummy Daten (z.B. Bitcoin Keys).
   Nutze `psql -U postgres`.

3. **Der Crash:**
   Lösche den Container hart (`rm -f`).

4. **Der Neustart:**
   Starte ihn exakt gleich wieder (Befehl von Schritt 1).
   Prüfe, ob die Daten noch da sind.
   *(Spoiler: Sie sind im Daten-Nirvana).*

5. **Die Lösung (Happy End):**
   Mach es diesmal richtig.
   - Erstelle ein **Volume**.
   - Starte den Container neu und binde das Volume an den richtigen Pfad (wo speichert Postgres seine Daten? -> Docker Hub Doku!).
   - Wiederhole den Insert/Delete/Restart Zyklus.
   - Überleben die Daten diesmal?

## Lernziel

Container sind **ephemeral** (vergänglich). Ihr Filesystem stirbt mit ihnen.
Volumes sind **persistent**. Sie überleben den Container-Tod.
