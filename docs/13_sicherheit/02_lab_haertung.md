---
title: "Lab: System härten"
sidebar_position: 2
---

# Lab: System härten

:::info Zeitrahmen
**Dauer:** ca. 2 Stunden
:::

---

## Aufgabe 1: Automatische Updates

1. Installiere unattended-upgrades
2. Konfiguriere für automatische Sicherheitsupdates
3. Teste die Konfiguration

<details>
<summary>Lösung anzeigen</summary>

```bash
# Installieren
sudo apt install unattended-upgrades

# Interaktiv konfigurieren
sudo dpkg-reconfigure unattended-upgrades
# "Yes" auswählen

# Prüfen
cat /etc/apt/apt.conf.d/20auto-upgrades

# Testen (Trockenlauf)
sudo unattended-upgrade --dry-run

# Logs
cat /var/log/unattended-upgrades/unattended-upgrades.log
```

</details>

---

## Aufgabe 2: SSH härten

1. Erstelle SSH-Schlüssel
2. Konfiguriere SSH sicher
3. Teste die Verbindung

<details>
<summary>Lösung anzeigen</summary>

```bash
# SSH-Key erstellen (auf deinem Host!)
ssh-keygen -t ed25519

# Key auf Server kopieren
ssh-copy-id student@localhost -p 2222

# sshd_config anpassen
sudo nano /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no  # ERST wenn Key funktioniert!

# Testen BEVOR du Passwort-Auth deaktivierst!
ssh student@localhost -p 2222

# Neustart
sudo systemctl restart ssh
```

</details>

---

## Aufgabe 3: fail2ban einrichten

1. Installiere und konfiguriere fail2ban
2. Prüfe den Status
3. Simuliere einen Ban

<details>
<summary>Lösung anzeigen</summary>

```bash
# Installation
sudo apt install fail2ban

# Konfiguration
sudo nano /etc/fail2ban/jail.local

[DEFAULT]
bantime = 600
findtime = 600
maxretry = 3

[sshd]
enabled = true

# Starten
sudo systemctl enable --now fail2ban

# Status
sudo fail2ban-client status
sudo fail2ban-client status sshd

# Gebannte IPs
sudo fail2ban-client status sshd

# IP manuell entbannen
sudo fail2ban-client set sshd unbanip 192.168.1.100
```

</details>

---

## Aufgabe 4: Offene Ports prüfen

1. Liste alle lauschenden Ports
2. Identifiziere unnötige Dienste
3. Deaktiviere sie

<details>
<summary>Lösung anzeigen</summary>

```bash
# Alle lauschenden Ports
sudo ss -tulpn

# Nur TCP
sudo ss -tln

# Öffentlich erreichbar (nicht localhost)
sudo ss -tulpn | grep -v "127.0.0.1"

# Unnötige Dienste finden und deaktivieren
sudo systemctl list-units --type=service --state=running

# Beispiel: avahi deaktivieren (Bonjour)
sudo systemctl disable --now avahi-daemon
```

</details>

---

## Aufgabe 5: AppArmor Status

1. Prüfe AppArmor-Status
2. Zeige alle Profile
3. Setze ein Profil in Complain-Mode

<details>
<summary>Lösung anzeigen</summary>

```bash
# Status
sudo aa-status

# Profile
ls /etc/apparmor.d/

# Complain-Mode (nur loggen)
sudo aa-complain /etc/apparmor.d/usr.sbin.nginx

# Zurück zu Enforce
sudo aa-enforce /etc/apparmor.d/usr.sbin.nginx

# AppArmor-Logs
sudo journalctl | grep apparmor
```

</details>

---

## Aufgabe 6: Sicherheits-Audit

Führe ein einfaches Sicherheits-Audit durch:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash
echo "=== Sicherheits-Audit ==="

echo -e "\n[1] System-Updates:"
apt list --upgradable 2>/dev/null | head -5

echo -e "\n[2] Root-Login SSH:"
grep "^PermitRootLogin" /etc/ssh/sshd_config

echo -e "\n[3] Passwort-Auth SSH:"
grep "^PasswordAuthentication" /etc/ssh/sshd_config

echo -e "\n[4] Firewall-Status:"
sudo ufw status | head -5

echo -e "\n[5] Offene Ports (public):"
sudo ss -tlnp | grep -v "127.0.0.1" | grep -v "::1"

echo -e "\n[6] fail2ban:"
sudo fail2ban-client status 2>/dev/null || echo "Nicht installiert"

echo -e "\n[7] AppArmor:"
sudo aa-status | head -3

echo -e "\n[8] Letzten fehlgeschlagenen Logins:"
lastb | head -5 2>/dev/null || echo "Keine"
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- Automatische Updates einrichten
- SSH sicher konfigurieren
- fail2ban gegen Brute-Force
- AppArmor Grundlagen
- Sicherheits-Audit durchführen

---

Weiter zu [Fehlerbehebung](../14_fehlerbehebung_rettung/01_theorie.md)!
