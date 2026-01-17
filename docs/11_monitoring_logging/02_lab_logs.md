---
title: "Lab: Logs und Monitoring"
sidebar_position: 2
---

# Lab: Logs und Monitoring

:::info Zeitrahmen
**Dauer:** ca. 2 Stunden
:::

---

## Aufgabe 1: journalctl Grundlagen

1. Zeige alle Logs seit dem letzten Boot
2. Zeige nur Fehler
3. Zeige Logs von SSH

<details>
<summary>Lösung anzeigen</summary>

```bash
# Seit Boot
journalctl -b

# Nur Fehler
journalctl -p err

# SSH-Logs
journalctl -u ssh
```

</details>

---

## Aufgabe 2: Logs live beobachten

1. Folge den System-Logs live
2. In anderem Terminal: Führe sudo-Befehl aus
3. Beobachte den Log-Eintrag

<details>
<summary>Lösung anzeigen</summary>

```bash
# Terminal 1:
journalctl -f

# Terminal 2:
sudo ls /root

# Terminal 1 zeigt sudo-Log
```

</details>

---

## Aufgabe 3: Auth-Logs prüfen

1. Finde fehlgeschlagene Login-Versuche
2. Zeige die letzten erfolgreichen Logins

<details>
<summary>Lösung anzeigen</summary>

```bash
# Fehlgeschlagene Logins
sudo grep "Failed" /var/log/auth.log
journalctl | grep "Failed"

# Erfolgreiche Logins
last
lastlog

# Wer ist aktuell eingeloggt
who
w
```

</details>

---

## Aufgabe 4: System-Ressourcen überwachen

1. Zeige CPU und Memory mit vmstat
2. Zeige I/O mit iostat
3. Zeige Speicher mit free

<details>
<summary>Lösung anzeigen</summary>

```bash
# vmstat alle 2 Sek, 5 mal
vmstat 2 5

# iostat (sysstat installieren)
sudo apt install sysstat
iostat -x 2 5

# Speicher
free -h
watch -n 2 free -h
```

</details>

---

## Aufgabe 5: Top-Verbraucher finden

1. Finde die 5 CPU-intensivsten Prozesse
2. Finde die 5 RAM-intensivsten Prozesse

<details>
<summary>Lösung anzeigen</summary>

```bash
# Top CPU
ps aux --sort=-%cpu | head -6

# Top RAM
ps aux --sort=-%mem | head -6

# Oder in htop: F6 zum Sortieren
```

</details>

---

## Aufgabe 6: logrotate konfigurieren

Erstelle eine logrotate-Konfiguration für eine eigene Anwendung:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Test-Log erstellen
sudo mkdir -p /var/log/myapp
sudo touch /var/log/myapp/app.log
sudo dd if=/dev/urandom bs=1M count=5 >> /var/log/myapp/app.log

# logrotate-Config
sudo nano /etc/logrotate.d/myapp

/var/log/myapp/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 640 root root
}

# Testen
sudo logrotate -d /etc/logrotate.d/myapp
sudo logrotate -f /etc/logrotate.d/myapp

ls -la /var/log/myapp/
```

</details>

---

## Aufgabe 7: Einfaches Monitoring-Skript

Schreibe ein Skript das bei hoher Load warnt:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash
# /usr/local/bin/check_load.sh

THRESHOLD=2
LOAD=$(cat /proc/loadavg | awk '{print $1}')

if (( $(echo "$LOAD > $THRESHOLD" | bc -l) )); then
    echo "WARNUNG: Load ist $LOAD (Schwellwert: $THRESHOLD)" | \
        logger -t check_load -p user.warning
fi
```

```bash
chmod +x /usr/local/bin/check_load.sh
sudo /usr/local/bin/check_load.sh
journalctl -t check_load
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- Logs mit journalctl analysieren
- Klassische Logs in /var/log lesen
- System-Ressourcen überwachen
- logrotate konfigurieren

---

Weiter zu [Backup und Recovery](../12_backup_recovery/01_theorie.md)!
