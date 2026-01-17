---
title: Linux Dateisystem
sidebar_position: 1
---

# Das Linux Dateisystem

## Filesystem Hierarchy Standard (FHS)

Linux hat eine standardisierte Verzeichnisstruktur, den **Filesystem Hierarchy Standard (FHS)**. Anders als bei Windows gibt es keine Laufwerksbuchstaben (C:, D:) - alles beginnt bei `/` (root).

```
/
├── bin      → Wichtige Basis-Programme
├── boot     → Bootloader, Kernel
├── dev      → Gerätedateien
├── etc      → Konfigurationsdateien
├── home     → Benutzer-Verzeichnisse
├── lib      → Bibliotheken für /bin und /sbin
├── media    → Wechselmedien (USB, CD)
├── mnt      → Temporäre Mountpoints
├── opt      → Optionale Software
├── proc     → Prozess-Informationen (virtuell)
├── root     → Home-Verzeichnis von root
├── run      → Laufzeit-Daten
├── sbin     → System-Programme (für root)
├── srv      → Service-Daten
├── sys      → System-Hardware-Info (virtuell)
├── tmp      → Temporäre Dateien
├── usr      → User-Programme und Daten
└── var      → Variable Daten (Logs, Spool)
```

## Wichtige Verzeichnisse im Detail

### `/` - Das Root-Verzeichnis

Die Wurzel des gesamten Dateisystems. Alles andere hängt hier drunter.

### `/home` - Benutzerverzeichnisse

Jeder Benutzer hat hier sein eigenes Verzeichnis:
```
/home/
├── student/    → Home von "student"
├── alice/      → Home von "alice"
└── bob/        → Home von "bob"
```

Die Abkürzung `~` zeigt auf dein Home: `~` = `/home/student`

### `/etc` - Konfiguration

**Etc** steht für "Editable Text Configuration". Hier liegen fast alle Systemkonfigurationen:

| Datei/Ordner | Inhalt |
|--------------|--------|
| `/etc/passwd` | Benutzer-Datenbank |
| `/etc/shadow` | Passwort-Hashes |
| `/etc/group` | Gruppen |
| `/etc/hosts` | Statische Hostnamen |
| `/etc/hostname` | Eigener Hostname |
| `/etc/fstab` | Dateisystem-Mountpoints |
| `/etc/ssh/` | SSH-Konfiguration |
| `/etc/apt/` | Paketquellen |

### `/var` - Variable Daten

Dateien, die sich während des Betriebs ändern:

| Pfad | Inhalt |
|------|--------|
| `/var/log/` | Logdateien |
| `/var/spool/` | Warteschlangen (Mail, Print) |
| `/var/cache/` | Cache-Daten |
| `/var/lib/` | Programm-Datenbanken |
| `/var/www/` | Webserver-Dokumente |

### `/tmp` - Temporäre Dateien

- Jeder kann hier schreiben
- Wird bei Reboot gelöscht (auf den meisten Systemen)
- Hat das **Sticky Bit** gesetzt

### `/proc` - Prozess-Filesystem (virtuell)

Kein echtes Dateisystem auf der Festplatte! Der Kernel generiert diese Dateien dynamisch:

```bash
cat /proc/cpuinfo    # CPU-Information
cat /proc/meminfo    # Speicher-Info
cat /proc/version    # Kernel-Version
ls /proc/1/          # Infos zu Prozess 1 (init/systemd)
```

### `/sys` - System-Filesystem (virtuell)

Ähnlich wie `/proc`, aber für Hardware-Informationen:

```bash
ls /sys/class/net/           # Netzwerk-Interfaces
cat /sys/class/dmi/id/board_name  # Mainboard
```

### `/dev` - Gerätedateien

In Linux ist **alles eine Datei** - auch Hardware:

| Gerät | Bedeutung |
|-------|-----------|
| `/dev/sda` | Erste SATA/SCSI-Festplatte |
| `/dev/sda1` | Erste Partition auf sda |
| `/dev/nvme0n1` | NVMe-SSD |
| `/dev/null` | "Mülleimer" - verschluckt alles |
| `/dev/zero` | Liefert unendlich Nullen |
| `/dev/random` | Zufallszahlen |
| `/dev/tty` | Aktuelles Terminal |

### `/usr` - User Programs

Der größte Bereich, enthält die meiste Software:

```
/usr/
├── bin/      → Benutzer-Programme
├── sbin/     → System-Programme  
├── lib/      → Bibliotheken
├── share/    → Architektur-unabhängige Daten
├── local/    → Lokal installierte Software
└── src/      → Quellcode
```

