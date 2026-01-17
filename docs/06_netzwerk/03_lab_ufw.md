---
title: "Lab: Firewall mit ufw"
sidebar_position: 3
---

# Lab: Firewall mit ufw

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

---

## Aufgabe 1: ufw aktivieren

1. Prüfe den aktuellen Firewall-Status
2. Setze Default-Policies (deny incoming, allow outgoing)
3. Erlaube SSH bevor du ufw aktivierst!
4. Aktiviere ufw

:::warning SSH nicht vergessen!
Wenn du SSH nicht erlaubst vor dem Aktivieren, sperrst du dich aus!
:::

<details>
<summary>Lösung anzeigen</summary>

```bash
# Status prüfen
sudo ufw status
# Status: inactive

# Default-Policies setzen
sudo ufw default deny incoming
sudo ufw default allow outgoing

# SSH ZUERST erlauben!
sudo ufw allow ssh
# oder
sudo ufw allow 22/tcp

# Aktivieren
sudo ufw enable
# Command may disrupt existing ssh connections. Proceed with operation (y|n)? y

# Status prüfen
sudo ufw status verbose
```

</details>

---

## Aufgabe 2: Webserver-Ports öffnen

1. Installiere nginx (falls nicht vorhanden)
2. Versuche vom Host auf http://VM-IP zuzugreifen (sollte nicht gehen)
3. Öffne Port 80 (HTTP) und 443 (HTTPS)
4. Teste erneut

<details>
<summary>Lösung anzeigen</summary>

```bash
# nginx installieren und starten
sudo apt install nginx
sudo systemctl start nginx

# Aktueller Status
sudo ufw status

# HTTP und HTTPS erlauben
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Oder mit Service-Namen:
sudo ufw allow 'Nginx HTTP'
sudo ufw allow 'Nginx HTTPS'

# Oder beides auf einmal:
sudo ufw allow 'Nginx Full'

# Status prüfen
sudo ufw status
# To        Action      From
# 22/tcp    ALLOW       Anywhere
# 80/tcp    ALLOW       Anywhere
# 443/tcp   ALLOW       Anywhere

# Testen (vom Host oder lokal)
curl http://localhost
```

</details>

---

## Aufgabe 3: Zugriff von bestimmtem Subnetz erlauben

Erlaube MySQL (Port 3306) nur vom internen Netzwerk 192.168.56.0/24:

<details>
<summary>Lösung anzeigen</summary>

```bash
# MySQL nur vom internen Netz
sudo ufw allow from 192.168.56.0/24 to any port 3306

# Prüfen
sudo ufw status

# Diese Regel erlaubt MySQL NUR von 192.168.56.x
# Von anderen IPs wird blockiert

# Test (wenn MySQL installiert wäre):
# Von 192.168.56.x: nc -zv VM-IP 3306 → Success
# Von anderer IP: nc -zv VM-IP 3306 → Timeout
```

</details>

---

## Aufgabe 4: Regel löschen

1. Zeige alle Regeln mit Nummern
2. Lösche die MySQL-Regel
3. Lösche Port 80 auf andere Weise

<details>
<summary>Lösung anzeigen</summary>

```bash
# Regeln nummeriert anzeigen
sudo ufw status numbered
# [1] 22/tcp                    ALLOW IN    Anywhere
# [2] 80/tcp                    ALLOW IN    Anywhere
# [3] 443/tcp                   ALLOW IN    Anywhere
# [4] 3306                      ALLOW IN    192.168.56.0/24

# Nach Nummer löschen
sudo ufw delete 4
# Deleting: allow from 192.168.56.0/24 to any port 3306

# Nach Regel löschen
sudo ufw delete allow 80/tcp

# Prüfen
sudo ufw status
```

</details>

---

## Aufgabe 5: Logging aktivieren

1. Aktiviere ufw-Logging
2. Versuche eine geblockte Verbindung
3. Prüfe das Log

<details>
<summary>Lösung anzeigen</summary>

