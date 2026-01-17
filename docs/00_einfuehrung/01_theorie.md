---
title: Was ist Linux?
sidebar_position: 1
---

# Einführung in Linux

## Was ist Linux?

Linux ist ein **Betriebssystem-Kernel** - der Kern, der die Hardware steuert und Programme ausführt. Was wir umgangssprachlich "Linux" nennen, ist eigentlich eine **Distribution**: Ein Paket aus dem Linux-Kernel plus Software, Tools und Paketverwaltung.

```
┌─────────────────────────────────────┐
│           Anwendungen               │
│    (Firefox, nginx, vim, ...)       │
├─────────────────────────────────────┤
│              Shell                  │
│         (bash, zsh, ...)            │
├─────────────────────────────────────┤
│         System-Bibliotheken         │
│            (glibc, ...)             │
├─────────────────────────────────────┤
│          Linux Kernel               │
│   (Prozesse, Speicher, Treiber)     │
├─────────────────────────────────────┤
│            Hardware                 │
│     (CPU, RAM, Festplatten)         │
└─────────────────────────────────────┘
```

## Kernel vs. Distribution

| Begriff | Bedeutung |
|---------|-----------|
| **Kernel** | Der eigentliche Linux-Kern, entwickelt von Linus Torvalds und der Community |
| **Distribution** | Komplettes Betriebssystem mit Kernel, Tools, Paketverwaltung, ggf. Desktop |
| **Shell** | Kommandozeilen-Interpreter (z.B. bash) |

## Wichtige Distributionen

### Debian-Familie (unser Fokus)

- **Debian** - Urgestein, sehr stabil, langsame Updates
- **Ubuntu** - Benutzerfreundlich, regelmäßige Releases, große Community
- **Linux Mint** - Ubuntu-basiert, Desktop-fokussiert

Paketverwaltung: `apt`, `dpkg`

### Red Hat Familie

- **RHEL** (Red Hat Enterprise Linux) - Kommerziell, Support
- **CentOS Stream** - RHEL-Upstream
- **Fedora** - Cutting-Edge, Testfeld für RHEL
- **Rocky Linux / AlmaLinux** - RHEL-Klone

Paketverwaltung: `dnf`, `yum`, `rpm`

### SUSE Familie

- **SLES** (SUSE Linux Enterprise Server) - Kommerziell
- **openSUSE** - Community-Version

Paketverwaltung: `zypper`, `rpm`

:::info Wir nutzen Ubuntu
In dieser Schulung arbeiten wir mit **Ubuntu Server 24.04 LTS**. Die Konzepte sind aber auf alle Distributionen übertragbar - nur die Befehle unterscheiden sich manchmal.
:::

## Warum Linux für Server?

| Vorteil | Erklärung |
|---------|-----------|
| **Kostenlos** | Keine Lizenzkosten (außer bei Support-Verträgen) |
| **Stabil** | Läuft monatelang ohne Reboot |
| **Sicher** | Schnelle Security-Updates, offener Code |
| **Flexibel** | Vom Raspberry Pi bis zum Supercomputer |
| **Automatisierbar** | Alles ist skriptbar |

## Die Kommandozeile

Auf Servern arbeiten wir fast ausschließlich mit der **Kommandozeile** (CLI = Command Line Interface). Warum?

- **Ressourcenschonend** - Kein Desktop nötig
- **Remote-Zugriff** - SSH funktioniert überall
- **Automatisierbar** - Befehle in Skripte packen
- **Reproduzierbar** - Dokumentation durch Befehlshistorie

### Anatomie eines Befehls

```bash
command -options arguments
```

Beispiel:
```bash
ls -la /var/log
│   │   └─ Argument (Verzeichnis)
│   └─ Optionen (long + all)
└─ Befehl (list)
```

## Erste wichtige Befehle

| Befehl | Funktion |
|--------|----------|
| `whoami` | Zeigt aktuellen Benutzer |
| `pwd` | Print Working Directory - Wo bin ich? |
| `ls` | Dateien auflisten |
| `cd` | Change Directory - Verzeichnis wechseln |
| `cat` | Dateiinhalt anzeigen |
| `man` | Manual - Hilfe zu einem Befehl |

### Beispiel-Session

```bash
student@ubuntu-server:~$ whoami
student

student@ubuntu-server:~$ pwd
/home/student

student@ubuntu-server:~$ ls
Desktop  Documents  Downloads

student@ubuntu-server:~$ cd /etc
student@ubuntu-server:/etc$ pwd
/etc

student@ubuntu-server:/etc$ ls host*
hostname  hosts  hosts.allow  hosts.deny
```

## Hilfe finden

### man - Die Manpages

```bash
man ls        # Hilfe zu 'ls'
man -k copy   # Suche nach 'copy' in allen Manpages
```

Navigation in man:
- `Space` / `Page Down` - Seite vor
- `b` / `Page Up` - Seite zurück
- `/suchbegriff` - Suchen
- `q` - Beenden

### --help

Fast jeder Befehl unterstützt:
```bash
ls --help
```

### info

Alternative zu man (manchmal ausführlicher):
```bash
info ls
```

## Der Prompt

```
student@ubuntu-server:~$
│       │              │ │
│       │              │ └─ $ = normaler User (# = root)
│       │              └─ Aktuelles Verzeichnis (~ = Home)
│       └─ Hostname
└─ Username
```

## Tab-Completion

Die **Tab-Taste** ist dein bester Freund:

```bash
cd /etc/sys<TAB>
→ cd /etc/systemd/

cat /etc/pa<TAB><TAB>
→ zeigt: passwd  pam.conf  pam.d/
```

:::tip
Zweimal Tab drücken zeigt alle Möglichkeiten!
:::

## Zusammenfassung

- Linux = Kernel + Distribution
- Ubuntu ist eine Debian-basierte Distribution
- Andere Distros nutzen andere Paketverwaltung (rpm, dnf, zypper)
- Server-Administration = Kommandozeile
- `man` und `--help` sind deine Dokumentation
- Tab-Completion spart Tipparbeit

Jetzt geht's ans Eingemachte - ab ins [Lab](./02_lab.md)!
