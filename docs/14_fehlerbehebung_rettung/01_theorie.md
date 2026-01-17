---
title: Fehlerbehebung und Systemrettung
sidebar_position: 1
---

# Fehlerbehebung und Systemrettung

## Systematische Fehlersuche

1. **Problem verstehen:** Was funktioniert nicht?
2. **Reproduzieren:** Wann tritt es auf?
3. **Logs prüfen:** Was sagen die Logs?
4. **Isolieren:** Welche Komponente ist betroffen?
5. **Lösen:** Schritt für Schritt beheben
6. **Dokumentieren:** Für die Zukunft

## Häufige Probleme

### Service startet nicht

```bash
# Status prüfen
systemctl status dienst

# Detaillierte Logs
journalctl -u dienst -n 50

# Konfiguration testen
dienst -t      # z.B. nginx -t

# Manuell im Vordergrund starten
/usr/sbin/dienst -DFOREGROUND
```

### Netzwerk geht nicht

```bash
# Interface prüfen
ip addr
ip link

# Gateway erreichbar?
ping gateway-ip

# DNS funktioniert?
ping 8.8.8.8     # IP
ping google.com   # Name

# DNS-Server
cat /etc/resolv.conf
nslookup google.com
```

### Festplatte voll

```bash
# Belegung prüfen
df -h

# Größte Verzeichnisse finden
sudo du -sh /* 2>/dev/null | sort -hr | head

# Logs aufräumen
sudo journalctl --vacuum-size=100M
sudo apt clean
```

### System bootet nicht

1. GRUB-Menü aufrufen (Shift beim Boot)
2. Recovery-Mode wählen
3. Root-Shell öffnen
4. Problem beheben
5. Reboot

## Recovery-Modus

In GRUB:
1. `e` drücken für Edit
2. Zeile mit `linux` finden
3. Am Ende `single` oder `recovery` hinzufügen
4. Mit `Ctrl+X` oder `F10` booten

## Rettungssystem (Live-USB)

1. Von Ubuntu Live-USB booten
2. Root-Partition mounten:
   ```bash
   sudo mount /dev/sda1 /mnt
   ```
3. Chroot:
   ```bash
   sudo mount --bind /dev /mnt/dev
   sudo mount --bind /proc /mnt/proc
   sudo mount --bind /sys /mnt/sys
   sudo chroot /mnt
   ```
4. Problem beheben
5. Exit und reboot

## Root-Passwort zurücksetzen

1. Recovery-Mode booten
2. Root-Shell wählen
3. `passwd root`
4. Reboot

## GRUB reparieren

```bash
# Im Rettungssystem, nach chroot:
grub-install /dev/sda
update-grub
```

## fstab reparieren

Problem: System bootet nicht wegen fstab-Fehler

1. Recovery-Mode oder Live-USB
2. Root-Partition mounten
3. `/etc/fstab` editieren
4. Fehlerhafte Zeile korrigieren oder auskommentieren
5. Reboot

---

Weiter zum [Lab: Troubleshooting](./02_lab_troubleshooting.md)!
