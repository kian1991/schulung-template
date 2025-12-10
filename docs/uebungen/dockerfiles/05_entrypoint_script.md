---
title: "05 The Entrypoint Script"
---

## Szenario

Wir bauen eine App, die nur startet, wenn eine bestimmte Datei `.verified` existiert.
Wenn sie fehlt, soll das Entrypoint-Script sie erstellen und erst dann die App starten.
Das simuliert "Datenbank-Initialisierung" oder "Config-Checks".

## Deine Mission

1. **Die App:**
   Ein simples Shell-Script `app.sh`, das nur sagt: "Ich laufe!".
   ```bash
   #!/bin/sh
   echo "App gestartet: Ich laufe!"
   ```
   Mach es ausführbar (`chmod +x`).

2. **Das Entrypoint Script (`init.sh`):**
   Schreibe ein Shell-Script:
   - Prüfe, ob `/data/verified` existiert.
   - Wenn nein: Schreibe "Initialisiere..." und erstelle die Datei (`touch`).
   - Wenn ja: Schreibe "Bereits initialisiert.".
   - Am Ende: Führe den eigentlichen Befehl aus (`exec "$@"`).

3. **Das Dockerfile:**
   - Base `alpine`.
   - Kopiere beide Scripts nach `/app/`.
   - Mach sie ausführbar (`RUN chmod +x ...`).
   - Setze `ENTRYPOINT ["/app/init.sh"]`.
   - Setze `CMD ["/app/app.sh"]`.

4. **Der Test:**
   - Starte den Container das erste Mal (mounte ein Volume nach `/data`!).
   - Du solltest "Initialisiere..." sehen, dann "App gestartet".
   - Stoppe ihn und starte ihn neu (Volume behalten).
   - Du solltest "Bereits initialisiert" sehen.

**Lernziel:** Logik *vor* dem App-Start kapseln.
