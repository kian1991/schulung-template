---
title: Benutzerverwaltung
sidebar_position: 1
---

# Benutzerverwaltung

## User und Gruppen Konzept

Linux ist ein **Mehrbenutzersystem**. Jeder Benutzer hat:
- **UID** (User ID) - Numerische Kennung
- **Username** - Lesbare Kennung
- **Home-Verzeichnis** - Persönlicher Bereich
- **Login-Shell** - Standardprogramm nach Login
- **Gruppen** - Für gemeinsame Rechte

```
┌─────────────────────────────────────────┐
│              Benutzer                   │
├─────────────────────────────────────────┤
│  root (UID 0)       ← Superuser         │
│  student (UID 1000) ← Erster User       │
│  alice (UID 1001)   ← Weitere User      │
│  www-data (UID 33)  ← System-Account    │
└─────────────────────────────────────────┘
```

## Wichtige Dateien

### /etc/passwd - Benutzerdatenbank

```bash
cat /etc/passwd
```

Format: `username:x:UID:GID:GECOS:home:shell`

```
student:x:1000:1000:Student User:/home/student:/bin/bash
│       │ │    │    │            │             └─ Login-Shell
│       │ │    │    │            └─ Home-Verzeichnis
│       │ │    │    └─ Kommentar (Name, etc.)
│       │ │    └─ Primäre Gruppen-ID
│       │ └─ User-ID
│       └─ Passwort (x = in /etc/shadow)
└─ Benutzername
```

### /etc/shadow - Passwort-Hashes

```bash
sudo cat /etc/shadow
```

Nur für root lesbar! Enthält:
- Gehashte Passwörter
- Passwort-Alterung
- Account-Ablaufdatum

### /etc/group - Gruppendatenbank

```bash
cat /etc/group
```

Format: `groupname:x:GID:members`

```
developers:x:1002:alice,bob,student
│          │ │    └─ Mitglieder (zusätzlich zu deren Primärgruppe)
│          │ └─ Gruppen-ID
│          └─ Passwort (x = in /etc/gshadow, selten genutzt)
└─ Gruppenname
```

## Benutzer verwalten

### Benutzer anlegen

```bash
# Einfach (mit Standardwerten)
sudo useradd alice

# Mit Home-Verzeichnis und Shell
sudo useradd -m -s /bin/bash alice

# Vollständig
sudo useradd -m -s /bin/bash -c "Alice Smith" -G developers alice
```

| Option | Bedeutung |
|--------|-----------|
| `-m` | Home-Verzeichnis erstellen |
| `-s` | Shell festlegen |
| `-c` | Kommentar (voller Name) |
| `-G` | Zusätzliche Gruppen |
| `-g` | Primäre Gruppe |
| `-u` | UID festlegen |
| `-d` | Home-Pfad festlegen |

### Benutzer ändern

```bash
# Shell ändern
sudo usermod -s /bin/zsh alice

# Zu Gruppe hinzufügen (WICHTIG: -a für append!)
sudo usermod -aG docker alice

# Kommentar ändern
sudo usermod -c "Alice Administrator" alice

# Account sperren
sudo usermod -L alice

# Account entsperren
sudo usermod -U alice
```

:::warning Ohne -a bei -G!
`usermod -G gruppe user` **ersetzt** alle Gruppen!
`usermod -aG gruppe user` **fügt hinzu**.
:::

### Benutzer löschen

```bash
# Nur Benutzer löschen (Home bleibt)
sudo userdel alice

# Mit Home-Verzeichnis löschen
sudo userdel -r alice
```

## Passwörter

### Passwort setzen

```bash
# Interaktiv
sudo passwd alice

# Als User eigenes Passwort ändern
passwd

# Sofort Passwortänderung erzwingen
sudo passwd -e alice
```

### Passwort-Alterung

```bash
# Infos anzeigen
sudo chage -l alice

# Ablauf nach 90 Tagen
sudo chage -M 90 alice

# Mindestzeit zwischen Änderungen
sudo chage -m 7 alice

# Warnung 14 Tage vorher
sudo chage -W 14 alice

# Account-Ablaufdatum
sudo chage -E 2025-12-31 alice

# Interaktiv alle Optionen
sudo chage alice
```

## Gruppen

### Gruppe erstellen

```bash
sudo groupadd developers
sudo groupadd -g 2000 admins   # Mit GID
```

