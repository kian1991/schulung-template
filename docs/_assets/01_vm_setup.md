---
title: VM-Setup
sidebar_position: 1
---

# VM-Setup für die Schulung

In diesem Guide richtest du deine Übungsumgebung ein. Du brauchst VirtualBox und ein Ubuntu Server Image.

## Voraussetzungen

- **Host-System:** Windows, macOS oder Linux mit min. 8 GB RAM
- **Festplatte:** Min. 50 GB freier Speicherplatz
- **Virtualisierung:** Im BIOS aktiviert (VT-x/AMD-V)

## 1. VirtualBox installieren

### Download

Lade VirtualBox von der offiziellen Seite herunter:
- **URL:** https://www.virtualbox.org/wiki/Downloads
- Wähle die Version für dein Betriebssystem

### Installation

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

<Tabs>
  <TabItem value="windows" label="Windows" default>
    1. Führe den Installer aus
    2. Akzeptiere alle Standardeinstellungen
    3. Erlaube die Installation der Netzwerk-Treiber
    4. Starte nach der Installation neu (empfohlen)
  </TabItem>
  <TabItem value="macos" label="macOS">
    1. Öffne die .dmg Datei
    2. Doppelklicke auf VirtualBox.pkg
    3. Folge dem Installer
    4. Erlaube in Systemeinstellungen → Sicherheit die Kernel-Extension
    5. Starte neu
  </TabItem>
  <TabItem value="linux" label="Linux">
    ```bash
    # Ubuntu/Debian
    sudo apt update
    sudo apt install virtualbox virtualbox-ext-pack
    
    # Fedora
    sudo dnf install VirtualBox
    ```
  </TabItem>
</Tabs>

## 2. Ubuntu Server herunterladen

### Download

- **URL:** https://ubuntu.com/download/server
- **Version:** Ubuntu Server 24.04 LTS
- **Datei:** ubuntu-24.04-live-server-amd64.iso (~2.5 GB)

:::tip
Lade die ISO vorab herunter - das spart Zeit am Schulungstag!
:::

## 3. VM erstellen

### Neue VM anlegen

1. Öffne VirtualBox
2. Klicke auf **Neu**
3. Konfiguriere:
   - **Name:** `ubuntu-server`
   - **Typ:** Linux
   - **Version:** Ubuntu (64-bit)
4. Klicke **Weiter**

### Hardware-Ressourcen

| Einstellung | Wert | Hinweis |
|-------------|------|---------|
| **RAM** | 4096 MB | Minimum 2048 MB |
| **CPUs** | 2 | Mehr ist besser |
| **Festplatte** | 20 GB | Dynamisch alloziert |

### Festplatte erstellen

1. Wähle **Festplatte erzeugen**
2. Dateityp: **VDI (VirtualBox Disk Image)**
3. Art: **Dynamisch alloziert**
4. Größe: **20 GB**

## 4. VM-Einstellungen anpassen

Rechtsklick auf die VM → **Ändern**:

### System

- **Hauptplatine:** EFI aktivieren (optional, empfohlen)
- **Prozessor:** PAE/NX aktivieren

### Netzwerk

Wir brauchen zwei Netzwerk-Adapter:

**Adapter 1: NAT** (für Internet)
- Angeschlossen an: **NAT**
- Erweitert → Port-Weiterleitung:
  - Name: `SSH`
  - Protokoll: TCP
  - Host-Port: `2222`
  - Gast-Port: `22`

**Adapter 2: Host-only** (für direkte Verbindung)
1. Erstelle zuerst ein Host-only Netzwerk:
   - Datei → Host-only Netzwerk-Manager
   - Erstellen → DHCP-Server aktivieren
2. Aktiviere Adapter 2
   - Angeschlossen an: **Host-only Adapter**
   - Wähle das erstellte Netzwerk

### Massenspeicher

1. Klicke auf **Leer** unter Controller: IDE
2. Klicke auf das CD-Symbol rechts
3. Wähle **Abbild auswählen**
4. Wähle die heruntergeladene Ubuntu ISO

## 5. Ubuntu installieren

### VM starten

