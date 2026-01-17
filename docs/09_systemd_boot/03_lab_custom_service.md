---
title: "Lab: Eigene Service-Unit"
sidebar_position: 3
---

# Lab: Eigene Service-Unit erstellen

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

---

## Aufgabe 1: Einfaches Skript erstellen

1. Erstelle ein Skript das in einer Schleife loggt
2. Mache es ausführbar

<details>
<summary>Lösung anzeigen</summary>

```bash
# Skript erstellen
sudo nano /usr/local/bin/mylogger.sh

# Inhalt:
#!/bin/bash
while true; do
    echo "$(date): MyLogger is running"
    sleep 10
done

# Ausführbar machen
sudo chmod +x /usr/local/bin/mylogger.sh

# Testen
/usr/local/bin/mylogger.sh
# Ctrl+C zum Beenden
```

</details>

---

## Aufgabe 2: Service-Unit erstellen

1. Erstelle eine systemd Unit-Datei
2. Lade systemd neu

<details>
<summary>Lösung anzeigen</summary>

```bash
# Unit-Datei erstellen
sudo nano /etc/systemd/system/mylogger.service

# Inhalt:
[Unit]
Description=My Logger Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/mylogger.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

# systemd neu laden
sudo systemctl daemon-reload
```

</details>

---

## Aufgabe 3: Service testen

1. Starte den Service
2. Prüfe den Status
3. Schaue die Logs an

<details>
<summary>Lösung anzeigen</summary>

```bash
# Starten
sudo systemctl start mylogger

# Status
systemctl status mylogger
# Active: active (running)

# Logs (Live)
journalctl -u mylogger -f
# Alle 10 Sekunden neue Zeile
# Ctrl+C

# Stoppen
sudo systemctl stop mylogger
```

</details>

---

## Aufgabe 4: Restart-Verhalten testen

1. Starte den Service
2. Beende das Skript mit kill
3. Beobachte den automatischen Restart

<details>
<summary>Lösung anzeigen</summary>

```bash
# Starten
sudo systemctl start mylogger

# PID finden
systemctl status mylogger
# Main PID: 12345

# Prozess killen
sudo kill 12345

# Status sofort prüfen
systemctl status mylogger
# Zeigt: mylogger.service: Main process exited, code=killed
# Nach RestartSec=5:
# Active: active (running) (nach Neustart)

# In Logs sehen
journalctl -u mylogger -n 20
# Zeigt den Neustart
```

</details>

---

## Aufgabe 5: Service beim Boot aktivieren

1. Aktiviere den Service für Boot
2. Prüfe die Aktivierung
3. Deaktiviere wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# Aktivieren
sudo systemctl enable mylogger

# Prüfen
systemctl is-enabled mylogger
# enabled

# Symlink wurde erstellt
ls -la /etc/systemd/system/multi-user.target.wants/mylogger.service

# Deaktivieren
sudo systemctl disable mylogger
```

</details>

---

## Aufgabe 6: Timer erstellen

1. Erstelle einen Timer für regelmäßige Ausführung
2. Erstelle den zugehörigen oneshot-Service
3. Aktiviere den Timer

<details>
<summary>Lösung anzeigen</summary>

```bash
# Timer-Unit
sudo nano /etc/systemd/system/myjob.timer

[Unit]
Description=My Job Timer

[Timer]
OnCalendar=*:*:0/30
# Alle 30 Sekunden (für Test)
# Für Produktion: OnCalendar=hourly oder daily

[Install]
WantedBy=timers.target

# Service-Unit
sudo nano /etc/systemd/system/myjob.service

[Unit]
Description=My Job Service

[Service]
Type=oneshot
ExecStart=/bin/echo "Timer fired at $(date)"

# Reload und aktivieren
sudo systemctl daemon-reload
sudo systemctl enable --now myjob.timer

# Timer-Status
systemctl list-timers
journalctl -u myjob
```

</details>

---

## Cleanup

```bash
# Services stoppen und deaktivieren
sudo systemctl disable --now mylogger
sudo systemctl disable --now myjob.timer

# Unit-Dateien löschen
sudo rm /etc/systemd/system/mylogger.service
sudo rm /etc/systemd/system/myjob.service
sudo rm /etc/systemd/system/myjob.timer

# Skript löschen
sudo rm /usr/local/bin/mylogger.sh

# systemd neu laden
sudo systemctl daemon-reload
```

---

## Zusammenfassung

Du hast gelernt:
- Eigene systemd Service-Units erstellen
- Restart-Verhalten konfigurieren
- Timer für wiederkehrende Aufgaben
- Services beim Boot aktivieren

---

Weiter zu [Shell Scripting](../10_shell_scripting/01_theorie.md)!
