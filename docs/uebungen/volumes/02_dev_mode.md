---
title: "02 Bind Mounts for Development"
---

## Szenario

Du bist Web-Entwickler. Du hast keine Lust, nach jeder Änderung im HTML-Code ein neues Docker Image zu bauen (`docker build ...`). Das dauert Minuten!
Du willst **Instant Feedback**.

## Deine Mission

Wir bauen ein Setup, bei dem deine Datei auf dem Laptop **direkt** im Container landet.

1. **Vorbereitung:**
   Erstelle einen Ordner `my-website` und darin eine `index.html`.
   ```html
   <h1>Hallo Docker!</h1>
   ```

2. **Der Tunnel (Bind Mount):**
   Starte einen Nginx Webserver. Aber statt den Content hineinzukopieren, "tunneln" wir ihn.
   
   Nutze einen **Bind Mount**.
   - Host-Pfad: Dein `my-website` Ordner.
   - Container-Pfad: `/usr/share/nginx/html` (Standard Nginx DocRoot).

   Probiere es aus!

3. **Der Test:**
   Öffne `http://localhost:8080`. Du siehst "Hallo Docker!".

4. **Die Magie:**
   Lass den Container laufen!
   Öffne deine lokale `index.html` in VS Code.
   Ändere den Text zu "Hallo Kian!". Speichere.
   
   Drücke im Browser F5.

5. **Analyse:**
   Warum musste der Container nicht neu starten?
   Weil er gar keine eigene Kopie der Datei hat. Er schaut direkt auf deine Festplatte!

## Lernziel

**Bind Mounts** verbinden Host und Container in Echtzeit. Perfekt für Development.
Verwende sie niemals für persistente Datenbank-Daten in Produktion (Performance/Permissions Probleme), aber liebe sie für Code!
