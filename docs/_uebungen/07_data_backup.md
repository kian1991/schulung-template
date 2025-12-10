---
title: "Übung 7: Daten-Umzug (Volume Backup)"
---

## Szenario

Du hast eine wichtige Datenbank in einem Volume `old-data`.
Du willst auf einen neuen Server umziehen (oder einfach ein Backup haben).
Da Volumes "irgendwo" in `/var/lib/docker` liegen, kannst du sie nicht einfach kopieren.

### Setup

Erstelle das Volume und fülle es mit Daten:

```bash
docker volume create old-data
docker run --rm -v old-data:/data alpine sh -c "echo 'Wichtige Kundenliste' > /data/db.txt"
```

### Aufgabe

1. Erstelle ein Tar-Archiv `backup.tar` vom Inhalt des Volumes.
2. Tipp: Du musst einen Container starten, der das Volume *und* den aktuellen Ordner mountet.

<details>
<summary>Lösung</summary>

Der Trick: Wir mounten `old-data` nach `/mnt/data` UND unser aktuelles Verzeichnis (`$(pwd)`) nach `/backup`. Dann taren wir von `/mnt` nach `/backup`.

```bash
docker run --rm \
  -v old-data:/mnt/data \
  -v "$(pwd):/backup" \
  alpine \
  tar cvf /backup/backup.tar /mnt/data
```

Prüfe es:
`ls -lh backup.tar`

Um es wiederherzustellen (Restore), würdest du `tar xvf` nutzen.
</details>

### Aufgabe 2: Der Restore

Du hast alles gelöscht!
1. Erstelle ein NEUES Volume `restored-data`.
2. Nutze dein `backup.tar` (aus Aufgabe 1), um die Daten in das neue Volume zu entpacken.
3. Verifiziere, dass `db.txt` wieder da ist.

### Aufgabe 3: Volume Klonen

Manchmal will man Testdaten aus der Produktion klonen.
1. Erstelle ein Volume `prod-data` und schreibe Daten rein.
2. Kopiere den Inhalt von `prod-data` direkt in ein neues Volume `test-data` (On-the-fly, ohne Zwischen-Tar).
3. Tipp: Nutze `cp` inside einem Container, der beide Volumes mountet.
