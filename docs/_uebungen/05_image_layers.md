---
title: "Übung 5: Layer Puzzle"
---

## Szenario

Du hast ein Dockerfile, aber der Build dauert ewig, obwohl du nur eine kleine Datei änderst.
Finde den Fehler im Caching.

### Das schlechte Dockerfile

```dockerfile
FROM ubuntu:latest
COPY . .
RUN apt-get update && apt-get install -y python3
CMD ["python3", "app.py"]
```

### Aufgabe

1. Warum ist dieses Dockerfile "langsam" bei Änderungen an der `app.py`?
2. Schreibe es um, damit `apt-get install` getached werden kann.

<details>
<summary>Lösung</summary>

**Analyse:**
`COPY . .` kopiert ALLES in den Container. Wenn sich *irgendeine* Datei ändert, ist dieser Layer neu.
Alle folgenden Layer (`RUN apt-get ...`) müssen neu ausgeführt werden. Das Installieren dauert lange.

**Optimierung:**
Verschiebe das, was sich selten ändert (Dependencies), nach oben. Das, was sich oft ändert (Code), nach unten.

```dockerfile
FROM ubuntu:latest

# 1. Dependencies installieren (Ändert sich fast nie -> Cache Hit!)
RUN apt-get update && apt-get install -y python3

# 2. Code kopieren (Ändert sich oft -> Nur dieser Layer läuft neu)
COPY . .

CMD ["python3", "app.py"]
```
</details>

### Aufgabe 2: Der Müllschlucker

1. Erstelle eine Datei `secrets.txt` und `node_modules` (Ordner) in deinem Build-Verzeichnis.
2. Baue das Image.
3. Prüfe mit `docker run --rm <image> ls -la`, ob die Dateien im Image sind. (Spoiler: Ja).
4. Erstelle eine `.dockerignore`, um das zu verhindern.

### Aufgabe 3: Detektivarbeit

1. Ziehe dir das Image `python:slim`.
2. Finde heraus, wie groß das Image ist und wie viele Layer es hat.
3. Nutze [`docker history`](https://docs.docker.com/reference/cli/docker/image/history/) `--no-trunc python:slim`, um genau zu sehen, welcher Befehl wie viel Platz verbraucht hat.
