---
title: "02 Layer Caching Strategy"
---

## Szenario

Ein Kollege beschwert sich: "Mein Build dauert ewig, obwohl ich nur eine Zeile Code geändert habe!".
Dein Job: Fixe das Dockerfile.

## Deine Mission

Gegeben ist dieses (schlechte) Dockerfile für eine Node.js App:

```dockerfile
FROM node:alpine
WORKDIR /app
COPY . .
RUN npm install
CMD ["node", "server.js"]
```

Warum ist das schlecht?
Jedes Mal, wenn du auch nur *buchstaben* im Code änderst, invalidiert Docker den Cache für `COPY . .`.
Dadurch wird auch der **nächste** Schritt (`RUN npm install`) neu ausgeführt. Das dauert Minuten!

**Aufgabe:**
Optimiere das Dockerfile so, dass `npm install` **nur** läuft, wenn sich wirklich die Dependencies (`package.json`) ändern.
Änderungen am Source Code (`server.js`) sollen super schnell gehen.

**Test & Reflexion:**
1. Erstelle dummy files (`package.json`, `server.js`).
2. Baue das Image mit dem schlechten Dockerfile. Ändere `server.js`. Baue erneut. Beobachte die Zeit.
3. Baue das Image mit deinem optimierten Dockerfile. Ändere `server.js`. Baue erneut.

**Frage dich:**
- Warum ist `COPY . .` vor `RUN npm install` "tödlich" für die Build-Zeit?
- Was genau schaut sich Docker an, um zu entscheiden, ob ein Layer aus dem Cache kommt? (Checksumme der Dateien!).
- Wenn du `package.json` änderst: Muss `npm install` laufen? (Ja).
- Wenn du `server.js` änderst: Muss `npm install` laufen? (Nein - aber im schlechten Dockerfile tut es das trotzdem).
