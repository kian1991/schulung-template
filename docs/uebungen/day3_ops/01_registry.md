---
title: "01 The Local Registry"
---

## Aufgabe

Wir simulieren eine Firmen-Umgebung. Du sollst Images in eine "private" Registry pushen.

1. **Starte die Registry:**
   ```bash
   docker run -d -p 5000:5000 --restart=always -v registry-data:/var/lib/registry --name registry registry:3
   ```

2. **Tag & Push:**
   - Ziehe `alpine` (oder nimm ein existierendes Image).
   - Tagge es um zu `localhost:5000/my-alpine:v1`.
   - Pushe es.

3. **Verify:**
   - Lösche das lokale Image (`docker rmi localhost:5000/my-alpine:v1`).
   - Pulle es wieder (`docker pull ...`).

4. **Für Mutige (Insecure Registry):**
   - Wenn du mit einem Nachbarn zusammenarbeitest (und im gleichen WLAN bist):
     - Versuche SEIN Image zu pullen (`docker pull SEINE_IP:5000/...`).
     - Es wird fehlschlagen ("http response to https client").
     - Konfiguriere die `insecure-registries` in Docker Desktop/Engine, damit es klappt.