### Gruppe löschen

```bash
sudo groupdel developers
```

### Gruppenmitgliedschaft

```bash
# Benutzer zu Gruppe hinzufügen
sudo usermod -aG developers alice

# Oder mit gpasswd
sudo gpasswd -a alice developers

# Benutzer aus Gruppe entfernen
sudo gpasswd -d alice developers

# Gruppen eines Users anzeigen
groups alice
id alice
```

### Primäre vs. Sekundäre Gruppen

- **Primäre Gruppe**: Eine pro User, in `/etc/passwd`
- **Sekundäre Gruppen**: Beliebig viele, in `/etc/group`

```bash
# Primäre Gruppe ändern
sudo usermod -g developers alice
```

## sudo - Administratorrechte

`sudo` ermöglicht autorisierten Usern, Befehle als root auszuführen.

### sudo verwenden

```bash
# Befehl als root
sudo apt update

# Als anderer User
sudo -u www-data whoami

# Root-Shell
sudo -i
# oder
sudo su -
```

### sudo konfigurieren

Die Konfiguration liegt in `/etc/sudoers`. **Nie direkt editieren!**

```bash
# Sicher editieren
sudo visudo

# Oder Datei in /etc/sudoers.d/ anlegen
sudo visudo -f /etc/sudoers.d/developers
```

**Beispiel-Regeln:**

```sudoers
# User darf alles
alice ALL=(ALL:ALL) ALL

# User darf alles ohne Passwort
bob ALL=(ALL:ALL) NOPASSWD: ALL

# Gruppe darf bestimmte Befehle
%developers ALL=(ALL) /usr/bin/systemctl restart nginx

# Mehrere Befehle
%webadmins ALL=(ALL) /usr/bin/systemctl restart nginx, /usr/bin/systemctl status nginx
```

Format: `WHO WHERE=(AS_WHO) WHAT`

### sudo-Gruppe

In Ubuntu ist die Gruppe `sudo` vorkonfiguriert:

```bash
# User zur sudo-Gruppe hinzufügen
sudo usermod -aG sudo alice

# Prüfen wer in sudo ist
grep sudo /etc/group
```

## Das Root-Konto

- **UID 0** - Hat alle Rechte
- **Home:** `/root`
- In Ubuntu standardmäßig **kein direkter Login** (kein Passwort)

```bash
# Als root arbeiten (temporär)
sudo -i

# Root-Passwort setzen (normalerweise nicht empfohlen!)
sudo passwd root

# Zurück zum normalen User
exit
```

:::tip Best Practice
Nutze `sudo` statt als root einzuloggen. Das wird protokolliert!
:::

## System-Accounts

Dienste laufen unter speziellen System-Accounts:

| Account | Dienst |
|---------|--------|
| `www-data` | Apache, Nginx |
| `mysql` | MySQL/MariaDB |
| `nobody` | Unprivilegiert |
| `sshd` | SSH-Daemon |

Diese haben meist:
- Kein Home-Verzeichnis (oder `/nonexistent`)
- Shell `/usr/sbin/nologin` oder `/bin/false`
- UID < 1000

## Account-Status prüfen

```bash
# User-Infos
id alice
# uid=1001(alice) gid=1001(alice) groups=1001(alice),1002(developers)

# Passwort-Status
sudo passwd -S alice
# alice P 01/15/2025 0 99999 7 -1
# P = Passwort gesetzt, L = gesperrt

# Login-Infos
last alice            # Letzte Logins
lastlog              # Alle User
faillog -u alice     # Fehlgeschlagene Logins
```

## Zusammenfassung

| Aufgabe | Befehl |
|---------|--------|
| User anlegen | `sudo useradd -m -s /bin/bash USER` |
| User löschen | `sudo userdel -r USER` |
| Passwort setzen | `sudo passwd USER` |
| User ändern | `sudo usermod OPTIONS USER` |
| Zu Gruppe hinzufügen | `sudo usermod -aG GRUPPE USER` |
| Gruppe anlegen | `sudo groupadd GRUPPE` |
| Gruppen anzeigen | `groups USER` oder `id USER` |
| Account sperren | `sudo usermod -L USER` |
| sudo-Rechte | `sudo visudo` |

---

Jetzt ab ins [Lab: Benutzer anlegen](./02_lab_benutzer.md)!