1. Wähle die VM
2. Klicke **Starten**
3. Die VM bootet von der ISO

### Installation durchführen

1. **Sprache:** Deutsch oder English
2. **Tastatur:** German
3. **Installation:** Ubuntu Server
4. **Netzwerk:** DHCP übernehmen
5. **Proxy:** Leer lassen
6. **Mirror:** Standard
7. **Speicher:** Gesamte Festplatte verwenden (mit LVM, empfohlen)
8. **Profil:**
   - Dein Name: `Student`
   - Servername: `ubuntu-server`
   - Username: `student`
   - Passwort: (wähle ein einfaches für die Schulung, z.B. `student`)
9. **SSH:** OpenSSH server installieren ✓
10. **Snaps:** Keine auswählen
11. Warten bis Installation abgeschlossen
12. **Reboot**

:::warning ISO entfernen
Nach dem Reboot: Geräte → Optische Laufwerke → Medium entfernen
:::

## 6. Erste Verbindung

### Direkt in VirtualBox

Nach dem Neustart siehst du den Login-Prompt:
```
ubuntu-server login: student
Password: ********
```

### Per SSH (empfohlen)

Öffne ein Terminal auf deinem Host:

```bash
# Über NAT Port-Weiterleitung
ssh student@localhost -p 2222

# Oder über Host-only Netzwerk (IP herausfinden mit: ip addr)
ssh student@192.168.56.xxx
```

:::tip SSH ist komfortabler
Über SSH kannst du kopieren/einfügen und hast ein besseres Terminal-Erlebnis.
:::

## 7. System aktualisieren

Nach dem ersten Login:

```bash
sudo apt update
sudo apt upgrade -y
```

## 8. Zusätzliche Festplatten (für Labs)

Für die Labs zu LVM und RAID brauchst du zusätzliche virtuelle Festplatten.

### Festplatten hinzufügen

1. VM herunterfahren: `sudo poweroff`
2. Einstellungen → Massenspeicher
3. Controller: SATA → Festplatte hinzufügen
4. **Neu erstellen:**
   - Größe: 1 GB
   - Name: `disk2.vdi`
5. Wiederhole für `disk3.vdi`, `disk4.vdi`, `disk5.vdi`

Am Ende solltest du 5 Festplatten haben:
- `ubuntu-server.vdi` (20 GB) - System
- `disk2.vdi` bis `disk5.vdi` (je 1 GB) - für Labs

### Prüfen

Nach dem Neustart:

```bash
lsblk
```

Du solltest sehen:
```
NAME   SIZE
sda     20G    ← System
sdb      1G    ← Lab-Disk
sdc      1G    ← Lab-Disk
sdd      1G    ← Lab-Disk
sde      1G    ← Lab-Disk
```

## 9. Snapshot erstellen

Erstelle jetzt einen Snapshot als "sauberen" Ausgangspunkt:

1. Maschine → Snapshot erstellen
2. Name: `Frische Installation`
3. Beschreibung: `Ubuntu 24.04 LTS, aktualisiert, 4 zusätzliche Disks`

:::tip Snapshots sind dein Freund
Vor riskanten Experimenten: Snapshot erstellen!
Bei Problemen: Snapshot wiederherstellen.
:::

## Fertig!

Deine Übungsumgebung ist bereit. Du kannst jetzt mit der [Einführung](../00_einfuehrung/01_theorie.md) starten.

## Troubleshooting

### VM startet nicht

- Prüfe ob Virtualisierung im BIOS aktiviert ist
- Windows: Hyper-V deaktivieren (kann mit VirtualBox kollidieren)

### Netzwerk funktioniert nicht

```bash
# In der VM
sudo systemctl restart systemd-networkd
ip addr
```

### SSH-Verbindung wird abgelehnt

```bash
# Prüfe ob SSH läuft
sudo systemctl status ssh

# Prüfe Port-Weiterleitung in VirtualBox
# Host-Port 2222 → Gast-Port 22
```

### Festplatten nicht sichtbar

```bash
# Alle Blockgeräte anzeigen
lsblk -a

# SATA-Controller prüfen
ls /dev/sd*
```
