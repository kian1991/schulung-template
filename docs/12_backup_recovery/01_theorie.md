---
title: Backup und Recovery
sidebar_position: 1
---

# Backup und Recovery

## Backup-Strategien

### 3-2-1 Regel

- **3** Kopien deiner Daten
- **2** verschiedene Medien
- **1** Kopie offsite

### Backup-Typen

| Typ | Beschreibung | Vorteile | Nachteile |
|-----|--------------|----------|-----------|
| **Voll** | Alles jedes Mal | Einfache Wiederherstellung | Langsam, viel Platz |
| **Inkrementell** | Nur Änderungen seit letztem Backup | Schnell, wenig Platz | Komplexe Wiederherstellung |
| **Differentiell** | Änderungen seit letztem Voll-Backup | Mittel | Mittel |

## tar - Archive erstellen

```bash
# Archiv erstellen
tar -cvf backup.tar /home/user
# c = create, v = verbose, f = file

# Mit gzip-Kompression
tar -czvf backup.tar.gz /home/user

# Mit bzip2 (bessere Kompression)
tar -cjvf backup.tar.bz2 /home/user

# Mit xz (beste Kompression)
tar -cJvf backup.tar.xz /home/user

# Entpacken
tar -xvf backup.tar
tar -xzvf backup.tar.gz -C /ziel/

# Inhalt anzeigen
tar -tvf backup.tar.gz

# Inkrementelles Backup
tar -czvf backup.tar.gz --newer-mtime="2024-01-01" /home/
```

## rsync - Synchronisieren

```bash
# Lokal synchronisieren
rsync -av /quelle/ /ziel/
# a = archive (rekursiv, Rechte, etc.)
# v = verbose

# Mit Löschen von gelöschten Dateien
rsync -av --delete /quelle/ /ziel/

# Über SSH
rsync -av -e ssh /quelle/ user@server:/ziel/

# Trockenlauf (nur anzeigen)
rsync -av --dry-run /quelle/ /ziel/

# Fortschritt anzeigen
rsync -av --progress /quelle/ /ziel/

# Bandbreite begrenzen
rsync -av --bwlimit=1000 /quelle/ /ziel/
```

## dd - Disk Images

```bash
# Image einer Partition
sudo dd if=/dev/sda1 of=/backup/sda1.img bs=4M status=progress

# Image komprimiert
sudo dd if=/dev/sda1 bs=4M | gzip > /backup/sda1.img.gz

# Image wiederherstellen
sudo dd if=/backup/sda1.img of=/dev/sda1 bs=4M

# Komprimiertes Image wiederherstellen
gunzip -c /backup/sda1.img.gz | sudo dd of=/dev/sda1 bs=4M
```

## Automatisierung

### Mit systemd timer

```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Daily Backup

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target

# /etc/systemd/system/backup.service
[Unit]
Description=Backup Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

### Mit cron

```bash
# crontab -e
0 2 * * * /usr/local/bin/backup.sh
```

## Zusammenfassung

| Tool | Verwendung |
|------|------------|
| `tar` | Archive, lokale Backups |
| `rsync` | Synchronisation, inkrementell |
| `dd` | Disk-Images, Bit-für-Bit |

---

Weiter zum [Lab: Backup erstellen](./02_lab_backup.md)!
