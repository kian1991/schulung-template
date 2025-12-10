---
title: "01 Build First Static Image"
---

## Szenario

Wir wollen keine fremden Nginx-Images mehr nutzen. Wir wollen unser **eigenes** Image.
Ziel: Ein Webserver, der deine persönliche Startseite ausliefert.

## Deine Mission

1. **Vorbereitung:**
   Erstelle eine `index.html` mit deinem Namen.

2. **Der Bauplan:**
   Erstelle ein `Dockerfile`.
   - Basis: Ein *kleines* Nginx Image.
   - Aktion: Kopiere deine `index.html` in das Verzeichnis, wo Nginx standardmäßig seine Daten sucht (`/usr/share/nginx/html`).

3. **Der Bau:**
   Baue das Image und tagge es als `meine-seite:v1`.

4. **Der Test:**
   Starte einen Container aus diesem Image.
   Mappe Port 8080 auf 80.
   Prüfe im Browser.

5. **Die Iteration:**
   Ändere die `index.html`.
   Starte den Container neu. Hat sich was geändert? (Spoiler: Nein! Warum?)
   Baue `meine-seite:v2` und starte einen *neuen* Container.
