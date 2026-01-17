---
title: Speicher und Dateisysteme
sidebar_position: 1
---

# Speicher und Dateisysteme

## Blockgeräte und Partitionen

### Festplatten in Linux

```
/dev/sda    → Erste SATA/SCSI-Festplatte
/dev/sda1   → Erste Partition auf sda
/dev/sda2   → Zweite Partition
/dev/sdb    → Zweite Festplatte
/dev/nvme0n1 → NVMe SSD
/dev/nvme0n1p1 → Erste Partition auf NVMe
```

### MBR vs GPT

| Feature | MBR | GPT |
|---------|-----|-----|
| Max. Partitionen | 4 primäre | 128 |
| Max. Größe | 2 TB | 9.4 ZB |
| Boot | BIOS | UEFI |
| Redundanz | Keine | Header-Backup |

### Partitionieren

```bash
# Blockgeräte anzeigen
lsblk

# Detaillierte Info
lsblk -f   # Mit Dateisystem
blkid      # Mit UUID

# Partitionieren (interaktiv)
sudo fdisk /dev/sdb    # MBR
sudo gdisk /dev/sdb    # GPT
sudo parted /dev/sdb   # Beide
```

## Dateisysteme

### Verfügbare Dateisysteme

| Dateisystem | Vorteile | Nachteile |
|-------------|----------|-----------|
| **ext4** | Standard, stabil, gut dokumentiert | Keine Snapshots |
| **XFS** | Gut für große Dateien, skalierbar | Kann nicht schrumpfen |
| **BTRFS** | Snapshots, Kompression | Weniger ausgereift |

### Dateisystem erstellen

```bash
# ext4 (empfohlen für Standard-Nutzung)
sudo mkfs.ext4 /dev/sdb1

# Mit Label
sudo mkfs.ext4 -L "DATA" /dev/sdb1

# XFS
sudo mkfs.xfs /dev/sdb1

# Dateisystem-Info
sudo tune2fs -l /dev/sdb1   # ext4
sudo xfs_info /dev/sdb1     # XFS
```

### Mounten

```bash
# Manuell mounten
sudo mount /dev/sdb1 /mnt/data

# Mit Optionen
sudo mount -o ro /dev/sdb1 /mnt    # Read-only
sudo mount -o noexec /dev/sdb1 /mnt

# Unmounten
sudo umount /mnt/data

# Alle Mounts anzeigen
mount | grep "^/dev"
df -h
```

### /etc/fstab

Für automatisches Mounten beim Boot:

```bash
cat /etc/fstab
```

Format:
```
<device>        <mountpoint>  <type>  <options>  <dump>  <pass>
/dev/sdb1       /mnt/data     ext4    defaults   0       2
UUID=xxxx-xxxx  /mnt/backup   ext4    defaults,noatime  0  2
```

| Option | Bedeutung |
|--------|-----------|
| `defaults` | rw, suid, dev, exec, auto, nouser, async |
| `noatime` | Zugriffszeit nicht aktualisieren (Performance) |
| `noexec` | Keine Ausführung erlauben |
| `ro` | Read-only |
| `nofail` | Boot auch wenn Mount fehlschlägt |

**Pass-Wert:** Reihenfolge für fsck (0=nicht prüfen, 1=Root, 2=andere)

## Dateisystem-Verwaltung

### Prüfen und Reparieren

```bash
# WICHTIG: Dateisystem muss unmounted sein!
sudo umount /dev/sdb1

# ext4 prüfen
sudo fsck /dev/sdb1
sudo fsck.ext4 -f /dev/sdb1   # Force

# XFS prüfen
sudo xfs_repair /dev/sdb1
```

### Größe ändern

```bash
# ext4 vergrößern (online möglich)
sudo resize2fs /dev/sdb1

# ext4 verkleinern (offline!)
sudo umount /dev/sdb1
sudo e2fsck -f /dev/sdb1
sudo resize2fs /dev/sdb1 5G   # Auf 5GB

# XFS vergrößern (nur vergrößern!)
sudo xfs_growfs /mnt/data
```

### Labels und UUIDs

```bash
# UUID anzeigen
blkid /dev/sdb1

# Label setzen (ext4)
sudo e2label /dev/sdb1 "BACKUP"

# Label setzen (XFS)
sudo xfs_admin -L "BACKUP" /dev/sdb1
```

## Swap

Virtueller Speicher wenn RAM voll:

```bash
# Swap-Status
swapon --show
free -h

# Swap-Partition erstellen
sudo mkswap /dev/sdb2
sudo swapon /dev/sdb2

# Swap-Datei erstellen (Alternative)
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# In fstab eintragen
# /swapfile  none  swap  sw  0  0

# Swap deaktivieren
sudo swapoff /swapfile
```

## Speichernutzung

```bash
# Dateisysteme
df -h

# Verzeichnisgrößen
du -sh /var/*
du -sh * | sort -hr | head -10

# Inodes
df -i

# Welcher Prozess hält Datei offen?
lsof +D /mnt/data
```

## Zusammenfassung

| Befehl | Funktion |
|--------|----------|
| `lsblk` | Blockgeräte anzeigen |
| `blkid` | UUIDs anzeigen |
| `fdisk` / `gdisk` | Partitionieren |
| `mkfs.ext4` | Dateisystem erstellen |
| `mount` / `umount` | Ein-/Aushängen |
| `df -h` | Speicherbelegung |
| `du -sh` | Verzeichnisgröße |
| `fsck` | Dateisystem prüfen |
| `resize2fs` | ext4 Größe ändern |

---

Weiter zum [Lab: Partitionieren](./02_lab_partitionen.md)!
