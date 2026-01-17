---
title: "Lab: Prozesse überwachen"
sidebar_position: 2
---

# Lab: Prozesse überwachen

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

In diesem Lab lernst du, Prozesse zu beobachten und zu analysieren.

---

## Aufgabe 1: htop erkunden

1. Starte `htop`
2. Sortiere nach CPU-Auslastung
3. Sortiere nach Speicherverbrauch
4. Aktiviere die Baumansicht
5. Filtere nach deinem Benutzernamen

<details>
<summary>Lösung anzeigen</summary>

```bash
# htop starten
htop

# Tasten in htop:
# F6 oder > : Sortierung ändern
#   → PERCENT_CPU für CPU
#   → PERCENT_MEM für Memory

# F5 : Baumansicht an/aus

# u : Nach User filtern
#   → student auswählen

# F10 oder q : Beenden
```

**Wichtige htop-Infos oben:**
- CPU-Balken: Grün=User, Rot=Kernel, Blau=Nice
- Mem-Balken: Grün=Benutzt, Blau=Buffer, Gelb=Cache
- Load Average: 1min, 5min, 15min
- Tasks: Running, Threads, etc.

</details>

---

## Aufgabe 2: Prozesse mit ps finden

1. Zeige alle Prozesse deines Benutzers
2. Zeige alle Prozesse als Baum
3. Finde den Prozess mit der höchsten CPU-Auslastung

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Prozesse des aktuellen Users
ps u
# oder
ps -u student

# Alle Prozesse ALLER User:
ps aux

# 2. Prozessbaum
ps auxf
# oder
ps -ef --forest

# 3. Nach CPU sortiert
ps aux --sort=-%cpu | head -10
# Das - vor %cpu = absteigend

# Nach Speicher sortiert:
ps aux --sort=-%mem | head -10
```

</details>

---

## Aufgabe 3: Prozessbaum analysieren

1. Zeige den Prozessbaum mit `pstree`
2. Zeige den Prozessbaum mit PIDs
3. Finde die PID von systemd und zeige seine Kinder

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Einfacher Baum
pstree

# 2. Mit PIDs
pstree -p

# 3. systemd hat immer PID 1
pstree -p 1

# Nur bestimmte Tiefe
pstree -p 1 | head -30

# Kompakte Ansicht
pstree -c
```

</details>

---

## Aufgabe 4: Hintergrundprozess starten

1. Starte `sleep 1000` im Hintergrund
2. Finde die PID des Prozesses
3. Zeige Informationen aus `/proc/` über diesen Prozess
4. Beende den Prozess

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Im Hintergrund starten
sleep 1000 &
# Ausgabe: [1] 12345 (Jobnummer und PID)

# 2. PID finden
jobs -l          # Mit -l zeigt auch PID
pgrep sleep      # Findet alle sleep-Prozesse
ps aux | grep sleep

# 3. /proc Informationen
PID=$(pgrep -n sleep)   # Neuester sleep-Prozess

cat /proc/$PID/cmdline
# sleep1000

cat /proc/$PID/status | head -10
# Name, State, Pid, PPid, Uid, etc.

ls -l /proc/$PID/cwd
# Aktuelles Verzeichnis

ls -l /proc/$PID/fd
# Offene Dateideskriptoren

# 4. Beenden
kill $PID
# oder
kill %1    # Job-Nummer
```

</details>

---

## Aufgabe 5: Prozesse nach Kriterien finden

1. Finde alle Prozesse die von root gestartet wurden
2. Finde alle ssh-bezogenen Prozesse
3. Zähle wie viele Prozesse insgesamt laufen

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Root-Prozesse
ps -u root
# oder
ps aux | awk '$1 == "root"'

# Nur Anzahl:
ps -u root | wc -l

# 2. SSH-Prozesse
ps aux | grep ssh
# Filtert auch den grep-Befehl selbst!

# Besser:
ps aux | grep [s]sh
# oder
pgrep -a ssh

# 3. Anzahl aller Prozesse
ps aux | wc -l
# oder (genauer, ohne Header)
ps aux --no-headers | wc -l
# oder
cat /proc/loadavg | awk '{print $4}'
# Format: running/total
```

</details>

---

## Aufgabe 6: Speicherverbrauch analysieren

1. Welcher Prozess verbraucht am meisten RAM?
2. Wie viel Speicher verbrauchen alle Prozesse zusammen?
3. Zeige den freien Speicher

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Top RAM-Verbraucher
ps aux --sort=-%mem | head -5

