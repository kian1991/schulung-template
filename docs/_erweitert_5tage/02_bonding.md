---
title: "Lab: Netzwerk-Bonding"
sidebar_position: 2
---

# Lab: Netzwerk-Bonding

:::info Nur 5-Tage-Schulung
Dieses Modul ist Teil der 5-Tage-Schulung.
:::

Network Bonding kombiniert mehrere Netzwerk-Interfaces für Redundanz oder Bandbreite.

## Vorbereitung

Füge 2 Netzwerk-Interfaces zur VM hinzu (VirtualBox: beide auf Host-Only).

## Bonding einrichten

```bash
# Bonding-Modul laden
sudo modprobe bonding

# Mit nmcli konfigurieren
sudo nmcli con add type bond con-name bond0 ifname bond0 mode active-backup

# Slaves hinzufügen
sudo nmcli con add type ethernet slave-type bond con-name bond0-slave1 ifname enp0s8 master bond0
sudo nmcli con add type ethernet slave-type bond con-name bond0-slave2 ifname enp0s9 master bond0

# IP konfigurieren
sudo nmcli con mod bond0 ipv4.addresses 192.168.56.200/24
sudo nmcli con mod bond0 ipv4.method manual

# Aktivieren
sudo nmcli con up bond0
```

## Status prüfen

```bash
# Bonding-Status
cat /proc/net/bonding/bond0

# Interface-Status
ip addr show bond0
```

## Failover testen

```bash
# Ein Interface deaktivieren
sudo ip link set enp0s8 down

# Status prüfen - Failover sollte erfolgt sein
cat /proc/net/bonding/bond0

# Ping sollte weiterhin funktionieren
ping 192.168.56.1
```

## Bonding-Modi

| Modus | Beschreibung |
|-------|--------------|
| `balance-rr` | Round-Robin |
| `active-backup` | Nur ein aktives Interface |
| `balance-xor` | XOR-basiert |
| `802.3ad` | LACP (Switch-Support nötig) |
