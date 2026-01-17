---
title: "Lab: LVM einrichten"
sidebar_position: 2
---

# Lab: LVM einrichten

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

---

## Vorbereitung

Stelle sicher, dass du mindestens 2 ungenutzte virtuelle Festplatten hast:

```bash
lsblk
# sdb, sdc sollten ohne Partitionen sein
```

---

## Aufgabe 1: Physical Volumes erstellen

1. Erstelle PVs auf /dev/sdb und /dev/sdc
2. Zeige alle PVs an

<details>
<summary>Lösung anzeigen</summary>

```bash
# LVM-Tools installieren (falls nötig)
sudo apt install lvm2

# PVs erstellen
sudo pvcreate /dev/sdb
sudo pvcreate /dev/sdc

# Anzeigen
sudo pvs
sudo pvdisplay /dev/sdb
```

</details>

---

## Aufgabe 2: Volume Group erstellen

1. Erstelle VG "vg_data" aus beiden PVs
2. Zeige die VG-Details

<details>
<summary>Lösung anzeigen</summary>

```bash
# VG erstellen
sudo vgcreate vg_data /dev/sdb /dev/sdc

# Anzeigen
sudo vgs
sudo vgdisplay vg_data
# Zeigt: Total PE, Free PE, VG Size, etc.
```

</details>

---

## Aufgabe 3: Logical Volumes erstellen

1. Erstelle LV "lv_www" mit 500MB
2. Erstelle LV "lv_db" mit 300MB
3. Zeige alle LVs an

<details>
<summary>Lösung anzeigen</summary>

```bash
# LVs erstellen
sudo lvcreate -n lv_www -L 500M vg_data
sudo lvcreate -n lv_db -L 300M vg_data

# Anzeigen
sudo lvs
sudo lvdisplay /dev/vg_data/lv_www

# Pfade:
# /dev/vg_data/lv_www
# /dev/mapper/vg_data-lv_www
# Beide funktionieren!
```

</details>

---

## Aufgabe 4: Dateisysteme erstellen und mounten

1. Formatiere beide LVs mit ext4
2. Erstelle Mountpoints
3. Mounte beide

<details>
<summary>Lösung anzeigen</summary>

```bash
# Formatieren
sudo mkfs.ext4 /dev/vg_data/lv_www
sudo mkfs.ext4 /dev/vg_data/lv_db

# Mountpoints
sudo mkdir -p /var/www /var/db

# Mounten
sudo mount /dev/vg_data/lv_www /var/www
sudo mount /dev/vg_data/lv_db /var/db

# Prüfen
df -h | grep vg_data
```

</details>

---

## Aufgabe 5: LV online vergrößern

1. Vergrößere lv_www um 200MB
2. Passe das Dateisystem an
3. Prüfe die neue Größe

<details>
<summary>Lösung anzeigen</summary>

```bash
# LV vergrößern
sudo lvextend -L +200M /dev/vg_data/lv_www
# oder auf bestimmte Größe:
# sudo lvextend -L 700M /dev/vg_data/lv_www

# Dateisystem vergrößern (online möglich!)
sudo resize2fs /dev/vg_data/lv_www

# Oder beides in einem Befehl:
# sudo lvextend -r -L +200M /dev/vg_data/lv_www

# Prüfen
df -h /var/www
# Sollte jetzt ~700M zeigen
```

</details>

---

## Aufgabe 6: Snapshot erstellen

1. Erstelle einen Snapshot von lv_www
2. Erstelle eine Datei im Original
3. Mounte den Snapshot und prüfe

<details>
<summary>Lösung anzeigen</summary>

```bash
# Snapshot erstellen (1GB für Änderungen)
sudo lvcreate -s -n lv_www_snap -L 100M /dev/vg_data/lv_www

# Snapshots anzeigen
sudo lvs
# Origin-Spalte zeigt das Original

# Datei im Original erstellen
sudo touch /var/www/after_snapshot.txt
ls /var/www

# Snapshot mounten
sudo mkdir /mnt/snap
sudo mount /dev/vg_data/lv_www_snap /mnt/snap

# Prüfen - Datei sollte FEHLEN
ls /mnt/snap
# after_snapshot.txt fehlt - Snapshot zeigt alten Zustand!

# Aufräumen
sudo umount /mnt/snap
sudo lvremove /dev/vg_data/lv_www_snap
```

</details>

---

## Aufgabe 7: VG erweitern

1. Füge eine weitere Festplatte zur VG hinzu
2. Prüfe die neue Größe

<details>
<summary>Lösung anzeigen</summary>

```bash
# Falls sdd existiert:
sudo pvcreate /dev/sdd
sudo vgextend vg_data /dev/sdd

# Prüfen
sudo vgs
# VG ist jetzt größer

sudo pvs
# Zeigt alle PVs in der VG
```

</details>

---

## Aufgabe 8: fstab für LVM

Trage die LVs in fstab ein:

<details>
<summary>Lösung anzeigen</summary>

```bash
# UUIDs finden (für LVM optional, Pfad reicht)
blkid /dev/vg_data/lv_www
blkid /dev/vg_data/lv_db

# fstab editieren
sudo nano /etc/fstab

# Einträge hinzufügen:
/dev/vg_data/lv_www  /var/www  ext4  defaults  0  2
/dev/vg_data/lv_db   /var/db   ext4  defaults  0  2

# Testen
sudo umount /var/www /var/db
sudo mount -a
df -h
```

</details>

---

## Cleanup

```bash
# Unmounten
sudo umount /var/www /var/db

# LVs löschen
sudo lvremove /dev/vg_data/lv_www
sudo lvremove /dev/vg_data/lv_db

# VG löschen
sudo vgremove vg_data

# PVs löschen
sudo pvremove /dev/sdb /dev/sdc

# fstab-Einträge entfernen
sudo nano /etc/fstab
```

---

Weiter zum [Lab: Software-RAID](./03_lab_raid.md)!
