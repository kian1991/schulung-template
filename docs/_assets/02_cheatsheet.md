---
title: Linux Cheatsheet
sidebar_position: 2
---

# Linux Admin Cheatsheet

Quick Reference für die wichtigsten Befehle.

## Navigation & Dateien

```bash
pwd                     # Aktuelles Verzeichnis
cd /path                # Verzeichnis wechseln
cd ~                    # Home
cd -                    # Vorheriges Verzeichnis
ls -la                  # Dateien auflisten
tree                    # Verzeichnisbaum

cp quelle ziel          # Kopieren
mv quelle ziel          # Verschieben/Umbenennen
rm datei                # Löschen
rm -rf verzeichnis      # Rekursiv löschen
mkdir -p a/b/c          # Verzeichnis (mit Eltern)
touch datei             # Leere Datei

cat datei               # Inhalt anzeigen
head -n 10 datei        # Erste 10 Zeilen
tail -n 10 datei        # Letzte 10 Zeilen
tail -f datei           # Live folgen
less datei              # Pager
grep "text" datei       # Suchen
find /path -name "*.txt"  # Dateien finden
```

## Paketverwaltung (apt)

```bash
sudo apt update          # Paketlisten aktualisieren
sudo apt upgrade         # Pakete upgraden
sudo apt install paket   # Installieren
sudo apt remove paket    # Entfernen
sudo apt purge paket     # Vollständig entfernen
sudo apt autoremove      # Aufräumen
apt search name          # Suchen
apt show paket           # Info
dpkg -l                  # Installierte Pakete
dpkg -S /pfad/datei      # Datei → Paket
dpkg -L paket            # Paket → Dateien
```

## Prozesse

```bash
ps aux                   # Alle Prozesse
ps aux | grep name       # Prozess finden
pstree                   # Prozessbaum
top / htop               # Interaktiv
kill PID                 # SIGTERM
kill -9 PID              # SIGKILL
pkill name               # Nach Name beenden
jobs                     # Hintergrund-Jobs
bg / fg                  # Hintergrund/Vordergrund
nohup cmd &              # Überlebt Logout
```

## Benutzer & Gruppen

```bash
useradd -m -s /bin/bash user    # User anlegen
userdel -r user                  # User löschen
passwd user                      # Passwort setzen
usermod -aG gruppe user          # Zu Gruppe hinzufügen
groups user                      # Gruppen anzeigen
id user                          # UID/GID
su - user                        # User wechseln
sudo -i                          # Root-Shell
```

## Berechtigungen

```bash
chmod 755 datei          # rwxr-xr-x
chmod u+x datei          # Execute für Owner
chmod -R 644 verz/       # Rekursiv
chown user:group datei   # Besitzer ändern
chown -R user:group verz/
```

## Netzwerk

```bash
ip addr                  # IP-Adressen
ip route                 # Routing
nmcli con show           # Verbindungen
nmcli con up name        # Aktivieren
ping host                # Erreichbarkeit
ss -tulpn                # Offene Ports
dig domain               # DNS-Abfrage
curl url                 # HTTP-Request
```

## Firewall (ufw)

```bash
sudo ufw status          # Status
sudo ufw enable          # Aktivieren
sudo ufw allow 22        # Port erlauben
sudo ufw allow ssh       # Service erlauben
sudo ufw deny 80         # Port blockieren
sudo ufw delete allow 22 # Regel löschen
```

## Speicher & Dateisysteme

```bash
df -h                    # Dateisystem-Belegung
du -sh verzeichnis       # Verzeichnisgröße
lsblk                    # Blockgeräte
fdisk -l                 # Partitionen
mount /dev/sdb1 /mnt     # Mounten
umount /mnt              # Unmounten
mkfs.ext4 /dev/sdb1      # Formatieren
```

## LVM

```bash
pvcreate /dev/sdb        # Physical Volume
vgcreate vg /dev/sdb     # Volume Group
lvcreate -n lv -L 5G vg  # Logical Volume
lvextend -L +1G /dev/vg/lv  # Vergrößern
resize2fs /dev/vg/lv     # Dateisystem anpassen
pvs / vgs / lvs          # Übersicht
```

## RAID (mdadm)

```bash
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sd[bcd]
cat /proc/mdstat         # Status
mdadm --detail /dev/md0
mdadm /dev/md0 --fail /dev/sdc   # Defekt markieren
mdadm /dev/md0 --remove /dev/sdc
mdadm /dev/md0 --add /dev/sdd    # Hinzufügen
```

## Systemd

```bash
systemctl status service
systemctl start service
systemctl stop service
systemctl restart service
systemctl enable service  # Beim Boot starten
systemctl disable service
systemctl daemon-reload   # Nach Unit-Änderung
journalctl -u service     # Logs
journalctl -f             # Live
```

## Logging

```bash
journalctl               # Alle Logs
journalctl -u service    # Service-Logs
journalctl -b            # Seit Boot
journalctl -p err        # Nur Fehler
journalctl --since "1 hour ago"
tail -f /var/log/syslog
```

## Backup

```bash
tar -czvf backup.tar.gz /path   # Archiv erstellen
tar -xzvf backup.tar.gz         # Entpacken
tar -tzvf backup.tar.gz         # Inhalt anzeigen
rsync -av quelle/ ziel/         # Synchronisieren
rsync -av -e ssh quelle/ host:ziel/
```

## SSH

```bash
ssh user@host            # Verbinden
ssh -p 2222 user@host    # Anderer Port
ssh-keygen -t ed25519    # Schlüssel erstellen
ssh-copy-id user@host    # Key kopieren
scp datei user@host:/pfad
```

## Hilfe

```bash
man befehl               # Manpage
befehl --help            # Kurzhelp
apropos keyword          # Suche in Manpages
```

## Tastenkürzel

| Kürzel | Funktion |
|--------|----------|
| `Ctrl+C` | Abbrechen |
| `Ctrl+Z` | Stoppen (suspend) |
| `Ctrl+D` | EOF / Logout |
| `Ctrl+L` | Bildschirm löschen |
| `Ctrl+R` | History-Suche |
| `Tab` | Autovervollständigung |
| `!!` | Letzten Befehl wiederholen |
| `!$` | Letztes Argument |
