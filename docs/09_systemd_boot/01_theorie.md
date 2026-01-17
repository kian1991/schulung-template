---
title: Systemd und Boot
sidebar_position: 1
---

# Systemd und Boot-Prozess

## Boot-Ablauf

```
┌─────────────┐
│  BIOS/UEFI  │  Hardware-Initialisierung
└──────┬──────┘
       ▼
┌─────────────┐
│    GRUB     │  Bootloader, Kernel-Auswahl
└──────┬──────┘
       ▼
┌─────────────┐
│   Kernel    │  Hardware-Erkennung, Treiber
└──────┬──────┘
       ▼
┌─────────────┐
│   initrd    │  Temporäres Root-Dateisystem
└──────┬──────┘
       ▼
┌─────────────┐
│   systemd   │  PID 1, startet alle Services
└─────────────┘
```

## systemd Grundlagen

systemd ist das Init-System moderner Linux-Distributionen (Ubuntu seit 15.04).

### Units

Alles in systemd ist eine **Unit**:

| Unit-Typ | Endung | Funktion |
|----------|--------|----------|
| Service | `.service` | Dienste/Programme |
| Target | `.target` | Gruppierung von Units |
| Mount | `.mount` | Mountpoints |
| Socket | `.socket` | Socket-Aktivierung |
| Timer | `.timer` | Zeitgesteuerte Ausführung |
| Path | `.path` | Pfad-basierte Aktivierung |

### systemctl - Hauptbefehl

```bash
# Service-Status
systemctl status nginx

# Service starten/stoppen
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx   # Konfiguration neu laden

# Beim Boot aktivieren/deaktivieren
sudo systemctl enable nginx
sudo systemctl disable nginx

# Beides kombiniert
sudo systemctl enable --now nginx
sudo systemctl disable --now nginx

# Service maskieren (kann nicht gestartet werden)
sudo systemctl mask nginx
sudo systemctl unmask nginx

# Alle Services auflisten
systemctl list-units --type=service
systemctl list-units --type=service --state=running

# Fehlgeschlagene Services
systemctl --failed
```

### Targets (Runlevels)

```bash
# Aktuelles Target
systemctl get-default

# Target ändern
sudo systemctl set-default multi-user.target   # Ohne GUI
sudo systemctl set-default graphical.target    # Mit GUI

# Sofort wechseln
sudo systemctl isolate multi-user.target

# Wichtige Targets:
# poweroff.target  - Herunterfahren
# rescue.target    - Single-User / Rettung
# multi-user.target - Normaler Betrieb (ohne GUI)
# graphical.target  - Mit GUI
# reboot.target    - Neustart
```

### Journal (Logs)

```bash
# Alle Logs
journalctl

# Logs eines Services
journalctl -u nginx

# Seit dem letzten Boot
journalctl -b

# Vorheriger Boot
journalctl -b -1

# Live folgen
journalctl -f
journalctl -u nginx -f

# Nach Priorität
journalctl -p err    # Nur Fehler
journalctl -p warning

# Zeitraum
journalctl --since "2024-01-15 10:00"
journalctl --since "1 hour ago"

# Kernel-Meldungen
journalctl -k
```

## Eigene Service-Units

### Service-Datei erstellen

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=myapp
Group=myapp
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/start.sh
ExecStop=/opt/myapp/stop.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### Service aktivieren

```bash
# Systemd neu laden
sudo systemctl daemon-reload

# Service starten und aktivieren
sudo systemctl enable --now myapp

# Status prüfen
systemctl status myapp
```

### Service-Typen

| Type | Beschreibung |
|------|--------------|
| `simple` | ExecStart ist der Hauptprozess |
| `forking` | Prozess forkt in Hintergrund |
| `oneshot` | Einmalige Ausführung |
| `notify` | Sendet Bereitschaftssignal |

## Timer (Cronjob-Alternative)

### Timer-Datei

```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Daily Backup Timer

[Timer]
OnCalendar=daily
# Oder: OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

### Zugehöriger Service

```ini
# /etc/systemd/system/backup.service
[Unit]
Description=Backup Service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

### Timer verwalten

```bash
sudo systemctl enable --now backup.timer
systemctl list-timers
```

## Boot-Analyse

```bash
# Boot-Zeit analysieren
systemd-analyze

# Kritischer Pfad
systemd-analyze critical-chain

# Alle Units nach Startzeit
systemd-analyze blame

# Grafische Ausgabe
systemd-analyze plot > boot.svg
```

## Zusammenfassung

| Befehl | Funktion |
|--------|----------|
| `systemctl status` | Status anzeigen |
| `systemctl start/stop` | Starten/Stoppen |
| `systemctl enable/disable` | Boot-Start |
| `systemctl mask/unmask` | Sperren |
| `systemctl list-units` | Units auflisten |
| `systemctl daemon-reload` | Config neu laden |
| `journalctl -u SERVICE` | Logs anzeigen |
| `systemd-analyze` | Boot analysieren |

---

Weiter zum [Lab: Services verwalten](./02_lab_services.md)!