# Nur bestimmte Spalten:
ps -eo pid,user,rss,cmd --sort=-rss | head -10
# rss = Resident Set Size (physischer RAM)

# 2. Gesamter Speicherverbrauch (ungefähr)
ps aux | awk '{sum+=$6} END {print sum/1024 " MB"}'
# Spalte 6 = RSS in KB

# 3. Freier Speicher
free -h

# Detaillierter:
cat /proc/meminfo | head -10
```

</details>

---

## Aufgabe 7: CPU-Last erzeugen und beobachten

1. Öffne zwei Terminals nebeneinander
2. Im ersten: Starte `htop`
3. Im zweiten: Erzeuge CPU-Last mit `yes > /dev/null`
4. Beobachte in htop
5. Beende den yes-Prozess aus htop heraus

<details>
<summary>Lösung anzeigen</summary>

```bash
# Terminal 1:
htop

# Terminal 2:
yes > /dev/null &
# yes gibt endlos "y" aus, /dev/null verschluckt die Ausgabe
# → Eine CPU zu 100% ausgelastet

# In htop:
# - Prozess "yes" sollte oben erscheinen
# - CPU-Balken sollte sich füllen

# Aus htop beenden:
# 1. yes-Prozess mit Pfeiltasten auswählen
# 2. F9 (Kill)
# 3. Signal auswählen (15=SIGTERM oder 9=SIGKILL)
# 4. Enter

# Oder im Terminal 2:
killall yes
# oder
pkill yes
```

</details>

---

## Aufgabe 8: Load Average verstehen

1. Zeige den aktuellen Load Average
2. Wie viele CPU-Kerne hat dein System?
3. Was bedeutet ein Load von 2.0 auf einem 2-Kern-System?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Load Average
uptime
# Zeigt: load average: 0.15, 0.10, 0.05
# Das sind: 1 min, 5 min, 15 min Durchschnitt

# Oder
cat /proc/loadavg
# Format: 1min 5min 15min running/total last_pid

# 2. CPU-Kerne
nproc
# oder
grep -c processor /proc/cpuinfo
# oder
lscpu | grep "^CPU(s):"

# 3. Load von 2.0 auf 2-Kern-System:
# = 100% Auslastung im Durchschnitt
# Load 1.0 pro Kern = Voll ausgelastet
# Load > Kerne = Prozesse müssen warten

# Beispiele (2-Kern-System):
# Load 0.5 → System wenig belastet
# Load 1.0 → 50% Auslastung
# Load 2.0 → 100% Auslastung
# Load 4.0 → Überlastet, Prozesse warten
```

</details>

---

## Aufgabe 9: Prozesse eines Dienstes finden

1. Finde alle nginx-Prozesse (falls installiert, sonst ssh)
2. Zeige deren Eltern-Kind-Beziehung
3. Welcher Prozess ist der Master/Parent?

<details>
<summary>Lösung anzeigen</summary>

```bash
# Falls nginx nicht installiert:
sudo apt install nginx

# 1. Nginx-Prozesse finden
ps aux | grep nginx
# oder
pgrep -a nginx

# 2. Beziehung zeigen
pstree -p $(pgrep -o nginx)
# -o = oldest (Master-Prozess)

# Oder mit ps:
ps -ef | grep nginx
# PPID-Spalte zeigt Parent

# 3. Master finden
# Master = Der mit PPID=1 (systemd)
ps -eo pid,ppid,cmd | grep nginx

# Typische Struktur:
# nginx master (läuft als root, PPID=1)
# └── nginx worker (läuft als www-data, PPID=master)
# └── nginx worker ...
```

</details>

---

## Aufgabe 10: Echtzeit-Überwachung mit watch

Beobachte Prozesse in Echtzeit ohne htop:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Top 5 CPU-Verbraucher alle 2 Sekunden
watch "ps aux --sort=-%cpu | head -6"

# Top 5 RAM-Verbraucher
watch "ps aux --sort=-%mem | head -6"

# Bestimmten Prozess beobachten
watch "ps aux | grep nginx"

# Load Average beobachten
watch uptime

# Alle Sekunde aktualisieren
watch -n 1 "uptime"

# Mit Unterschied-Hervorhebung
watch -d "ps aux | head -10"

# Beenden: Ctrl+C
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Prozesse mit `ps`, `pstree`, `htop` anzeigen
- Prozesse nach verschiedenen Kriterien filtern und sortieren
- Prozess-Informationen aus `/proc` lesen
- Load Average interpretieren
- Prozesse in Echtzeit überwachen

---

Weiter zum [Lab: Prozesse steuern](./03_lab_steuern.md)!
