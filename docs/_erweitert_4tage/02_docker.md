---
title: "Lab: Container mit Docker"
sidebar_position: 2
---

# Lab: Container mit Docker

:::info Nur 4-Tage-Schulung
Dieses Modul ist Teil der 4-Tage-Schulung.
:::

---

## Docker installieren

```bash
# Abhängigkeiten
sudo apt update
sudo apt install ca-certificates curl gnupg

# Docker GPG-Key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Repository hinzufügen
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installieren
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# User zur Docker-Gruppe
sudo usermod -aG docker $USER
# Neu einloggen!

# Testen
docker run hello-world
```

---

## Aufgabe 1: Erster Container

```bash
# hello-world
docker run hello-world

# Interaktiv mit Ubuntu
docker run -it ubuntu bash
# exit zum Beenden
```

---

## Aufgabe 2: Nginx Container

```bash
# Nginx starten
docker run -d -p 8080:80 --name webserver nginx

# Status prüfen
docker ps

# Im Browser oder curl testen
curl http://localhost:8080

# Logs anzeigen
docker logs webserver

# Stoppen und entfernen
docker stop webserver
docker rm webserver
```

---

## Aufgabe 3: In Container einloggen

```bash
# Container starten
docker run -d --name mycontainer nginx

# Shell im laufenden Container
docker exec -it mycontainer bash

# Dateien anschauen
ls /usr/share/nginx/html/
cat /etc/nginx/nginx.conf

# Verlassen
exit
```

---

## Aufgabe 4: Volumes (persistente Daten)

```bash
# Mit Volume
docker run -d -p 8080:80 \
  -v $(pwd)/html:/usr/share/nginx/html \
  --name webserver nginx

# Lokale Datei erstellen
echo "<h1>Meine Webseite</h1>" > html/index.html

# Testen
curl http://localhost:8080
```

---

## Aufgabe 5: Einfaches Dockerfile

```dockerfile
# Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
```

```bash
# index.html erstellen
echo "<h1>Mein Image</h1>" > index.html

# Image bauen
docker build -t mein-nginx .

# Container starten
docker run -d -p 8080:80 mein-nginx

# Testen
curl http://localhost:8080
```

---

## Docker-Befehle Übersicht

| Befehl | Funktion |
|--------|----------|
| `docker run` | Container starten |
| `docker ps` | Laufende Container |
| `docker ps -a` | Alle Container |
| `docker stop` | Container stoppen |
| `docker rm` | Container löschen |
| `docker images` | Images auflisten |
| `docker rmi` | Image löschen |
| `docker logs` | Container-Logs |
| `docker exec -it` | In Container |
| `docker build` | Image bauen |

---

## Podman (Kurzer Hinweis)

**Podman** ist eine Docker-Alternative ohne Daemon:

```bash
# Installation
sudo apt install podman

# Gleiche Befehle wie Docker!
podman run hello-world
podman ps
```

Vorteile: Rootless, kein Daemon, Docker-kompatibel.
