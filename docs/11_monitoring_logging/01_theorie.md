---
title: Monitoring und Logging
sidebar_position: 1
---

# Monitoring und Logging

## Logging-Systeme

### journald (systemd)

Modernes Logging-System, binäres Format:

```bash
# Alle Logs
journalctl

# Letzte 100 Zeilen
journalctl -n 100

# Live folgen
journalctl -f

# Seit letztem Boot
journalctl -b

# Bestimmter Service
journalctl -u nginx

# Kernel-Meldungen
journalctl -k

# Nach Priorität
journalctl -p err       # Nur Fehler und schlimmer
journalctl -p warning   # Warnungen und schlimmer

# Zeitraum
journalctl --since "1 hour ago"
journalctl --since "2024-01-15" --until "2024-01-16"

# JSON-Ausgabe
journalctl -o json-pretty
```

### /var/log - Klassische Logs

| Datei | Inhalt |
|-------|--------|
| `/var/log/syslog` | Allgemeines Systemlog |
| `/var/log/auth.log` | Authentifizierung, sudo |
| `/var/log/kern.log` | Kernel-Meldungen |
| `/var/log/dpkg.log` | Paketinstallationen |
| `/var/log/apt/` | APT-Logs |
| `/var/log/nginx/` | Nginx-Logs |

### logrotate

Automatische Log-Rotation:

```bash
# Konfiguration
cat /etc/logrotate.conf
ls /etc/logrotate.d/

# Manuell rotieren
sudo logrotate -f /etc/logrotate.conf
```

## System-Monitoring

### top / htop

```bash
top         # Basis
htop        # Benutzerfreundlicher
```

### vmstat - Virtual Memory

```bash
vmstat 1 5   # Alle 1 Sekunde, 5 mal
```

| Spalte | Bedeutung |
|--------|-----------|
| r | Wartende Prozesse |
| b | Blockierte Prozesse |
| swpd | Swap genutzt |
| free | Freier RAM |
| si/so | Swap in/out |
| bi/bo | Block in/out |
| us | User CPU % |
| sy | System CPU % |
| id | Idle % |
| wa | I/O Wait % |

### iostat - I/O Statistics

```bash
sudo apt install sysstat
iostat -x 1 5
```

### sar - System Activity Reporter

```bash
# CPU-Statistiken
sar -u 1 5

# Memory
sar -r 1 5

# Historische Daten
sar -u -f /var/log/sysstat/sa15
```

### free - Speicher

```bash
free -h
watch free -h
```

## Netzwerk-Monitoring

```bash
# Verbindungen
ss -tulpn
netstat -tulpn

# Bandbreite
sudo apt install iftop
sudo iftop

# Netzwerk-Statistiken
ip -s link
```

## Praktische Befehle

```bash
# Load Average
uptime
cat /proc/loadavg

# Wer ist eingeloggt
who
w
last

# Fehlgeschlagene Logins
faillog -a
lastb

# Disk I/O
iotop

# Prozesse nach CPU
ps aux --sort=-%cpu | head

# Prozesse nach RAM
ps aux --sort=-%mem | head
```

## Zusammenfassung

| Befehl | Funktion |
|--------|----------|
| `journalctl` | Systemd-Logs |
| `journalctl -u SERVICE` | Service-Logs |
| `journalctl -f` | Live folgen |
| `top` / `htop` | Prozesse |
| `vmstat` | Memory/CPU |
| `iostat` | I/O |
| `sar` | Historische Daten |
| `free -h` | Speicher |

---

Weiter zum [Lab: Logs analysieren](./02_lab_logs.md)!
