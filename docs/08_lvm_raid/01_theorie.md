---
title: LVM und RAID
sidebar_position: 1
---

# LVM und RAID

## LVM - Logical Volume Manager

LVM fügt eine Abstraktionsschicht zwischen physischen Festplatten und Dateisystemen ein.

### Konzepte

```
┌─────────────────────────────────────────────────┐
│            Logical Volumes (LV)                 │
│         /dev/vg_data/lv_www                     │
│         /dev/vg_data/lv_db                      │
├─────────────────────────────────────────────────┤
│            Volume Groups (VG)                   │
│              vg_data                            │
├───────────────────┬─────────────────────────────┤
│  Physical Volume  │   Physical Volume           │
│     /dev/sdb      │      /dev/sdc               │
└───────────────────┴─────────────────────────────┘
```

- **PV (Physical Volume):** Physische Festplatte/Partition
- **VG (Volume Group):** Pool aus mehreren PVs
- **LV (Logical Volume):** "Virtuelle Partition" aus dem Pool

### Vorteile

- Größe online ändern
- Mehrere Festplatten zusammenfassen
- Snapshots
- Flexible Speicherverwaltung

### LVM-Befehle

```bash
# Physical Volumes
pvcreate /dev/sdb              # PV erstellen
pvs                            # PVs anzeigen
pvdisplay /dev/sdb             # Details

# Volume Groups
vgcreate vg_data /dev/sdb /dev/sdc  # VG erstellen
vgs                            # VGs anzeigen
vgdisplay vg_data              # Details
vgextend vg_data /dev/sdd      # PV hinzufügen

# Logical Volumes
lvcreate -n lv_www -L 5G vg_data   # LV mit 5GB
lvcreate -n lv_db -l 100%FREE vg_data  # Restlicher Platz
lvs                            # LVs anzeigen
lvdisplay /dev/vg_data/lv_www  # Details

# LV vergrößern (online!)
lvextend -L +2G /dev/vg_data/lv_www
resize2fs /dev/vg_data/lv_www  # Dateisystem anpassen

# LV verkleinern (offline, ext4)
umount /dev/vg_data/lv_www
e2fsck -f /dev/vg_data/lv_www
resize2fs /dev/vg_data/lv_www 3G
lvreduce -L 3G /dev/vg_data/lv_www
```

### LVM Snapshots

```bash
# Snapshot erstellen
lvcreate -s -n lv_www_snap -L 1G /dev/vg_data/lv_www

# Snapshot mounten
mount /dev/vg_data/lv_www_snap /mnt/snap

# Rollback (Vorsicht!)
umount /dev/vg_data/lv_www
lvconvert --merge /dev/vg_data/lv_www_snap

# Snapshot löschen
lvremove /dev/vg_data/lv_www_snap
```

## Software-RAID

RAID kombiniert mehrere Festplatten für Redundanz oder Performance.

### RAID-Level

| Level | Min. Disks | Nutzbarer Speicher | Redundanz |
|-------|------------|-------------------|-----------|
| RAID 0 | 2 | 100% | Keine! |
| RAID 1 | 2 | 50% | 1 Disk kann ausfallen |
| RAID 5 | 3 | (n-1)/n | 1 Disk kann ausfallen |
| RAID 6 | 4 | (n-2)/n | 2 Disks können ausfallen |
| RAID 10 | 4 | 50% | Je 1 pro Mirror |

### mdadm - RAID verwalten

```bash
# RAID-5 erstellen (3 Disks)
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sd[bcd]

# Status prüfen
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Konfiguration speichern
sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
sudo update-initramfs -u

# Dateisystem erstellen
sudo mkfs.ext4 /dev/md0
sudo mount /dev/md0 /mnt/raid

# Disk als defekt markieren
sudo mdadm /dev/md0 --fail /dev/sdc

# Defekte Disk entfernen
sudo mdadm /dev/md0 --remove /dev/sdc

# Neue Disk hinzufügen
sudo mdadm /dev/md0 --add /dev/sdd

# Rebuild beobachten
watch cat /proc/mdstat
```

### RAID + LVM kombinieren

Für maximale Flexibilität:

```
           ┌─────────────────┐
           │   Filesystem    │
           ├─────────────────┤
           │  Logical Volume │
           ├─────────────────┤
           │   Volume Group  │
           ├─────────────────┤
           │ Physical Volume │
           │    /dev/md0     │
           ├────────┬────────┤
           │ RAID 5 │        │
           ├────────┼────────┤
           │ sdb    │ sdc    │ sdd
           └────────┴────────┘
```

## Zusammenfassung

### LVM-Befehle

| Befehl | Funktion |
|--------|----------|
| `pvcreate` | Physical Volume erstellen |
| `vgcreate` | Volume Group erstellen |
| `lvcreate` | Logical Volume erstellen |
| `lvextend` | LV vergrößern |
| `lvreduce` | LV verkleinern |
| `pvs/vgs/lvs` | Überblick |
| `pvdisplay/vgdisplay/lvdisplay` | Details |

### RAID-Befehle

| Befehl | Funktion |
|--------|----------|
| `mdadm --create` | RAID erstellen |
| `mdadm --detail` | Status |
| `mdadm --fail` | Disk als defekt markieren |
| `mdadm --remove` | Disk entfernen |
| `mdadm --add` | Disk hinzufügen |
| `cat /proc/mdstat` | Live-Status |

---

Weiter zum [Lab: LVM](./02_lab_lvm.md)!
