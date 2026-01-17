---
title: Prozesse und Signale
sidebar_position: 1
---

# Prozesse und Signale

## Was ist ein Prozess?

Ein **Prozess** ist ein laufendes Programm. Jeder Prozess hat:

- **PID** (Process ID) - Eindeutige Nummer
- **PPID** (Parent Process ID) - PID des Elternprozesses
- **UID** - Benutzer, unter dem der Prozess läuft
- **Speicher** - Eigener Adressraum
- **Zustand** - Running, Sleeping, Stopped, Zombie

```
┌─────────────────────────────────────────────────┐
│                  systemd (PID 1)                 │
├──────────────┬──────────────┬───────────────────┤
│   sshd       │    nginx     │     cron          │
│  (PID 532)   │  (PID 1024)  │   (PID 489)       │
├──────────────┤              │                   │
│  sshd        │              │                   │
│ (PID 2841)   │              │                   │
├──────────────┤              │                   │
│   bash       │              │                   │
│ (PID 2842)   │              │                   │
└──────────────┴──────────────┴───────────────────┘
```

## Prozesszustände

| Zustand | Code | Beschreibung |
|---------|------|--------------|
| **Running** | R | Läuft gerade oder wartet auf CPU |
| **Sleeping** | S | Wartet auf Ereignis (I/O, Signal) |
| **Deep Sleep** | D | Ununterbrechbares Warten (meist I/O) |
| **Stopped** | T | Gestoppt (z.B. mit Ctrl+Z) |
| **Zombie** | Z | Beendet, aber Elternprozess hat Exit-Status nicht abgeholt |

## Vordergrund und Hintergrund

### Vordergrund (Foreground)

- Prozess ist mit dem Terminal verbunden
- Empfängt Tastatureingaben
- Terminal ist blockiert bis Prozess endet

### Hintergrund (Background)

- Prozess läuft unabhängig vom Terminal
- Terminal kann für andere Befehle genutzt werden

```bash
# Im Vordergrund starten
sleep 100

# Im Hintergrund starten
sleep 100 &

# Vordergrund → Hintergrund
# Ctrl+Z (stoppen)
bg        # Im Hintergrund fortsetzen

# Hintergrund → Vordergrund
fg
```

### Job Control

```bash
# Hintergrund-Jobs auflisten
jobs

# Job in Vordergrund holen
fg %1          # Job 1
fg %sleep      # Job der "sleep" enthält

# Job im Hintergrund fortsetzen
bg %1
```

## Prozesse anzeigen

### ps - Process Status

```bash
# Eigene Prozesse
ps

# Alle Prozesse
ps aux

# Alle Prozesse mit Baum
ps auxf

# Bestimmte Spalten
ps -eo pid,ppid,user,stat,cmd
```

**ps aux Spalten:**

| Spalte | Bedeutung |
|--------|-----------|
| USER | Benutzer |
| PID | Process ID |
| %CPU | CPU-Auslastung |
| %MEM | Speichernutzung |
| VSZ | Virtueller Speicher (KB) |
| RSS | Physischer Speicher (KB) |
| TTY | Terminal |
| STAT | Status (R/S/D/T/Z) |
| START | Startzeit |
| TIME | CPU-Zeit |
| COMMAND | Befehl |

### pstree - Prozessbaum

```bash
# Gesamter Prozessbaum
pstree

# Mit PIDs
pstree -p

# Für bestimmten Prozess
pstree -p 1
```

### top / htop - Interaktive Ansicht

```bash
# top (überall verfügbar)
top

# htop (benutzerfreundlicher)
htop
```

**htop Tastenkürzel:**

| Taste | Funktion |
|-------|----------|
| F1 | Hilfe |
| F3 | Suchen |
| F4 | Filtern |
| F5 | Baumansicht |
| F6 | Sortierung |
| F9 | Kill |
| F10 | Beenden |
| Space | Markieren |
| k | Kill markierten Prozess |
| u | Nach User filtern |

## Signale

**Signale** sind Nachrichten an Prozesse. Sie können von:
- Anderen Prozessen gesendet werden
- Vom Kernel gesendet werden (z.B. bei Fehlern)
- Durch Tastatur ausgelöst werden (Ctrl+C)