```bash
# Logging aktivieren
sudo ufw logging on
# Logging enabled

# Logging-Level setzen (low, medium, high, full)
sudo ufw logging medium

# Blockierte Verbindung erzeugen (von anderem System):
# nc -zv VM-IP 12345

# Oder lokal testen (wird nicht geblockt, aber geloggt):
sudo ufw deny 12345
nc -zv localhost 12345

# Log prüfen
sudo tail -f /var/log/ufw.log
# oder
sudo journalctl -f | grep UFW

# Logging deaktivieren
sudo ufw logging off
```

</details>

---

## Aufgabe 6: Ausgehende Verbindungen einschränken

Blockiere ausgehenden Zugriff auf Port 25 (SMTP):

<details>
<summary>Lösung anzeigen</summary>

```bash
# Ausgehenden SMTP blockieren
sudo ufw deny out 25

# Prüfen
sudo ufw status

# Testen
nc -zv smtp.gmail.com 25
# Sollte fehlschlagen/timeout

# Regel entfernen
sudo ufw delete deny out 25
```

</details>

---

## Aufgabe 7: Rate Limiting

Schütze SSH vor Brute-Force-Attacken:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Zuerst alte SSH-Regel entfernen
sudo ufw delete allow ssh

# SSH mit Rate-Limit
sudo ufw limit ssh
# oder
sudo ufw limit 22/tcp

# Was macht das?
# Erlaubt max. 6 Verbindungen in 30 Sekunden von einer IP
# Mehr wird geblockt

# Prüfen
sudo ufw status
# 22/tcp    LIMIT       Anywhere
```

</details>

---

## Aufgabe 8: Komplettes Szenario

Konfiguriere die Firewall für einen Webserver:
- SSH nur vom Admin-Netzwerk (192.168.1.0/24)
- HTTP/HTTPS von überall
- Alles andere blockiert

<details>
<summary>Lösung anzeigen</summary>

```bash
# Reset (Vorsicht in Produktion!)
sudo ufw reset

# Defaults
sudo ufw default deny incoming
sudo ufw default allow outgoing

# SSH nur vom Admin-Netz
sudo ufw allow from 192.168.1.0/24 to any port 22

# Web für alle
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Aktivieren
sudo ufw enable

# Ergebnis
sudo ufw status verbose
# Default: deny (incoming), allow (outgoing), disabled (routed)
# 22/tcp    ALLOW IN    192.168.1.0/24
# 80/tcp    ALLOW IN    Anywhere
# 443/tcp   ALLOW IN    Anywhere
```

</details>

---

## Aufgabe 9: ufw-Konfiguration sichern

1. Zeige die ufw-Konfigurationsdateien
2. Sichere die aktuelle Konfiguration

<details>
<summary>Lösung anzeigen</summary>

```bash
# Konfigurationsdateien
ls -la /etc/ufw/

# Wichtige Dateien:
# /etc/ufw/user.rules     - Deine Regeln (IPv4)
# /etc/ufw/user6.rules    - IPv6-Regeln
# /etc/default/ufw        - Allgemeine Einstellungen

# Regeln sichern
sudo cp /etc/ufw/user.rules /etc/ufw/user.rules.backup

# Einfacher Backup (lesbare Form)
sudo ufw status numbered > ~/ufw_backup.txt

# Wiederherstellen aus Backup
sudo cp /etc/ufw/user.rules.backup /etc/ufw/user.rules
sudo ufw reload
```

</details>

---

## Aufgabe 10: ufw zurücksetzen

Setze ufw auf Ausgangszustand zurück:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Deaktivieren
sudo ufw disable

# Komplett zurücksetzen
sudo ufw reset

# Status prüfen
sudo ufw status
# Status: inactive

# Für die weiteren Labs: Basis-Konfiguration
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- ufw aktivieren und deaktivieren
- Default-Policies setzen
- Ports und Services erlauben/blockieren
- Regeln für bestimmte Subnetze
- Rate Limiting für Brute-Force-Schutz
- Logging aktivieren
- Regeln löschen und zurücksetzen

---

Weiter zum [Lab: Netzwerk-Diagnose](./04_lab_diagnose.md)!
