---
title: "03 Image Basics"
---

## Images vs. Container

Ein **Image** ist die Schablone (read-only). Ein **Container** ist die laufende Instanz (read-write).

> Denk an eine Klasse und ein Objekt in der Programmierung. Oder an ein Rezept und das gekochte Gericht.

## Der Docker Hub

Der [Docker Hub](https://hub.docker.com) ist die Standard-Registry. Jedes Image hat einen Namen:

`vendor/image:tag`

- **Vendor:** Wer hat es gebaut? (Bei offiziellen Images wie `node` oder `python` fehlt das).
- **Image:** Der Name der Software.
- **Tag:** Die Version.

### Images ziehen

```bash
# Zieht das offizielle Nginx Image (latest Version)
docker pull nginx

# Zieht eine spezifische Version (Best Practice!)
docker pull nginx:1.25-alpine
```

:::warning[Don't use latest]
Verwende in Produktion niemals `:latest`. Das ist ein bewegliches Ziel. Nutze immer konkrete Versionen (z.B. `:1.25`) oder Hashes, um reproduzierbare Builds zu garantieren. -> **ACHTUNG:** In diesem Kurs nutzen wir `latest`, damit es einfacher ist. In Echt: Pinnen!
:::

## Image CLI

Wichtige Befehle für den Alltag:

```bash
# Was habe ich lokal?
docker image ls

# Details ansehen (Env Vars, Ports, Layers)
docker inspect nginx:alpine

# Aufräumen (Löscht ungenutzte Images)
docker image prune
```

## Layers & Caching

Ein Image besteht aus **Schichten (Layers)**.

```bash
docker history nginx:alpine
```

Du siehst, dass das Image aus vielen kleinen Änderungen besteht. Der Vorteil: Wenn zwei Images (z.B. zwei verschiedene Node-Apps) auf dem gleichen Base-Image basieren, wird dieses **nur einmal** auf der Festplatte gespeichert.

:::info[Copy-on-Write]
Wenn du einen Container startest, legt Docker eine dünne Schreib-Schicht oben drauf. Das Image darunter bleibt unverändert.
:::

## Exkurs: Alpine Linux

Du wirst oft Images sehen, die auf `alpine` basieren (z.B. `node:alpine`).
Alpine Linux ist eine extrem leichtgewichtige Distribution (ca. 5MB!).

### Warum Alpine?
- **Größe:** Winzig im Vergleich zu Ubuntu (ca. 80MB) oder Debian (ca. 120MB).
- **Sicherheit:** Weniger installierte Software = weniger Angriffsfläche.
- **Speed:** Schnellerer Download und Start.

### Software installieren
Alpine nutzt nicht `apt`, sondern `apk`.

```dockerfile
# So installierst du curl in Alpine
RUN apk add --no-cache curl
```

:::tip[--no-cache]
Nutze immer `--no-cache`. Das verhindert, dass der lokale Paket-Index (`/var/cache/apk/*`) im Image gespeichert wird. Das spart Platz! Bei `apt` müsstest du `apt-get update && apt-get install ... && rm -rf /var/lib/apt/lists/*` machen. Alpine macht es dir leichter.
:::
