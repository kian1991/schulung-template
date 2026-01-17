---
title: "Lab: Erste Schritte"
sidebar_position: 2
---

# Lab: Erste Schritte mit Linux

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

In diesem Lab machst du dich mit der Linux-Kommandozeile vertraut. Du lernst die wichtigsten Befehle und wie du Hilfe findest.

## Vorbereitung

1. Starte deine Ubuntu VM in VirtualBox
2. Logge dich ein (User: `student`, Passwort: wie bei Installation gesetzt)

Alternativ: Verbinde dich per SSH:
```bash
ssh student@localhost -p 2222
```

---

## Aufgabe 1: Wer bin ich und wo bin ich?

Finde heraus:
- Als welcher Benutzer bist du eingeloggt?
- In welchem Verzeichnis befindest du dich?
- Wie heißt der Server (Hostname)?

<details>
<summary>Lösung anzeigen</summary>

```bash
# Aktueller Benutzer
whoami
# Ausgabe: student

# Aktuelles Verzeichnis
pwd
# Ausgabe: /home/student

# Hostname
hostname
# Ausgabe: ubuntu-server

# Alles auf einmal sehen im Prompt:
# student@ubuntu-server:~$
```

</details>

---

## Aufgabe 2: Dateien auflisten

1. Liste alle Dateien in deinem Home-Verzeichnis auf
2. Liste alle Dateien **inklusive versteckter** Dateien auf
3. Liste alle Dateien mit Details (Berechtigungen, Größe, Datum)

<details>
<summary>Lösung anzeigen</summary>

```bash
# Einfache Auflistung
ls

# Mit versteckten Dateien (beginnen mit .)
ls -a
# Du siehst jetzt .bashrc, .profile etc.

# Mit Details
ls -l

# Beides kombiniert
ls -la

# Oder ausgeschrieben
ls --all --long
```

</details>

---

## Aufgabe 3: Navigation

1. Wechsle ins Verzeichnis `/etc`
2. Zeige an, wo du jetzt bist
3. Gehe zurück in dein Home-Verzeichnis (3 verschiedene Wege!)
4. Wechsle nach `/var/log`
5. Gehe einen Ordner nach oben (nach `/var`)

<details>
<summary>Lösung anzeigen</summary>

```bash
# Nach /etc wechseln
cd /etc

# Wo bin ich?
pwd
# Ausgabe: /etc

# Zurück nach Home - 3 Wege:
cd                  # Ohne Argument = Home
cd ~                # ~ ist Abkürzung für Home
cd /home/student    # Absoluter Pfad

# Nach /var/log
cd /var/log

# Einen Ordner nach oben
cd ..
pwd
# Ausgabe: /var
```

**Merke:**
- `~` = Home-Verzeichnis
- `.` = aktuelles Verzeichnis
- `..` = übergeordnetes Verzeichnis
- `-` = vorheriges Verzeichnis (`cd -`)

</details>

---

## Aufgabe 4: Hilfe nutzen

1. Öffne die Manpage von `ls`
2. Finde heraus, was die Option `-h` bei `ls` macht
3. Suche in den Manpages nach Befehlen zum Thema "copy"
4. Zeige die Kurzhelp von `cp` an

<details>
<summary>Lösung anzeigen</summary>

```bash
# Manpage öffnen
man ls
# Navigation: Space=vor, b=zurück, q=beenden
# Suchen: /human drücken, Enter

# -h = human-readable (Größen in KB, MB, GB statt Bytes)
ls -lh /var/log

# Suche in Manpages
man -k copy
# Zeigt alle Manpages die "copy" enthalten

# Kurzhelp
cp --help
```

</details>

---

## Aufgabe 5: Tab-Completion üben

Tippe die folgenden Befehle und nutze **Tab zur Vervollständigung**:

1. `cd /etc/sys` + Tab
2. `cat /etc/os-rel` + Tab
3. `cat /etc/pa` + Tab + Tab

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Wird zu:
cd /etc/systemd/

# 2. Wird zu:
cat /etc/os-release
# Zeigt Ubuntu-Version an!

# 3. Zeigt Optionen:
# pam.conf  pam.d/  passwd
# Dann weiter tippen: pas + Tab
cat /etc/passwd
```

**Tipp:** Wenn nichts passiert, gibt es entweder keine Übereinstimmung oder mehrere Möglichkeiten (dann zweimal Tab drücken).

</details>

---

## Aufgabe 6: Dateien lesen

1. Zeige den Inhalt von `/etc/hostname` an
2. Zeige die ersten 5 Zeilen von `/etc/passwd`
3. Zeige die letzten 3 Zeilen von `/etc/passwd`
4. Öffne `/etc/passwd` in einem Pager (scrollbar)

<details>
<summary>Lösung anzeigen</summary>

```bash
# Gesamter Inhalt
cat /etc/hostname

# Erste 5 Zeilen
head -5 /etc/passwd
# oder
head -n 5 /etc/passwd

