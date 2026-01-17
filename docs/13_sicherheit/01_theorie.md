---
title: System-Sicherheit
sidebar_position: 1
---

# System-Sicherheit

## Grundprinzipien

- **Least Privilege:** Nur nötige Rechte vergeben
- **Defense in Depth:** Mehrere Sicherheitsebenen
- **Keep it Updated:** Regelmäßige Updates

## Automatische Updates

```bash
# Automatische Sicherheitsupdates aktivieren
sudo apt install unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades

# Konfiguration
cat /etc/apt/apt.conf.d/50unattended-upgrades

# Status prüfen
sudo systemctl status unattended-upgrades
```

## SSH absichern

```bash
# /etc/ssh/sshd_config
sudo nano /etc/ssh/sshd_config
```

Empfohlene Einstellungen:
```
# Root-Login deaktivieren
PermitRootLogin no

# Nur Key-Authentifizierung
PasswordAuthentication no
PubkeyAuthentication yes

# Protokoll 2 (Standard)
Protocol 2

# Idle-Timeout
ClientAliveInterval 300
ClientAliveCountMax 2
```

```bash
# Neustart
sudo systemctl restart ssh
```

### SSH-Keys einrichten

```bash
# Auf Client:
ssh-keygen -t ed25519 -C "mein-key"
ssh-copy-id user@server

# Auf Server prüfen:
cat ~/.ssh/authorized_keys
```

## fail2ban

Schützt vor Brute-Force-Angriffen:

```bash
# Installation
sudo apt install fail2ban

# Konfiguration
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local

# [sshd]
# enabled = true
# maxretry = 3
# bantime = 3600

# Starten
sudo systemctl enable --now fail2ban

# Status
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

## AppArmor

Ubuntu's Standard für Mandatory Access Control:

```bash
# Status
sudo aa-status

# Profile auflisten
ls /etc/apparmor.d/

# Profil in Complain-Mode (nur loggen)
sudo aa-complain /usr/sbin/nginx

# Profil in Enforce-Mode
sudo aa-enforce /usr/sbin/nginx

# Logs bei Verletzungen
sudo journalctl | grep apparmor
```

## Offene Ports prüfen

```bash
# Lauschende Ports
sudo ss -tulpn

# Nur public erreichbare
sudo ss -tulpn | grep -v "127.0.0.1"

# Unnötige Dienste deaktivieren
sudo systemctl disable --now avahi-daemon
```

## Checkliste Basis-Härtung

1. ✅ System aktualisiert
2. ✅ Automatische Updates aktiviert
3. ✅ SSH: Root deaktiviert, Keys statt Passwort
4. ✅ fail2ban aktiv
5. ✅ Firewall (ufw) aktiv
6. ✅ Unnötige Dienste deaktiviert
7. ✅ AppArmor aktiv

---

Weiter zum [Lab: System härten](./02_lab_haertung.md)!
