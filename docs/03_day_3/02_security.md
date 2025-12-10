---
title: "02 Container Security"
---

## Container Sicherheit

Docker ist sicher, **WENN** man es richtig macht. Standardmäßig sind Container aber ziemlich "mächtig".
Sie laufen als `root` und dürfen fast alles, was der Kernel erlaubt.

### 1. Don't run as Root

Im Container bist du oft `root` (UID 0).
Wenn es eine Sicherheitslücke im Container-Prozess *und* im Kernel gibt, kann ein Angreifer ausbrechen (Container Breakout).

**Best Practice:** Lege einen User im Dockerfile an.

```dockerfile
# 1. User anlegen
RUN adduser -D myuser
# 2. Zu User wechseln
USER myuser
```
Jeder Befehl danach (CMD, RUN) läuft als `myuser`.
Achtung: Du kannst dann keine Pakete mehr installieren (`apk add` braucht root) oder auf geschützte Ports (< 1024) binden!

### 2. Read-Only Filesystem

Ein Webserver muss meistens nichts schreiben. Warum also erlauben?
Wenn ein Hacker rein kommt, kann er so keine Backdoors (Skripte) ablegen.

```bash
docker run --read-only nginx:alpine
```
(Achtung: Nginx will oft in `/var/cache` oder `/var/run` schreiben. Dafür musst du dann dedizierte Volumes/Tmpfs mounten).

### 3. Capabilities (Die Superkräfte)

Linux "Root" ist eigentlich eine Sammlung von Fähigkeiten (Capabilities):
- `CAP_CHOWN`: Darf Dateien anderen gehören lassen.
- `CAP_NET_BIND_SERVICE`: Darf Ports < 1024 öffnen.
- `CAP_SYS_TIME`: Darf die Uhrzeit ändern.

Docker gibt dem Container standardmäßig eine Untermenge davon. Aber oft immer noch zu viel.

**Der Paranoia-Modus:** Nimm ALLE weg und gib nur das Nötigste zurück.

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
```

### 4. Image Scanning

Woher kommt dein Image?
Scanne Images regelmäßig auf bekannte Sicherheitslücken (CVEs).

```bash
# integriert:
docker scout quickview my-image
```
Das zeigt dir: "Achtung, deine `openssl` Library ist veraltet." -> Update das Base Image!
