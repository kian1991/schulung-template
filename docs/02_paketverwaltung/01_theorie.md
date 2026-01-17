---
title: Paketverwaltung
sidebar_position: 1
---

# Paketverwaltung unter Ubuntu/Debian

## Was sind Pakete?

Ein **Paket** ist ein Archiv, das Software enthält:
- Ausführbare Programme
- Bibliotheken
- Konfigurationsdateien
- Dokumentation
- Metadaten (Abhängigkeiten, Version, Beschreibung)

## Warum Paketverwaltung?

| Ohne Paketverwaltung | Mit Paketverwaltung |
|---------------------|---------------------|
| Software manuell herunterladen | Aus Repository installieren |
| Abhängigkeiten selbst finden | Automatisch aufgelöst |
| Updates manuell prüfen | Zentral aktualisierbar |
| Deinstallation: Dateien überall | Saubere Entfernung |

## Ubuntu/Debian: dpkg und apt

Ubuntu/Debian nutzt das **DEB**-Paketformat mit zwei Werkzeugschichten:

```
┌─────────────────────────────────────┐
│            apt / apt-get            │  ← High-Level (Repositories, Abhängigkeiten)
├─────────────────────────────────────┤
│               dpkg                  │  ← Low-Level (einzelne .deb Pakete)
├─────────────────────────────────────┤
│         .deb Paket-Dateien          │
└─────────────────────────────────────┘
```

### dpkg - Low-Level

`dpkg` arbeitet direkt mit `.deb`-Dateien:
- Installiert/entfernt einzelne Pakete
- Keine automatische Abhängigkeitsauflösung
- Keine Repository-Verwaltung

### apt - High-Level

`apt` ist der moderne Paketmanager:
- Arbeitet mit Repositories
- Löst Abhängigkeiten automatisch auf
- Einfache Syntax

:::info Andere Distributionen
RPM-basierte Distros (RHEL, Fedora, SUSE) nutzen `rpm` als Low-Level-Tool und `dnf`/`yum`/`zypper` als High-Level. Die Konzepte sind ähnlich, nur die Befehle unterscheiden sich.
:::

## Repositories (Paketquellen)

Pakete kommen aus **Repositories** - Online-Paketsammlungen.

### Repository-Konfiguration

Die Quellen stehen in:
- `/etc/apt/sources.list` - Hauptkonfiguration
- `/etc/apt/sources.list.d/*.list` - Zusätzliche Quellen

```bash
cat /etc/apt/sources.list
```

Typischer Eintrag:
```
deb http://archive.ubuntu.com/ubuntu noble main restricted universe multiverse
```

| Teil | Bedeutung |
|------|-----------|
| `deb` | Binärpakete (vs. `deb-src` für Quellcode) |
| URL | Repository-Adresse |
| `noble` | Ubuntu-Codename (24.04) |
| `main` | Offiziell unterstützt |
| `restricted` | Proprietäre Treiber |
| `universe` | Community-gepflegt |
| `multiverse` | Nicht-freie Software |

### Paketlisten aktualisieren

```bash
sudo apt update
```

Dies lädt die **Paketlisten** herunter - nicht die Pakete selbst! Nach `apt update` weiß dein System, welche Pakete in welchen Versionen verfügbar sind.

## apt - Die wichtigsten Befehle

### Pakete aktualisieren

```bash
# Paketlisten aktualisieren
sudo apt update

# Installierte Pakete upgraden
sudo apt upgrade

# Beides zusammen
sudo apt update && sudo apt upgrade
```

### Pakete suchen

```bash
# Nach Paket suchen
apt search nginx

# Paket-Informationen anzeigen
apt show nginx
```

### Pakete installieren

```bash
# Einzelnes Paket
sudo apt install nginx

# Mehrere Pakete
sudo apt install nginx php mysql-server

# Bestimmte Version
sudo apt install nginx=1.24.0-1ubuntu1

# Ohne Nachfrage (für Skripte)
sudo apt install -y nginx
```

### Pakete entfernen

```bash
# Entfernen (Konfiguration bleibt)
sudo apt remove nginx

# Vollständig entfernen (inkl. Konfiguration)
sudo apt purge nginx

# Nicht mehr benötigte Abhängigkeiten entfernen
sudo apt autoremove
```

### System aufräumen

```bash
# Paket-Cache leeren
sudo apt clean        # Alles löschen
sudo apt autoclean    # Nur veraltete

# Verwaiste Pakete entfernen
sudo apt autoremove
```

## dpkg - Low-Level-Operationen

### .deb-Pakete direkt installieren

```bash
# Herunterladen (z.B. von einer Website)
wget https://example.com/programm.deb

# Installieren
sudo dpkg -i programm.deb

# Falls Abhängigkeiten fehlen:
sudo apt install -f   # -f = fix broken
```

### Paket-Informationen

```bash
# Alle installierten Pakete
dpkg -l

# Bestimmtes Paket suchen
dpkg -l | grep nginx
dpkg -l nginx

# Welche Dateien gehören zum Paket?
dpkg -L nginx

# Welches Paket hat diese Datei installiert?
dpkg -S /usr/bin/ssh
```

### Paket-Status

| Zeichen | Bedeutung |
|---------|-----------|
| `ii` | Installiert |
| `rc` | Entfernt, Konfiguration vorhanden |
| `un` | Nicht installiert |
| `iF` | Fehlerhafte Installation |

## PPAs (Personal Package Archives)

PPAs sind zusätzliche Repositories, oft für neuere Software-Versionen.

```bash
# PPA hinzufügen
sudo add-apt-repository ppa:ondrej/php

# Paketlisten aktualisieren
sudo apt update

# Software aus PPA installieren
sudo apt install php8.3

# PPA entfernen
sudo add-apt-repository --remove ppa:ondrej/php
```

:::warning PPAs mit Vorsicht!
PPAs sind nicht offiziell unterstützt. Nutze sie nur von vertrauenswürdigen Quellen.
:::

## Praktische Tipps

### Simulation

Was würde passieren, ohne wirklich zu installieren?

```bash
apt install --dry-run nginx
# oder
apt install -s nginx
```

### Paket-Informationen offline

```bash
# Nach Download aber vor Installation
dpkg -I paket.deb    # Info
dpkg -c paket.deb    # Inhalt (Dateiliste)
```

### Alte Kernel entfernen

```bash
# Zeige installierte Kernel
dpkg -l | grep linux-image

# Entferne alte (behalte den aktuellen!)
sudo apt autoremove --purge
```

### Held Packages (Version einfrieren)

```bash
# Paket auf aktuelle Version halten
sudo apt-mark hold nginx

# Wieder freigeben
sudo apt-mark unhold nginx

# Gehaltene Pakete anzeigen
apt-mark showhold
```

## Zusammenfassung

| Aufgabe | Befehl |
|---------|--------|
| Paketlisten aktualisieren | `sudo apt update` |
| System upgraden | `sudo apt upgrade` |
| Paket installieren | `sudo apt install PAKET` |
| Paket entfernen | `sudo apt remove PAKET` |
| Vollständig entfernen | `sudo apt purge PAKET` |
| Aufräumen | `sudo apt autoremove` |
| Paket suchen | `apt search BEGRIFF` |
| Paket-Info | `apt show PAKET` |
| Installierte Pakete | `dpkg -l` |
| Dateien eines Pakets | `dpkg -L PAKET` |
| Paket zu Datei finden | `dpkg -S /pfad/datei` |

---

Jetzt ab ins [Lab: Software installieren](./02_lab_installieren.md)!
