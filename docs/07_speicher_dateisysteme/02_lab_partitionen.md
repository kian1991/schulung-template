---
title: "Lab: Partitionieren und Formatieren"
sidebar_position: 2
---

# Lab: Partitionieren und Formatieren

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

:::warning Virtuelle Festplatten nutzen!
Führe diese Übungen nur auf den zusätzlichen virtuellen Festplatten durch, NICHT auf der Systemfestplatte!
:::

---

## Vorbereitung

Stelle sicher, dass du zusätzliche virtuelle Festplatten hast:

```bash
lsblk
# Du solltest sdb, sdc, etc. sehen
```

Falls nicht, füge in VirtualBox neue Festplatten hinzu (siehe VM-Setup).

---

## Aufgabe 1: Festplatten identifizieren

1. Liste alle Blockgeräte auf
2. Zeige Details mit Dateisystem-Typ
3. Identifiziere die leeren Festplatten

<details>
<summary>Lösung anzeigen</summary>

```bash
# Blockgeräte
lsblk

# Mit Dateisystem
lsblk -f

# Detailliert
sudo fdisk -l

# Leere Disks haben keine Partitionen:
# sdb    8:16   0    1G  0 disk
# sdc    8:32   0    1G  0 disk
```

</details>

---

## Aufgabe 2: MBR-Partition erstellen

1. Öffne fdisk für /dev/sdb
2. Erstelle eine neue primäre Partition (volle Größe)
3. Schreibe die Änderungen

<details>
<summary>Lösung anzeigen</summary>

```bash
sudo fdisk /dev/sdb

# Im fdisk-Menü:
# n     - neue Partition
# p     - primär
# 1     - Partitionsnummer
# Enter - Start (Default)
# Enter - Ende (Default = gesamte Disk)
# p     - Partitionstabelle anzeigen
# w     - Schreiben und beenden

# Prüfen
lsblk
# sdb
# └─sdb1
```

</details>

---

## Aufgabe 3: ext4-Dateisystem erstellen

1. Formatiere /dev/sdb1 mit ext4
2. Setze das Label "DATA"
3. Zeige Dateisystem-Informationen

<details>
<summary>Lösung anzeigen</summary>

```bash
# Formatieren mit Label
sudo mkfs.ext4 -L "DATA" /dev/sdb1

# Informationen anzeigen
sudo tune2fs -l /dev/sdb1 | head -20

# Oder
blkid /dev/sdb1
# /dev/sdb1: LABEL="DATA" UUID="xxx" TYPE="ext4"

lsblk -f /dev/sdb
```

</details>

---

## Aufgabe 4: Mounten

1. Erstelle Mountpoint /mnt/data
2. Mounte /dev/sdb1
3. Erstelle eine Testdatei
4. Unmounte wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# Mountpoint erstellen
sudo mkdir -p /mnt/data

# Mounten
sudo mount /dev/sdb1 /mnt/data

# Prüfen
df -h /mnt/data
mount | grep sdb1

# Testdatei erstellen
sudo touch /mnt/data/testfile.txt
ls /mnt/data

# Unmounten
sudo umount /mnt/data
```

</details>

---

## Aufgabe 5: fstab-Eintrag erstellen

1. Finde die UUID von /dev/sdb1
2. Füge einen fstab-Eintrag hinzu
3. Teste mit `mount -a`

<details>
<summary>Lösung anzeigen</summary>

```bash
# UUID finden
sudo blkid /dev/sdb1
# Notiere die UUID

# fstab editieren
sudo nano /etc/fstab

# Zeile hinzufügen (UUID anpassen!):
UUID=deine-uuid-hier  /mnt/data  ext4  defaults,nofail  0  2

# Speichern

# Testen (mountet alle in fstab)
sudo mount -a

# Prüfen
df -h /mnt/data

