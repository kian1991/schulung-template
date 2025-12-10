---
title: "04 Multi-Stage Builds"
---

## Szenario

Wir optimieren die Image-Größe für eine Go-Applikation durch Trennung von Build- und Runtime-Umgebung.

## Aufgabe

1. **Source Code (`main.go`):**
   Erstelle eine minimale Go "Hello World" App.

2. **Naive Implementierung (Single Stage):**
   - Nutze `golang:latest`.
   - Kopiere Code und führe `go build` aus.
   - Prüfe die Image Größe (`docker images`).

3. **Optimierte Implementierung (Multi-Stage):**
   - **Stage 1 (Builder):** `golang:latest`. Kompilliere das Binary.
   - **Stage 2 (Runtime):** `alpine` oder `scratch`.
   - Kopiere nur das Binary von Stage 1 nach Stage 2.

4. **Vergleich & Reflexion:**
   Baue beide Images (Fat & Slim).
   
   **Frage dich:**
   - Warum reicht es nicht, im "Fat Build" am Ende einfach `RUN rm -rf ./go-code` zu machen?
   - Antwort: Weil Docker Images **Layer** sind. Die Daten sind im vorherigen Layer immer noch da (wie im Git History). Nur Multi-Stage "vergisst" die History wirklich.