# Letzte 3 Zeilen
tail -3 /etc/passwd
# oder
tail -n 3 /etc/passwd

# Im Pager öffnen
less /etc/passwd
# Navigation: Pfeiltasten, Space, b, /suche, q
```

</details>

---

## Aufgabe 7: SSH-Verbindung aufbauen

Wenn du noch nicht per SSH verbunden bist:

1. Öffne ein Terminal auf deinem **Host-System** (nicht in der VM)
2. Verbinde dich per SSH zur VM
3. Führe einen Befehl aus
4. Beende die SSH-Sitzung

<details>
<summary>Lösung anzeigen</summary>

```bash
# Auf dem Host-System:
ssh student@localhost -p 2222

# Beim ersten Mal: Fingerprint bestätigen mit "yes"

# Jetzt bist du in der VM
whoami
# student

hostname
# ubuntu-server

# Sitzung beenden
exit
# oder Strg+D
```

**Tipp für macOS/Linux:** Du kannst die Verbindung in `~/.ssh/config` speichern:

```
Host ubuntu-vm
    HostName localhost
    User student
    Port 2222
```

Dann reicht: `ssh ubuntu-vm`

</details>

---

## Aufgabe 8: System-Informationen

Finde folgende Informationen über dein System:

1. Welche Ubuntu-Version läuft?
2. Welcher Kernel ist installiert?
3. Wie viel RAM hat das System?
4. Wie lange läuft das System schon (Uptime)?

<details>
<summary>Lösung anzeigen</summary>

```bash
# Ubuntu-Version
cat /etc/os-release
# oder
lsb_release -a

# Kernel-Version
uname -r
# z.B. 6.8.0-41-generic

# Alle Kernel-Infos
uname -a

# RAM
free -h
# -h = human-readable

# Uptime
uptime
# zeigt auch Load Average
```

</details>

---

## Aufgabe 9: Befehle verketten

1. Zeige alle Dateien in `/etc` die mit "host" beginnen
2. Zähle, wie viele Zeilen `/etc/passwd` hat
3. Zeige alle Benutzer sortiert nach Namen

<details>
<summary>Lösung anzeigen</summary>

```bash
# Dateien mit "host" am Anfang
ls /etc/host*

# Zeilen zählen mit wc (word count)
wc -l /etc/passwd
# oder mit Pipe
cat /etc/passwd | wc -l

# Sortierte Benutzer (nur Benutzernamen)
cut -d: -f1 /etc/passwd | sort
# cut: Spalte 1, Trennzeichen ":"
# sort: alphabetisch sortieren
```

</details>

---

## Aufgabe 10: Befehls-History

1. Zeige die letzten 10 ausgeführten Befehle
2. Führe den letzten Befehl erneut aus
3. Suche in der History nach "cat"

<details>
<summary>Lösung anzeigen</summary>

```bash
# Letzte 10 Befehle
history 10

# Letzten Befehl wiederholen
!!

# Bestimmten Befehl aus History (z.B. Nr. 42)
!42

# In History suchen: Strg+R, dann tippen
# (reverse-i-search)`cat': cat /etc/passwd
# Enter zum Ausführen, Strg+C zum Abbrechen
```

</details>

---

## Bonus-Aufgabe: Das System erkunden

Erkunde selbstständig:

1. Was ist in `/proc/cpuinfo`? Was sagt dir das über deine VM?
2. Was zeigt `/proc/meminfo`?
3. Was steht in `/etc/shells`?
4. Welche Benutzer sind gerade eingeloggt?

<details>
<summary>Lösung anzeigen</summary>

```bash
# CPU-Informationen
cat /proc/cpuinfo
# Zeigt Prozessor-Details, Anzahl Kerne, etc.

# Speicher-Details
cat /proc/meminfo
# Detaillierter als 'free'

# Verfügbare Shells
cat /etc/shells
# /bin/bash, /bin/sh, etc.

# Eingeloggte Benutzer
who
# oder
w
# 'w' zeigt auch was die User gerade tun
```

</details>

---

## Zusammenfassung

Du hast gelernt:

| Befehl | Funktion |
|--------|----------|
| `whoami` | Aktueller Benutzer |
| `pwd` | Aktuelles Verzeichnis |
| `hostname` | Servername |
| `ls` | Dateien auflisten |
| `cd` | Verzeichnis wechseln |
| `cat` | Datei anzeigen |
| `head` / `tail` | Anfang/Ende einer Datei |
| `less` | Datei im Pager |
| `man` | Manpages |
| `history` | Befehlshistorie |
| `uname` | Kernel-Info |
| `free` | RAM-Info |
| `uptime` | System-Laufzeit |

**Wichtige Tastenkürzel:**
- `Tab` - Autovervollständigung
- `Strg+C` - Befehl abbrechen
- `Strg+D` - Logout / EOF
- `Strg+R` - History-Suche
- `Strg+L` - Bildschirm löschen (wie `clear`)

---

Weiter geht's mit dem [Dateisystem](../01_dateisystem_navigation/01_theorie.md)!
