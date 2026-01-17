---
title: Netzwerk-Konfiguration
sidebar_position: 1
---

# Netzwerk-Konfiguration

## IP-Adressen Grundlagen

### IPv4

```
192.168.1.100/24
│           │ └─ Netzmaske (Subnetz-Präfix)
│           └─ Host-Teil
└─ Netzwerk-Teil (bei /24)
```

| CIDR | Netzmaske | Hosts |
|------|-----------|-------|
| /8 | 255.0.0.0 | 16 Mio |
| /16 | 255.255.0.0 | 65.534 |
| /24 | 255.255.255.0 | 254 |
| /32 | 255.255.255.255 | 1 |

### IPv6

```
2001:db8::1/64
```

128 Bit statt 32 Bit, hexadezimal notiert.

## Wichtige Befehle

### ip - Das moderne Tool

```bash
# IP-Adressen anzeigen
ip addr
ip a          # Kurzform

# Ein Interface anzeigen
ip addr show eth0

# IP-Adresse hinzufügen
sudo ip addr add 192.168.1.100/24 dev eth0

# IP-Adresse entfernen
sudo ip addr del 192.168.1.100/24 dev eth0

# Interface aktivieren/deaktivieren
sudo ip link set eth0 up
sudo ip link set eth0 down

# Routing-Tabelle
ip route
ip r

# Default-Route setzen
sudo ip route add default via 192.168.1.1

# ARP-Cache
ip neigh
```

### Alte Tools (Legacy)

```bash
# ifconfig (veraltet, aber noch verbreitet)
ifconfig
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# route (veraltet)
route -n
```

## NetworkManager

Ubuntu Desktop/Server nutzt **NetworkManager** zur Netzwerkverwaltung.

### nmcli - Kommandozeilen-Tool

```bash
# Verbindungen anzeigen
nmcli connection show
nmcli con show

# Geräte anzeigen
nmcli device status
nmcli dev status

# Verbindung aktivieren/deaktivieren
nmcli con up "Wired connection 1"
nmcli con down "Wired connection 1"

# DHCP-Verbindung erstellen
nmcli con add con-name "mycon" type ethernet ifname eth0

# Statische IP setzen
nmcli con mod "mycon" ipv4.addresses 192.168.1.100/24
nmcli con mod "mycon" ipv4.gateway 192.168.1.1
nmcli con mod "mycon" ipv4.dns "8.8.8.8 8.8.4.4"
nmcli con mod "mycon" ipv4.method manual

# Änderungen aktivieren
nmcli con up "mycon"
```

### nmtui - Textbasierte Oberfläche

```bash
nmtui
```

Bietet Menüs für:
- Verbindung bearbeiten
- Verbindung aktivieren
- Hostname setzen

## DNS und Namensauflösung

### Konfigurationsdateien

```bash
# Lokale Hostnamen
cat /etc/hosts
# 127.0.0.1   localhost
# 192.168.1.10  webserver.local webserver

# DNS-Server (modern: von systemd-resolved verwaltet)
cat /etc/resolv.conf
# nameserver 127.0.0.53  # Lokaler Resolver

# Oder direkte DNS-Server
# nameserver 8.8.8.8
# nameserver 8.8.4.4

# Hostname
cat /etc/hostname
hostnamectl
```

### DNS testen

```bash
# Hostname auflösen
nslookup google.com
dig google.com
host google.com

# Reverse-Lookup
dig -x 8.8.8.8

# DNS-Server explizit angeben
dig @8.8.8.8 google.com
```

## Routing

```bash
# Routing-Tabelle anzeigen
ip route
# default via 192.168.1.1 dev eth0
# 192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100

# Route hinzufügen
sudo ip route add 10.0.0.0/8 via 192.168.1.254

# Route löschen
sudo ip route del 10.0.0.0/8

# Welche Route wird für Ziel benutzt?
ip route get 8.8.8.8
```

## Netzwerk-Diagnose

| Befehl | Funktion |
|--------|----------|
| `ping host` | Erreichbarkeit testen |
| `traceroute host` | Route verfolgen |
| `mtr host` | Kombination ping+traceroute |
| `ss -tulpn` | Offene Ports/Sockets |
| `netstat -tulpn` | Offene Ports (legacy) |
| `nc -zv host port` | Port-Test |
| `nmap host` | Port-Scan |
| `tcpdump` | Pakete mitschneiden |
| `curl` / `wget` | HTTP-Requests |

### ss - Socket Statistics

```bash
# Alle lauschenden TCP-Ports
ss -tln

# Mit Prozess-Info
ss -tlnp

# UDP-Ports
ss -uln

# Alle Verbindungen
ss -a
```

## Firewall mit ufw

Ubuntu nutzt **ufw** (Uncomplicated Firewall) als Frontend für iptables.

```bash
# Status prüfen
sudo ufw status
sudo ufw status verbose

# Aktivieren/Deaktivieren
sudo ufw enable
sudo ufw disable

# Default-Policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Port freigeben
sudo ufw allow 22          # SSH
sudo ufw allow 80/tcp      # HTTP
sudo ufw allow 443/tcp     # HTTPS

# Service-Namen
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'

# Von bestimmter IP
sudo ufw allow from 192.168.1.0/24

# Zu bestimmtem Port von bestimmter IP
sudo ufw allow from 192.168.1.100 to any port 22

# Regel löschen
sudo ufw delete allow 80

# Nach Nummer löschen
sudo ufw status numbered
sudo ufw delete 3

# Logging
sudo ufw logging on
```

## Persistenz

### Netplan (Ubuntu Server)

Moderne Ubuntu-Versionen nutzen **Netplan**:

```bash
cat /etc/netplan/*.yaml
```

```yaml
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
    eth1:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

```bash
# Änderungen anwenden
sudo netplan apply
```

## Zusammenfassung

| Aufgabe | Befehl |
|---------|--------|
| IPs anzeigen | `ip addr` |
| Routing anzeigen | `ip route` |
| Interface up/down | `ip link set eth0 up/down` |
| Verbindungen verwalten | `nmcli con ...` |
| DNS testen | `dig`, `nslookup`, `host` |
| Firewall-Status | `sudo ufw status` |
| Port öffnen | `sudo ufw allow PORT` |
| Offene Ports | `ss -tulpn` |
| Erreichbarkeit | `ping HOST` |

---

Weiter zum [Lab: Netzwerk konfigurieren](./02_lab_konfiguration.md)!