:::info Historisch
Früher waren `/bin` und `/usr/bin` getrennt. Heute sind sie oft identisch (Symlinks).
:::

### `/opt` - Optionale Software

Für Software von Drittanbietern, die nicht aus der Paketverwaltung kommt:
- `/opt/google/chrome/`
- `/opt/lampp/`

### `/boot` - Boot-Dateien

- Linux-Kernel (`vmlinuz-*`)
- Initial RAM Disk (`initrd.img-*`)
- GRUB Bootloader

### `/root` - Home des Root-Users

Der Root-User hat sein Home nicht in `/home`, sondern in `/root`.

## Pfade

### Absolute vs. Relative Pfade

| Typ | Beschreibung | Beispiel |
|-----|--------------|----------|
| **Absolut** | Beginnt bei `/` | `/home/student/docs/file.txt` |
| **Relativ** | Relativ zum aktuellen Verzeichnis | `docs/file.txt` oder `./docs/file.txt` |

### Spezielle Pfad-Symbole

| Symbol | Bedeutung |
|--------|-----------|
| `/` | Root-Verzeichnis |
| `~` | Home-Verzeichnis |
| `.` | Aktuelles Verzeichnis |
| `..` | Übergeordnetes Verzeichnis |
| `-` | Vorheriges Verzeichnis (bei `cd`) |

```bash
cd /var/log      # Absolut
cd ..            # Nach /var
cd ../..         # Nach /
cd ~/docs        # Nach /home/student/docs
cd -             # Zurück nach /var
```

## Alles ist eine Datei

Ein fundamentales Linux-Konzept: **Alles wird als Datei dargestellt**

- Normale Dateien
- Verzeichnisse (spezielle Dateien)
- Geräte (Block- und Character-Devices)
- Pipes (für Inter-Process Communication)
- Sockets (für Netzwerk)
- Symbolic Links (Verknüpfungen)

### Dateitypen erkennen

Mit `ls -l` siehst du den Dateityp am ersten Zeichen:

```
-rw-r--r--  →  - = Normale Datei
drwxr-xr-x  →  d = Directory
lrwxrwxrwx  →  l = Symbolic Link
crw-rw----  →  c = Character Device
brw-rw----  →  b = Block Device
```

Mit `file` kannst du den Inhalt prüfen:
```bash
file /bin/ls
# /bin/ls: ELF 64-bit LSB pie executable...

file /etc/passwd
# /etc/passwd: ASCII text
```

## Links

### Symbolic Links (Soft Links)

Wie Verknüpfungen in Windows - zeigen auf einen anderen Pfad:

```bash
ln -s /var/log ~/logs
# ~/logs zeigt jetzt auf /var/log

ls -l ~/logs
# lrwxrwxrwx ... logs -> /var/log
```

- Kann auf Verzeichnisse zeigen
- Kann über Dateisysteme hinweg zeigen
- Wenn Ziel gelöscht wird → Broken Link

### Hard Links

Mehrere Namen für dieselbe Datei (gleiche Inode):

```bash
ln original.txt hardlink.txt
```

- Nur für Dateien, nicht für Verzeichnisse
- Nur im gleichen Dateisystem
- Datei existiert, solange mindestens ein Link existiert

## Wichtige Befehle

| Befehl | Funktion |
|--------|----------|
| `ls` | Verzeichnisinhalt auflisten |
| `cd` | Verzeichnis wechseln |
| `pwd` | Aktuelles Verzeichnis anzeigen |
| `mkdir` | Verzeichnis erstellen |
| `rmdir` | Leeres Verzeichnis löschen |
| `rm` | Dateien/Verzeichnisse löschen |
| `cp` | Kopieren |
| `mv` | Verschieben/Umbenennen |
| `touch` | Leere Datei erstellen / Timestamp ändern |
| `ln` | Links erstellen |
| `find` | Dateien suchen |
| `locate` | Dateien schnell finden (Index) |
| `tree` | Verzeichnisbaum anzeigen |

## Zusammenfassung

- Linux hat eine standardisierte Verzeichnisstruktur (FHS)
- Alles beginnt bei `/` (root)
- `/etc` = Konfiguration, `/var` = variable Daten, `/home` = Benutzer
- `/proc` und `/sys` sind virtuelle Dateisysteme
- Alles ist eine Datei - auch Geräte
- Absolute Pfade beginnen mit `/`, relative nicht

Jetzt ab ins [erste Lab](./02_lab_erkunden.md)!
