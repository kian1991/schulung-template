---
title: "Lab: Dateisystem erkunden"
sidebar_position: 2
---

# Lab: Dateisystem erkunden

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

In diesem Lab erkundest du das Linux-Dateisystem und lernst, dich darin zurechtzufinden.

---

## Aufgabe 1: Wichtige Verzeichnisse erkunden

Navigiere zu den folgenden Verzeichnissen und schau dir den Inhalt an:

1. `/etc` - Was siehst du hier?
2. `/var/log` - Was für Dateien liegen hier?
3. `/home` - Welche Benutzer gibt es?
4. `/tmp` - Ist hier etwas drin?

<details>
<summary>Lösung anzeigen</summary>

```bash
# /etc - Konfigurationsdateien
cd /etc
ls
# Du siehst: passwd, shadow, hosts, hostname, apt/, ssh/, ...

# /var/log - Logdateien
cd /var/log
ls -la
# syslog, auth.log, kern.log, apt/, ...

# /home - Benutzerverzeichnisse
ls /home
# student (und weitere, falls angelegt)

# /tmp - Temporäre Dateien
ls -la /tmp
# Vermutlich ein paar Session-Dateien
```

</details>

---

## Aufgabe 2: Dateien mit "host" finden

Navigiere nach `/etc` und finde alle Dateien, die mit "host" beginnen.

<details>
<summary>Lösung anzeigen</summary>

```bash
cd /etc
ls host*
# hostname  hosts  hosts.allow  hosts.deny

# Oder mit Details:
ls -la host*
```

</details>

---

## Aufgabe 3: Verfügbare Shells

Finde heraus, welche Shells auf dem System installiert sind.

**Tipp:** Die Info steht in einer Datei in `/etc`.

<details>
<summary>Lösung anzeigen</summary>

```bash
cat /etc/shells
```

Typische Ausgabe:
```
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/bin/dash
/usr/bin/dash
```

</details>

---

## Aufgabe 4: CPU-Informationen

Zeige die CPU-Informationen deiner VM an. 

- Wie viele CPUs/Kerne hat die VM?
- Welches CPU-Modell wird emuliert?

<details>
<summary>Lösung anzeigen</summary>

```bash
cat /proc/cpuinfo
```

Interessante Felder:
- `processor` - CPU-Nummer (0, 1, 2, ...)
- `model name` - CPU-Bezeichnung
- `cpu MHz` - Taktfrequenz
- `cache size` - Cache-Größe

Nur die Anzahl:
```bash
grep -c processor /proc/cpuinfo
# oder
nproc
```

</details>

---

## Aufgabe 5: Verzeichnisstruktur erstellen

Erstelle folgende Verzeichnisstruktur in deinem Home-Verzeichnis:

```
~/projekte/
├── webserver/
│   ├── config/
│   ├── logs/
│   └── data/
└── scripts/
```

<details>
<summary>Lösung anzeigen</summary>

```bash
# Methode 1: Einzeln
cd ~
mkdir projekte
mkdir projekte/webserver
mkdir projekte/webserver/config
mkdir projekte/webserver/logs
mkdir projekte/webserver/data
mkdir projekte/scripts

# Methode 2: Mit -p (parent) - erstellt alle Zwischenverzeichnisse
mkdir -p ~/projekte/webserver/{config,logs,data}
mkdir -p ~/projekte/scripts

# Überprüfen
tree ~/projekte
# oder
ls -R ~/projekte
```

Falls `tree` nicht installiert ist:
```bash
sudo apt install tree
```

</details>

---

## Aufgabe 6: Konfigurationsdateien finden

Finde alle `.conf` Dateien in `/etc` und dessen Unterverzeichnissen.

<details>
<summary>Lösung anzeigen</summary>

```bash
# Mit find
find /etc -name "*.conf" 2>/dev/null
# 2>/dev/null unterdrückt "Permission denied" Fehler

# Nur zählen
find /etc -name "*.conf" 2>/dev/null | wc -l

# Mit locate (schneller, aber braucht Index)
# Zuerst Index aktualisieren:
sudo updatedb
locate "*.conf" | grep "^/etc"
```

</details>

---

## Aufgabe 7: Systeminformationen aus /proc

Beantworte folgende Fragen mit Hilfe von `/proc`:

1. Welche Kernel-Version läuft?
2. Wie lautet die Kernel-Kommandozeile (Boot-Parameter)?
3. Wie viel RAM ist total vorhanden und wie viel ist frei?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Kernel-Version
cat /proc/version
# oder
uname -r

