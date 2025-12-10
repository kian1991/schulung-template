---
title: "03 Environment Variables & Entrypoints"
---

## Szenario

Container müssen zur Laufzeit konfigurierbar sein, ohne das Image neu zu bauen.
Wir erstellen ein Python-Skript, das sich über Environment Variables steuern lässt.

## Aufgabe

1. **Python Script (`app.py`):**
   Schreibe ein Skript, das eine ENV Variable `TARGET` ausliest.
   - Wenn gesetzt: "Hello [TARGET]"
   - Wenn nicht gesetzt: "Hello World"

2. **Dockerfile:**
   - Base Image: `python:slim`
   - Kopiere das Skript.
   - Definiere einen Default-Wert für `TARGET` mittels `ENV`.
   - Setze `CMD` um das Skript zu starten.

3. **Verifikation:**
   - Starte Container ohne Parameter -> Erwartet: Default Wert.
   - Starte Container mit `-e TARGET=Schulung` -> Erwartet: "Hello Schulung".

4. **Reflexion (Shell vs. Exec Form):**
   Du hast `CMD python app.py` (Shell Form) und `CMD ["python", "app.py"]` (Exec Form) probiert.
   
   **Beobachtung:**
   Beim Stoppen von Shell-Form Containern dauert es oft 10 Sekunden. Warum?
   
   **Erklärung:**
   - **Shell Form:** `bin/sh -c python app.py`. Dein Prozess ist nicht PID 1, sondern ein Child der Shell. `docker stop` sendet SIGTERM an die Shell.
     Die Bourne-Shell (sh) fängt SIGTERM häufig ab, beendet sich selbst, leitet es aber nicht automatisch an Child-Prozesse weiter.
     Das führt dazu, dass dein Python-Prozess einfach weiterläuft, Docker wartet das Default-Grace-Period-Timeout (10 Sekunden) und schickt dann SIGKILL.
   - **Exec Form:** Dein Prozess IST PID 1. Er bekommt das Signal direkt und kann sauber runterfahren.
   
   -> **Learning:** Nutze immer die `["JSON", "Array"]` Syntax für `CMD` und `ENTRYPOINT`!

5. **Deep Dive (Optional):**
   Nutze `ENTRYPOINT` statt `CMD` und versuche Argumente an das Skript zu übergeben.
   Was passiert bei `docker run ... mein_arg`?

