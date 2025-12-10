---
title: "06 Entrypoint Jailbreak"
---

## Szenario

Du hast ein Image eines Drittanbieters bekommen: `locked-image`.
Es ist so konfiguriert, dass es beim Starten sofort ein Python-Skript ausführt und sich danach beendet.
Du musst aber wissen, wie der Quellcode in `/app/server.py` aussieht.

Da das Skript sofort startet (via ENTRYPOINT), kommst du mit `docker run locked-image ls -la` nicht weiter. Docker versucht dann nämlich `python server.py ls -la` auszuführen – und das Skript stürzt ab.

Wie brichst du aus?

## Deine Mission

1. **Das Gefängnis bauen:**
   Erstelle ein `Dockerfile`:
   ```dockerfile
   FROM python:alpine
   WORKDIR /app
   RUN echo "print('Ich bin eine Blackbox. Du kommst hier nicht rein!')" > server.py
   ENTRYPOINT ["python", "server.py"]
   ```
   Baue es: `docker build -t locked-image .`

2. **Der naive Versuch:**
   Versuche, den Inhalt zu listen:
   `docker run locked-image ls -la`
   -> Fehlschlag! 

3. **Der Jailbreak**

   Versuche dich selbst dran. überlege was wir im Unterricht besprochen haben.

