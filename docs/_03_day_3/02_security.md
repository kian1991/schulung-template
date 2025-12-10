---
title: "02 Container Security"
---

## Container Sicherheit

Docker ist sicher, WENN man es richtig macht. Standardmäßig sind Container aber ziemlich privilegiert.

### 1. Don't run as Root

Im Container bist du oft `root`. Wenn es eine Lücke im Container *und* im Kernel gibt, *könnte* man ausbrechen.
Besser: User im Dockerfile anlegen.

```dockerfile
RUN adduser -D myuser
USER myuser
```

### 2. Read-Only Filesystem

Wenn deine App nichts schreiben muss, verbiete es ihr.

```bash
docker run --read-only alpine
```

### 3. Capabilities droppen

Linux Root hat "Capabilities" (Netzwerk ändern, Zeit ändern, Chown, etc.). Ein Webserver braucht fast nichts davon.

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE ...
```

Das ist der Paranoia-Modus. Aber gut.

## Image Scanning

Traue niemandem. Scanne Images auf CVEs (Sicherheitslücken).

```bash
docker scan my-image
```
(Benötigt oft Snyk-Login oder Plugin).
