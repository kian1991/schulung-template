---
title: "Lab: Troubleshooting"
sidebar_position: 2
---

# Lab: Troubleshooting

:::info Zeitrahmen
**Dauer:** ca. 2 Stunden
:::

---

## Aufgabe 1: Service-Fehler diagnostizieren

1. Stoppe nginx
2. Mache die Konfiguration absichtlich kaputt
3. Versuche zu starten und diagnostiziere

<details>
<summary>Lösung anzeigen</summary>

```bash
# nginx stoppen
sudo systemctl stop nginx

# Fehler einbauen
sudo nano /etc/nginx/nginx.conf
# Entferne ein Semikolon oder schließende Klammer

# Starten versuchen
sudo systemctl start nginx
# Job for nginx.service failed

# Diagnose
systemctl status nginx
journalctl -u nginx -n 20

# Konfiguration testen
sudo nginx -t
# Zeigt den genauen Fehler!

# Beheben
sudo nano /etc/nginx/nginx.conf
sudo nginx -t
sudo systemctl start nginx
```

</details>

---

## Aufgabe 2: Festplatte voll simulieren

1. Erstelle große Datei die Platz füllt
2. Finde und lösche sie

<details>
<summary>Lösung anzeigen</summary>

```bash
# Platz prüfen
df -h

# Große Datei erstellen (in /tmp damit sicher)
dd if=/dev/zero of=/tmp/bigfile bs=100M count=10

# Platz prüfen
df -h

# Problem diagnostizieren
sudo du -sh /tmp/* | sort -hr | head

# Löschen
rm /tmp/bigfile
```

</details>

---

## Aufgabe 3: Netzwerk-Diagnose

1. Deaktiviere das Netzwerk-Interface
2. Diagnostiziere
3. Reaktiviere

<details>
<summary>Lösung anzeigen</summary>

```bash
# Interface prüfen
ip addr

# Deaktivieren
sudo ip link set enp0s3 down

# Diagnose
ip addr show enp0s3
# state DOWN
ping 8.8.8.8
# Network is unreachable

# Reaktivieren
sudo ip link set enp0s3 up

# IP neu holen (falls DHCP)
sudo dhclient enp0s3

# Prüfen
ip addr
ping 8.8.8.8
```

</details>

---

## Aufgabe 4: Gelöschte Datei finden (noch geöffnet)

1. Öffne eine Datei mit einem Prozess
2. Lösche die Datei
3. Finde und stelle sie wieder her

<details>
<summary>Lösung anzeigen</summary>

```bash
# Datei erstellen und öffnen
echo "wichtige daten" > /tmp/important.txt
tail -f /tmp/important.txt &
# Notiere die PID

# Datei löschen
rm /tmp/important.txt
ls /tmp/important.txt
# Datei weg!

# Aber: Prozess hält sie noch offen
lsof | grep important
# Oder:
ls -l /proc/$(pgrep tail)/fd/

# Wiederherstellen
cp /proc/$(pgrep tail)/fd/3 /tmp/recovered.txt
cat /tmp/recovered.txt

# Cleanup
kill $(pgrep tail)
```

</details>

---

## Aufgabe 5: Boot-Probleme simulieren (vorsichtig!)

Verstehe den Recovery-Mode:

<details>
<summary>Lösung anzeigen</summary>

```bash
# In VirtualBox: Während Boot Shift gedrückt halten
# → GRUB-Menü erscheint

# "Advanced options" → "Recovery mode" wählen

# Im Recovery-Menü:
# - root: Root-Shell
# - fsck: Dateisystem prüfen
# - network: Netzwerk aktivieren
# - dpkg: Pakete reparieren

# Nach Änderungen: resume oder reboot
```

</details>

---

## Aufgabe 6: fstab-Fehler beheben (simuliert)

1. Füge einen ungültigen fstab-Eintrag hinzu
2. Prüfe mit mount -a
3. Behebe den Fehler

<details>
<summary>Lösung anzeigen</summary>

```bash
# Backup!
sudo cp /etc/fstab /etc/fstab.backup

# Falschen Eintrag hinzufügen
echo "/dev/sdz1 /nonexistent ext4 defaults 0 0" | sudo tee -a /etc/fstab

# Testen (OHNE Reboot!)
sudo mount -a
# mount: /nonexistent: special device /dev/sdz1 does not exist.

# Fehler beheben
sudo nano /etc/fstab
# Zeile löschen oder auskommentieren

# Testen
sudo mount -a
# Kein Fehler mehr

# Aufräumen
sudo cp /etc/fstab.backup /etc/fstab
```

:::warning Niemals blind rebooten!
Teste fstab-Änderungen IMMER mit `mount -a` bevor du rebootest!
:::

</details>

---

## Aufgabe 7: Passwort vergessen (Recovery)

Wie würdest du das Root-Passwort zurücksetzen?

<details>
<summary>Lösung anzeigen</summary>

```
1. System neustarten
2. Bei GRUB-Menü: 'e' drücken
3. Zeile mit "linux" finden
4. Am Ende hinzufügen: init=/bin/bash
5. Ctrl+X zum Booten

6. Root-Partition beschreibbar machen:
   mount -o remount,rw /

7. Passwort ändern:
   passwd root

8. Neu booten:
   exec /sbin/init
   # oder: sync; reboot -f
```

</details>

---

## Zusammenfassung

Troubleshooting-Checkliste:

1. **Logs lesen:** `journalctl -u dienst`
2. **Konfiguration testen:** `dienst -t`
3. **Platz prüfen:** `df -h`
4. **Netzwerk prüfen:** `ip a`, `ping`
5. **Recovery-Mode:** Shift bei Boot
6. **Live-USB:** Für schwere Probleme
7. **Backup haben:** Immer!

---

Weiter zu den Erweiterungsmodulen (je nach Kurs: Virtualisierung/Docker oder Shell-Advanced/Bonding/cgroups).
