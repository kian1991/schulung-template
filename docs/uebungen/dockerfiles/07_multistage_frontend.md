---
title: "07 The Frontend Pipeline"
---

## Szenario

Wir simulieren eine moderne Web-Entwicklung.
Du hast eine Single-Page-Application (SPA), die gebaut ("transpiliert") werden muss.
Am Ende fallen HTML/CSS/JS Dateien heraus. Diese sollen von einem Nginx ausgeliefert werden.

Node.js hat in der Produktion **nichts verloren**.

## Deine Mission

1. **Die Fake-App:**
   Wir tun so, als hätten wir eine komplexe React-App.
   Erstelle eine Datei `builder.sh`:
   ```bash
   #!/bin/sh
   mkdir dist
   echo "<h1>Hello from React (Fake)</h1>" > dist/index.html
   echo "Build fertig!"
   ```
   (In der Realität wäre das `npm run build`).

2. **Das Dockerfile:**
   Nutze Multi-Stage!

   **Stage 1: Build (Node)**
   - Base: `node:alpine`
   - Name: `builder`
   - Kopiere das Script.
   - Führe es aus (`RUN sh builder.sh`).
   
   **Stage 2: Serve (Nginx)**
   - Base: `nginx:alpine`
   - Kopiere den Ordner `dist` aus der Stage `builder` in das Nginx HTML Verzeichnis (`/usr/share/nginx/html`).

3. **Der Beweis:**
   - Baue das Image.
   - Starte es auf Port 8080.
   - Öffne den Browser.
   - Geh in den Container (`docker exec -it ... sh`) und versuche `node -v` oder `npm -v`.
   - Wenn du "Command not found" siehst: **Perfekt**. Du hast erfolgreich alle Spuren des Build-Tools verwischt.

## Lernziel
Produktions-Images enthalten **nur** das Ergebnis (Artefakt), nicht das Werkzeug.