# 2. Kernel-Kommandozeile
cat /proc/cmdline
# z.B.: BOOT_IMAGE=/vmlinuz-6.8.0-41-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro

# 3. RAM-Informationen
cat /proc/meminfo | head -5
# MemTotal: Gesamter RAM
# MemFree: Freier RAM
# MemAvailable: Verfügbar für neue Prozesse

# Einfacher mit free:
free -h
```

</details>

---

## Aufgabe 8: Gerätedateien erkunden

Erkunde `/dev`:

1. Welche Festplatten/Blockgeräte gibt es?
2. Was passiert wenn du etwas nach `/dev/null` schreibst?
3. Generiere 10 Zufallsbytes aus `/dev/urandom`

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Blockgeräte
ls /dev/sd*    # SATA/SCSI Disks
ls /dev/nvme*  # NVMe SSDs (falls vorhanden)
# oder besser:
lsblk

# 2. /dev/null - das schwarze Loch
echo "Diese Nachricht verschwindet" > /dev/null
cat /dev/null  # Nichts!

# Nützlich um Ausgaben zu unterdrücken:
ls /nonexistent 2>/dev/null  # Keine Fehlermeldung

# 3. Zufallsbytes
head -c 10 /dev/urandom | xxd
# xxd zeigt Hex-Ausgabe

# Oder als Base64:
head -c 10 /dev/urandom | base64
```

</details>

---

## Aufgabe 9: Dateitypen bestimmen

Bestimme den Typ folgender Dateien mit dem `file` Befehl:

1. `/bin/ls`
2. `/etc/passwd`
3. `/dev/null`
4. `/var/log/syslog` (oder `/var/log/syslog.1`)

<details>
<summary>Lösung anzeigen</summary>

```bash
file /bin/ls
# ELF 64-bit LSB pie executable, x86-64...

file /etc/passwd
# ASCII text

file /dev/null
# character special (1/3)

file /var/log/syslog
# ASCII text, with very long lines

# Mehrere auf einmal:
file /bin/ls /etc/passwd /dev/null
```

</details>

---

## Aufgabe 10: Versteckte Dateien

In Linux beginnen versteckte Dateien mit einem Punkt (`.`).

1. Liste alle versteckten Dateien in deinem Home-Verzeichnis auf
2. Zeige den Inhalt von `.bashrc`
3. Was macht `.bash_history`?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Versteckte Dateien
cd ~
ls -la
# oder nur versteckte:
ls -la .*

# Wichtige versteckte Dateien:
# .bashrc    - Bash-Konfiguration (wird bei jedem neuen Terminal geladen)
# .profile   - Login-Konfiguration
# .bash_history - Befehlshistorie
# .ssh/      - SSH-Schlüssel und Konfiguration

# 2. .bashrc anzeigen
cat ~/.bashrc
# Hier kannst du Aliase, Funktionen, Umgebungsvariablen definieren

# 3. .bash_history
cat ~/.bash_history
# Enthält alle bisher eingegebenen Befehle
# Das ist die Quelle für den 'history' Befehl und Strg+R
```

</details>

---

## Bonus: Plattenspeicher

Finde heraus:

1. Wie voll sind die Dateisysteme?
2. Welches Verzeichnis in `/var` belegt am meisten Platz?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Dateisystem-Belegung
df -h
# -h = human-readable (GB, MB statt Bytes)

# 2. Verzeichnisgrößen in /var
sudo du -sh /var/*
# du = disk usage
# -s = summary (nur Gesamtgröße pro Verzeichnis)
# -h = human-readable

# Top 5 größte:
sudo du -sh /var/* | sort -hr | head -5
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Die wichtigsten Verzeichnisse und deren Zweck
- Navigation mit `cd` und Pfaden
- Informationen aus `/proc` und `/sys` lesen
- Dateitypen mit `file` bestimmen
- Mit `find` nach Dateien suchen
- Versteckte Dateien finden

**Neue Befehle:**

| Befehl | Funktion |
|--------|----------|
| `tree` | Verzeichnisbaum anzeigen |
| `find` | Dateien suchen |
| `file` | Dateityp bestimmen |
| `df` | Dateisystem-Belegung |
| `du` | Verzeichnisgrößen |
| `lsblk` | Blockgeräte auflisten |

---

Weiter zum [nächsten Lab: Dateien manipulieren](./03_lab_manipulieren.md)!
