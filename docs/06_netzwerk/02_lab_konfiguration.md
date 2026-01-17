---
title: "Lab: Netzwerk konfigurieren"
sidebar_position: 2
---

# Lab: Netzwerk konfigurieren

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

---

## Aufgabe 1: Netzwerk-Interfaces anzeigen

1. Zeige alle Netzwerk-Interfaces mit `ip addr`
2. Welche IP-Adresse hat dein Haupt-Interface?
3. Welche MAC-Adresse hat es?

<details>
<summary>Lösung anzeigen</summary>

```bash
# Alle Interfaces
ip addr
# oder kurz:
ip a

# Typische Ausgabe:
# 1: lo: <LOOPBACK,UP> ...
#     inet 127.0.0.1/8 ...
# 2: enp0s3: <BROADCAST,MULTICAST,UP> ...
#     link/ether 08:00:27:xx:xx:xx  ← MAC-Adresse
#     inet 10.0.2.15/24 ...         ← IP-Adresse

# Nur IPv4
ip -4 addr

# Kompakt
ip -br addr
```

</details>

---

## Aufgabe 2: Netzwerk-Verbindungen mit nmcli

1. Liste alle Netzwerk-Verbindungen auf
2. Zeige Details zur aktiven Verbindung
3. Zeige alle verfügbaren Netzwerk-Geräte

<details>
<summary>Lösung anzeigen</summary>

```bash
# Alle Verbindungen
nmcli connection show
# oder kurz:
nmcli con show

# Details einer Verbindung
nmcli con show "Wired connection 1"

# Geräte-Status
nmcli device status

# Detaillierte Geräte-Info
nmcli device show enp0s3
```

</details>

---

## Aufgabe 3: Statische IP konfigurieren

1. Erstelle eine neue Verbindung mit statischer IP
2. Setze IP: 192.168.56.100/24
3. Aktiviere die Verbindung

:::warning Nur auf Host-Only Interface!
Mache das nur auf dem Host-Only Adapter, sonst verlierst du die Verbindung zur VM.
:::

<details>
<summary>Lösung anzeigen</summary>

```bash
# Prüfen welche Interfaces existieren
ip link

# Neue Verbindung erstellen (auf Host-Only Interface, z.B. enp0s8)
sudo nmcli con add con-name "static-lab" \
    type ethernet \
    ifname enp0s8 \
    ipv4.addresses 192.168.56.100/24 \
    ipv4.method manual

# Prüfen
nmcli con show static-lab

# Aktivieren
sudo nmcli con up static-lab

# Testen
ip addr show enp0s8
ping 192.168.56.100

# Vom Host testen (in anderem Terminal):
# ping 192.168.56.100
```

</details>

---

## Aufgabe 4: DNS konfigurieren

1. Zeige die aktuellen DNS-Server
2. Ändere den DNS-Server auf 8.8.8.8
3. Teste die Namensauflösung

<details>
<summary>Lösung anzeigen</summary>

```bash
# Aktuelle DNS-Einstellungen
cat /etc/resolv.conf
# oder
resolvectl status

# DNS über nmcli ändern
sudo nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli con up "Wired connection 1"

# Prüfen
resolvectl status
nmcli con show "Wired connection 1" | grep dns

# Testen
dig google.com
nslookup ubuntu.com
```

</details>

---

## Aufgabe 5: Routing verstehen

1. Zeige die Routing-Tabelle
2. Welches ist das Default Gateway?
3. Über welche Route wird 8.8.8.8 erreicht?

<details>
<summary>Lösung anzeigen</summary>

```bash
# Routing-Tabelle
ip route
# oder
ip r

# Typische Ausgabe:
# default via 10.0.2.2 dev enp0s3  ← Default Gateway
# 10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
# 192.168.56.0/24 dev enp0s8 ...

# Route für bestimmtes Ziel
ip route get 8.8.8.8
# 8.8.8.8 via 10.0.2.2 dev enp0s3 src 10.0.2.15
```

</details>

---

## Aufgabe 6: Hostname ändern

1. Zeige den aktuellen Hostname
2. Ändere ihn auf "linux-lab"
3. Prüfe die Änderung

<details>
<summary>Lösung anzeigen</summary>

```bash
# Aktueller Hostname
hostname
hostnamectl

# Hostname ändern
sudo hostnamectl set-hostname linux-lab

# Prüfen
hostname
cat /etc/hostname

# /etc/hosts aktualisieren
sudo nano /etc/hosts
# 127.0.1.1    linux-lab

# Neue Shell öffnen um Prompt zu sehen
bash
# student@linux-lab:~$
```

</details>

---

## Aufgabe 7: Offene Ports prüfen

1. Zeige alle lauschenden TCP-Ports
2. Welcher Prozess lauscht auf Port 22?
3. Prüfe ob Port 80 offen ist

<details>
<summary>Lösung anzeigen</summary>

```bash
# Lauschende TCP-Ports
ss -tln

# Mit Prozess-Info (braucht sudo)
sudo ss -tlnp

# Bestimmter Port
sudo ss -tlnp | grep :22
# LISTEN  0  128  0.0.0.0:22  ...  users:(("sshd",pid=xxx))

# Port 80 prüfen
sudo ss -tln | grep :80
# Falls nginx läuft, siehst du den Port

# Alle Verbindungen (nicht nur lauschend)
ss -tan

# UDP-Ports
ss -uln
```

</details>

---

## Aufgabe 8: Lokale Hostnamen (/etc/hosts)

1. Füge einen Eintrag für "myserver" hinzu
2. Teste mit ping
3. Entferne den Eintrag wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# /etc/hosts editieren
sudo nano /etc/hosts

# Zeile hinzufügen:
192.168.56.100  myserver myserver.local

# Speichern und beenden (Ctrl+O, Enter, Ctrl+X)

# Testen
ping -c 2 myserver
# PING myserver (192.168.56.100)

# Entfernen
sudo nano /etc/hosts
# Zeile löschen
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- IP-Adressen und Interfaces anzeigen
- Verbindungen mit nmcli verwalten
- Statische IPs konfigurieren
- DNS-Server ändern
- Routing-Tabelle verstehen
- Hostname ändern
- Offene Ports prüfen

---

Weiter zum [Lab: Firewall mit ufw](./03_lab_ufw.md)!