# Reboot-Test
sudo reboot
# Nach Reboot: df -h /mnt/data
```

</details>

---

## Aufgabe 6: GPT-Partition mit gdisk

1. Erstelle eine GPT-Partitionstabelle auf /dev/sdc
2. Erstelle zwei Partitionen (500MB und Rest)
3. Formatiere beide mit ext4

<details>
<summary>Lösung anzeigen</summary>

```bash
sudo gdisk /dev/sdc

# Im gdisk-Menü:
# o     - neue GPT erstellen (ACHTUNG: löscht alles!)
# Y     - bestätigen
# n     - neue Partition
# 1     - Nummer
# Enter - Start
# +500M - Ende (500 MB)
# Enter - Typ (Linux filesystem)
# n     - zweite Partition
# 2
# Enter - Start
# Enter - Ende (Rest)
# Enter - Typ
# p     - Anzeigen
# w     - Schreiben
# Y     - Bestätigen

# Formatieren
sudo mkfs.ext4 -L "PART1" /dev/sdc1
sudo mkfs.ext4 -L "PART2" /dev/sdc2

# Prüfen
lsblk -f /dev/sdc
```

</details>

---

## Aufgabe 7: Dateisystem prüfen

1. Unmounte /dev/sdb1
2. Führe einen Dateisystem-Check durch
3. Mounte wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# Unmounten
sudo umount /mnt/data

# Prüfen
sudo fsck.ext4 -f /dev/sdb1
# -f = force (auch wenn "clean")

# Mögliche Ausgabe:
# Pass 1: Checking inodes, blocks, and sizes
# Pass 2: Checking directory structure
# ...
# /dev/sdb1: clean, x/x files, x/x blocks

# Wieder mounten
sudo mount /mnt/data
```

</details>

---

## Aufgabe 8: Swap-Datei erstellen

1. Erstelle eine 1GB Swap-Datei
2. Aktiviere sie
3. Prüfe mit `swapon --show`

<details>
<summary>Lösung anzeigen</summary>

```bash
# Swap-Datei erstellen
sudo dd if=/dev/zero of=/swapfile bs=1M count=1024 status=progress

# Berechtigungen setzen
sudo chmod 600 /swapfile

# Als Swap formatieren
sudo mkswap /swapfile

# Aktivieren
sudo swapon /swapfile

# Prüfen
swapon --show
free -h

# Für permanente Aktivierung in fstab:
# /swapfile  none  swap  sw  0  0

# Deaktivieren (für Cleanup)
sudo swapoff /swapfile
sudo rm /swapfile
```

</details>

---

## Aufgabe 9: Speichernutzung analysieren

1. Zeige Belegung aller Dateisysteme
2. Finde die größten Verzeichnisse in /var
3. Zeige Inode-Nutzung

<details>
<summary>Lösung anzeigen</summary>

```bash
# Dateisystem-Belegung
df -h

# Nur lokale Dateisysteme
df -h -x tmpfs -x devtmpfs

# Größte Verzeichnisse in /var
sudo du -sh /var/* | sort -hr | head -10

# Interaktiv mit ncdu
sudo apt install ncdu
sudo ncdu /var
# Pfeiltasten, Enter, q zum Beenden

# Inode-Nutzung
df -i
```

</details>

---

## Aufgabe 10: Cleanup

Entferne die Test-Konfiguration:

```bash
# fstab-Eintrag entfernen
sudo nano /etc/fstab
# Zeile für /mnt/data entfernen

# Unmounten
sudo umount /mnt/data

# Mountpoint entfernen
sudo rmdir /mnt/data

# Partitionen löschen (optional für frischen Start)
sudo wipefs -a /dev/sdb
sudo wipefs -a /dev/sdc
```

---

## Zusammenfassung

Du hast gelernt:
- Festplatten mit fdisk/gdisk partitionieren
- Dateisysteme mit mkfs erstellen
- Mounten und /etc/fstab konfigurieren
- Dateisysteme prüfen und analysieren
- Swap erstellen

---

Weiter zu [LVM und RAID](../08_lvm_raid/01_theorie.md)!
