---
title: "01 VS Code Dev Container"
---

## Szenario

Du willst ein Node.js Projekt starten, hast aber kein Node installiert (oder die falsche Version).
Wir nutzen VS Code, um in einem Container zu entwickeln.

## Aufgabe

1. **Projekt erstellen:**
   Erstelle einen leeren Ordner `my-dev-project`.
   Öffne ihn in VS Code.

2. **Die Config generieren:**
   - Drücke `F1` (oder `Cmd+Shift+P`).
   - Suche `Dev Containers: Add Dev Container Configuration Files...`.
   - Wähle `Node.js & TypeScript`.
   - Version: `22` (oder was aktuell ist).
   - OS: `bookworm` (Debian) oder `bullseye`.
   - Features: Wähle `Prettier` aus der Liste (suche danach).

3. **Der Neustart:**
   VS Code fragt: "Reopen in Container?". Klicke **Ja**.
   (Falls nicht: `F1` -> `Dev Containers: Reopen in Container`).

4. **Der Test:**
   Warte, bis VS Code fertig ist.
   Öffne ein Terminal in VS Code (`Ctrl+J`).
   Tippe `node -v`.
   Tippe `ls -la /`. (Du bist nicht mehr auf deinem Mac!).

5. **Die Magie:**
   Erstelle eine `index.ts`.
   Schreibe `console.log("Hello Container")`.
   Führe es aus.
