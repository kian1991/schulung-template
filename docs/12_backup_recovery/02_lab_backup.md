---
title: "Lab: Backup und Recovery"
sidebar_position: 2
---

# Lab: Backup und Recovery

:::info Zeitrahmen
**Dauer:** ca. 2 Stunden
:::

---

## Aufgabe 1: tar-Backup erstellen

1. Erstelle ein tar.gz Backup von /etc
2. Zeige den Inhalt an
3. Entpacke in /tmp

<details>
<summary>Lösung anzeigen</summary>

```bash
# Backup erstellen
sudo tar -czvf ~/etc_backup.tar.gz /etc

# Inhalt anzeigen
tar -tzvf ~/etc_backup.tar.gz | head -20

# Entpacken
mkdir /tmp/restore
tar -xzvf ~/etc_backup.tar.gz -C /tmp/restore
ls /tmp/restore/etc
```

</details>

---

## Aufgabe 2: rsync lokal

1. Erstelle Testdaten
2. Synchronisiere mit rsync
3. Ändere Dateien und synchronisiere erneut

<details>
<summary>Lösung anzeigen</summary>

```bash
# Testdaten
mkdir -p ~/source ~/backup
echo "test1" > ~/source/file1.txt
echo "test2" > ~/source/file2.txt

# Erste Synchronisation
rsync -av ~/source/ ~/backup/

# Änderung
echo "geändert" >> ~/source/file1.txt
touch ~/source/file3.txt

# Erneut synchronisieren
rsync -av ~/source/ ~/backup/
# Nur file1.txt und file3.txt werden kopiert
```

</details>

---

## Aufgabe 3: rsync über SSH

1. Synchronisiere nach localhost (als Test)
2. Nutze --dry-run zum Testen

<details>
<summary>Lösung anzeigen</summary>

```bash
# Trockenlauf
rsync -av --dry-run ~/source/ localhost:~/remote_backup/

# Wirklich synchronisieren
rsync -av -e ssh ~/source/ localhost:~/remote_backup/

# Mit Fortschritt
rsync -av --progress ~/source/ localhost:~/remote_backup/
```

</details>

---

## Aufgabe 4: Inkrementelles tar-Backup

1. Erstelle ein Voll-Backup
2. Ändere Dateien
3. Erstelle inkrementelles Backup

<details>
<summary>Lösung anzeigen</summary>

```bash
# Snapshot-Datei für inkrementelles Backup
mkdir -p ~/backups

# Voll-Backup
tar -cvzf ~/backups/full.tar.gz --listed-incremental=~/backups/snapshot ~/source/

# Änderungen
echo "neu" > ~/source/file4.txt

# Inkrementelles Backup
tar -cvzf ~/backups/incr1.tar.gz --listed-incremental=~/backups/snapshot ~/source/
# Nur neue/geänderte Dateien werden gesichert

# Zur Wiederherstellung: erst full, dann incr1
```

</details>

---

## Aufgabe 5: Backup-Skript

Erstelle ein einfaches Backup-Skript:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash
# /usr/local/bin/backup.sh

SOURCE="/home"
DEST="/backup"
DATE=$(date +%Y%m%d)
LOG="/var/log/backup.log"

echo "=== Backup Start: $(date) ===" >> "$LOG"

# Backup erstellen
tar -czvf "$DEST/home_$DATE.tar.gz" "$SOURCE" 2>> "$LOG"

if [ $? -eq 0 ]; then
    echo "Backup erfolgreich: home_$DATE.tar.gz" >> "$LOG"
else
    echo "FEHLER beim Backup!" >> "$LOG"
fi

# Alte Backups löschen (älter als 7 Tage)
find "$DEST" -name "*.tar.gz" -mtime +7 -delete

echo "=== Backup Ende: $(date) ===" >> "$LOG"
```

```bash
sudo mkdir -p /backup
sudo chmod +x /usr/local/bin/backup.sh
sudo /usr/local/bin/backup.sh
```

</details>

---

## Aufgabe 6: Backup mit systemd timer

1. Erstelle Timer und Service
2. Aktiviere den Timer
3. Prüfe wann das nächste Backup läuft

<details>
<summary>Lösung anzeigen</summary>

```bash
# Service
sudo nano /etc/systemd/system/backup.service
[Unit]
Description=Daily Backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh

# Timer
sudo nano /etc/systemd/system/backup.timer
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target

# Aktivieren
sudo systemctl daemon-reload
sudo systemctl enable --now backup.timer

# Status
systemctl list-timers | grep backup
```

</details>

---

## Aufgabe 7: Recovery testen

Stelle Dateien aus dem Backup wieder her:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Einzelne Datei aus tar extrahieren
tar -xzvf ~/backups/full.tar.gz -C /tmp home/user/source/file1.txt

# Alles wiederherstellen
mkdir /tmp/full_restore
tar -xzvf ~/backups/full.tar.gz -C /tmp/full_restore

# Mit rsync wiederherstellen
rsync -av ~/backup/ ~/source_restored/
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- tar für Archive nutzen
- rsync für Synchronisation
- Inkrementelle Backups
- Backup-Automatisierung
- Recovery-Prozesse

---

Weiter zu [Sicherheit](../13_sicherheit/01_theorie.md)!