### Wichtige Signale

| Signal | Nr. | Tastatur | Bedeutung |
|--------|-----|----------|-----------|
| SIGHUP | 1 | - | Hangup, oft: Konfiguration neu laden |
| SIGINT | 2 | Ctrl+C | Interrupt, Programm beenden |
| SIGQUIT | 3 | Ctrl+\\ | Quit mit Core Dump |
| SIGKILL | 9 | - | Sofort beenden (nicht abfangbar!) |
| SIGTERM | 15 | - | Terminate, sauber beenden (Standard) |
| SIGSTOP | 19 | Ctrl+Z | Prozess stoppen (nicht abfangbar!) |
| SIGCONT | 18 | - | Gestoppten Prozess fortsetzen |

### Signale senden

```bash
# Mit kill (nicht nur zum Beenden!)
kill PID              # SIGTERM (15)
kill -15 PID          # SIGTERM explizit
kill -SIGTERM PID     # SIGTERM mit Namen
kill -9 PID           # SIGKILL (brutal!)

# Mehrere Prozesse
kill PID1 PID2 PID3

# Mit pkill (nach Name)
pkill firefox         # Alle Firefox-Prozesse
pkill -u student      # Alle Prozesse von "student"

# Mit killall
killall nginx         # Alle mit Namen "nginx"
```

:::warning SIGKILL (kill -9) nur im Notfall!
`kill -9` gibt dem Prozess keine Chance, aufzuräumen. Immer erst `kill` (SIGTERM) versuchen!
:::

### Signal-Ablauf

```
SIGTERM → Prozess kann:
           - Signal ignorieren
           - Signal abfangen und aufräumen
           - Standardaktion (beenden)

SIGKILL → Prozess wird SOFORT vom Kernel beendet
          (keine Chance zu reagieren!)
```

## Nice und Prioritäten

Prozesse haben eine **Priorität** (niceness):

- Bereich: -20 (höchste Priorität) bis +19 (niedrigste)
- Standard: 0
- Nur root kann negative Werte setzen

```bash
# Prozess mit niedriger Priorität starten
nice -n 10 ./rechenintensiv.sh

# Priorität ändern
renice 15 -p PID

# Als root: Höhere Priorität
sudo renice -10 -p PID
```

## /proc - Prozess-Informationen

Jeder Prozess hat ein Verzeichnis unter `/proc/PID/`:

```bash
# Beispiel für PID 1234
ls /proc/1234/

# Wichtige Dateien:
cat /proc/1234/cmdline    # Kommandozeile
cat /proc/1234/status     # Status, Speicher, etc.
cat /proc/1234/environ    # Umgebungsvariablen
ls -l /proc/1234/fd/      # Offene Dateideskriptoren
ls -l /proc/1234/cwd      # Aktuelles Verzeichnis
ls -l /proc/1234/exe      # Ausführbare Datei
```

## Daemons

**Daemons** sind Hintergrund-Dienste:
- Starten beim Boot
- Haben kein Terminal
- Laufen als spezielle User (www-data, mysql, etc.)
- Werden von systemd verwaltet

```bash
# Daemon-Prozesse anzeigen (kein Terminal)
ps aux | grep "?" | head

# Typische Daemons
systemctl list-units --type=service
```

## Zusammenfassung

| Befehl | Funktion |
|--------|----------|
| `ps aux` | Alle Prozesse |
| `ps auxf` | Prozesse als Baum |
| `pstree` | Prozessbaum |
| `top` / `htop` | Interaktive Prozessliste |
| `kill PID` | Signal senden (Standard: SIGTERM) |
| `kill -9 PID` | SIGKILL (Notfall!) |
| `pkill name` | Prozesse nach Name beenden |
| `nice -n N cmd` | Mit Priorität starten |
| `renice N -p PID` | Priorität ändern |
| `Ctrl+C` | SIGINT (Abbrechen) |
| `Ctrl+Z` | SIGSTOP (Stoppen) |
| `bg` / `fg` | Hintergrund/Vordergrund |
| `jobs` | Hintergrund-Jobs anzeigen |

---

Jetzt ab ins [Lab: Prozesse überwachen](./02_lab_ueberwachen.md)!
