---
title: "Lab: Software-RAID"
sidebar_position: 3
---

# Lab: Software-RAID

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

---

## Vorbereitung

Du brauchst mindestens 3 ungenutzte virtuelle Festplatten (sdb, sdc, sdd).

```bash
# mdadm installieren
sudo apt install mdadm

# Disks prüfen
lsblk
```

---

## Aufgabe 1: RAID-5 erstellen

1. Erstelle ein RAID-5 Array aus 3 Disks
2. Prüfe den Status

<details>
<summary>Lösung anzeigen</summary>

```bash
# RAID-5 erstellen
sudo mdadm --create /dev/md0 \
    --level=5 \
    --raid-devices=3 \
    /dev/sdb /dev/sdc /dev/sdd

# Bei Warnung "array may not be fully synced": yes eingeben

# Status prüfen
cat /proc/mdstat
# md0 : active raid5 sdd[2] sdc[1] sdb[0]
#       2093056 blocks super 1.2 level 5, ...
#       [====>................]  recovery = XX.X%

# Detailliert
sudo mdadm --detail /dev/md0
```

</details>

---

## Aufgabe 2: Dateisystem erstellen und mounten

1. Formatiere /dev/md0 mit ext4
2. Mounte nach /mnt/raid
3. Erstelle Testdateien

<details>
<summary>Lösung anzeigen</summary>

```bash
# Warte bis Sync fertig (oder mache trotzdem weiter)
watch cat /proc/mdstat
# Ctrl+C wenn fertig

# Formatieren
sudo mkfs.ext4 /dev/md0

# Mounten
sudo mkdir /mnt/raid
sudo mount /dev/md0 /mnt/raid

# Testdaten
sudo dd if=/dev/urandom of=/mnt/raid/testfile bs=1M count=10
ls -l /mnt/raid
```

</details>

---

## Aufgabe 3: RAID-Konfiguration speichern

Speichere die Konfiguration für den Boot:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Konfiguration anzeigen
sudo mdadm --detail --scan

# In Konfigdatei speichern
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

# initramfs aktualisieren
sudo update-initramfs -u

# In fstab eintragen
# UUID statt /dev/md0 verwenden!
sudo blkid /dev/md0
sudo nano /etc/fstab
# UUID=xxx  /mnt/raid  ext4  defaults,nofail  0  2
```

</details>

---

## Aufgabe 4: Festplattenausfall simulieren

1. Markiere eine Disk als defekt
2. Beobachte den Status
3. Prüfe ob Daten noch zugänglich sind

<details>
<summary>Lösung anzeigen</summary>

```bash
# Disk als defekt markieren
sudo mdadm /dev/md0 --fail /dev/sdc

# Status
cat /proc/mdstat
# [UU_] oder [U_U] = eine Disk fehlt

sudo mdadm --detail /dev/md0
# State: clean, degraded

# Daten noch da?
ls /mnt/raid/
cat /mnt/raid/testfile > /dev/null && echo "Daten OK!"
# RAID-5 verkraftet 1 Disk-Ausfall
```

</details>

---

## Aufgabe 5: Defekte Disk ersetzen

1. Entferne die defekte Disk
2. Füge eine neue hinzu (oder dieselbe)
3. Beobachte den Rebuild

<details>
<summary>Lösung anzeigen</summary>

```bash
# Defekte Disk entfernen
sudo mdadm /dev/md0 --remove /dev/sdc

# Status
cat /proc/mdstat
# Nur noch 2 Disks

# "Neue" Disk hinzufügen
sudo mdadm /dev/md0 --add /dev/sdc

# Rebuild beobachten
watch cat /proc/mdstat
# [==>..................]  recovery = XX%

# Nach Rebuild:
# [UUU] = alle Disks OK
```

</details>

---

## Aufgabe 6: Spare-Disk hinzufügen

1. Füge eine vierte Disk als Spare hinzu
2. Simuliere einen Ausfall
3. Beobachte automatisches Rebuild

<details>
<summary>Lösung anzeigen</summary>

```bash
# Falls sde existiert:
sudo mdadm /dev/md0 --add /dev/sde

# Status
sudo mdadm --detail /dev/md0
# Spare Devices: 1

# Ausfall simulieren
sudo mdadm /dev/md0 --fail /dev/sdb

# Beobachten
watch cat /proc/mdstat
# Spare wird automatisch eingebaut!
# Rebuild startet automatisch
```

</details>

---

## Aufgabe 7: RAID stoppen und entfernen

Cleanup für die nächsten Labs:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Unmounten
sudo umount /mnt/raid

# RAID stoppen
sudo mdadm --stop /dev/md0

# Superblocks löschen
sudo mdadm --zero-superblock /dev/sdb
sudo mdadm --zero-superblock /dev/sdc
sudo mdadm --zero-superblock /dev/sdd

# fstab-Eintrag entfernen
sudo nano /etc/fstab

# Konfiguration entfernen
sudo nano /etc/mdadm/mdadm.conf
# ARRAY Zeile für md0 entfernen

# initramfs aktualisieren
sudo update-initramfs -u
```

</details>

---

## Bonus: RAID-1 (Mirror)

Einfacher Mirror mit 2 Disks:

<details>
<summary>Lösung anzeigen</summary>

```bash
# RAID-1 erstellen
sudo mdadm --create /dev/md1 \
    --level=1 \
    --raid-devices=2 \
    /dev/sdb /dev/sdc

# Gleiche Befehle zum Verwalten wie RAID-5
# Aber: 50% Kapazität, dafür schneller
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- RAID-5 mit mdadm erstellen
- RAID-Status überwachen
- Festplattenausfall simulieren und beheben
- Spare-Disks konfigurieren
- RAID persistieren (mdadm.conf, fstab)

---

Weiter zu [Systemd und Boot](../09_systemd_boot/01_theorie.md)!
