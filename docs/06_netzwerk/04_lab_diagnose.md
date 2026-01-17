---
title: "Lab: Netzwerk-Diagnose"
sidebar_position: 4
---

# Lab: Netzwerk-Diagnose

:::info Zeitrahmen
**Dauer:** ca. 30 Minuten
:::

---

## Aufgabe 1: Erreichbarkeit testen

1. Pinge google.com
2. Pinge die IP 8.8.8.8
3. Was sagt dir der Unterschied?

<details>
<summary>Lösung anzeigen</summary>

```bash
# Google per Name
ping -c 4 google.com

# Google DNS per IP
ping -c 4 8.8.8.8

# Unterschied:
# - Wenn beide gehen: Netzwerk + DNS funktionieren
# - Wenn nur IP geht: DNS-Problem
# - Wenn keins geht: Netzwerk-Problem

# Lokales Gateway testen
ip route | grep default
ping -c 2 $(ip route | grep default | awk '{print $3}')
```

</details>

---

## Aufgabe 2: Route verfolgen

Zeige den Weg zu einem Server:

<details>
<summary>Lösung anzeigen</summary>

```bash
# traceroute installieren
sudo apt install traceroute

# Route zu Google
traceroute google.com

# Oder mit mtr (interaktiv)
sudo apt install mtr
mtr google.com

# mtr kombiniert ping + traceroute
# Zeigt Paketverlust pro Hop
# q zum Beenden
```

</details>

---

## Aufgabe 3: DNS debuggen

1. Löse google.com auf
2. Frage einen bestimmten DNS-Server
3. Zeige alle DNS-Records

<details>
<summary>Lösung anzeigen</summary>

```bash
# Einfache Auflösung
dig google.com
host google.com
nslookup google.com

# Bestimmten DNS-Server fragen
dig @8.8.8.8 google.com
dig @1.1.1.1 google.com

# Alle Record-Typen
dig google.com ANY

# Nur IP (kurze Ausgabe)
dig +short google.com

# MX-Records (Mail)
dig google.com MX

# Reverse-Lookup
dig -x 8.8.8.8
```

</details>

---

## Aufgabe 4: Port-Test mit netcat

1. Teste ob Port 22 offen ist
2. Teste ob Port 80 offen ist
3. Teste einen geschlossenen Port

<details>
<summary>Lösung anzeigen</summary>

```bash
# netcat installieren (falls nötig)
sudo apt install netcat-openbsd

# Port 22 (SSH)
nc -zv localhost 22
# Connection to localhost 22 port [tcp/ssh] succeeded!

# Port 80
nc -zv localhost 80
# Hängt von nginx ab

# Geschlossener Port
nc -zv localhost 12345 -w 2
# -w 2 = Timeout nach 2 Sekunden
# nc: connect to localhost port 12345 (tcp) failed: Connection refused

# Remote Host
nc -zv google.com 443 -w 5
```

</details>

---

## Aufgabe 5: Aktive Verbindungen analysieren

1. Zeige alle TCP-Verbindungen
2. Welche Prozesse haben Verbindungen nach außen?
3. Zeige Verbindungs-Statistiken

<details>
<summary>Lösung anzeigen</summary>

```bash
# Alle TCP-Verbindungen
ss -tan

# Mit Prozess-Info
sudo ss -tanp

# Nur etablierte Verbindungen
ss -tan state established

# Verbindungen nach außen (nicht localhost)
sudo ss -tanp | grep -v "127.0.0.1"

# Statistiken
ss -s
# Total: X
# TCP: X (estab X, closed X, ...)
```

</details>

---

## Bonus: Pakete mitschneiden

:::warning Nur zum Lernen
Sniffing fremder Pakete ist illegal!
:::

<details>
<summary>Lösung anzeigen</summary>

```bash
# tcpdump installieren
sudo apt install tcpdump

# Alle Pakete auf Interface
sudo tcpdump -i enp0s3

# Nur Port 80
sudo tcpdump -i any port 80

# In Datei speichern
sudo tcpdump -i any -w capture.pcap

# Mit Wireshark analysieren (GUI)
# sudo apt install wireshark
# wireshark capture.pcap

# Ctrl+C zum Beenden
```

</details>

---

## Zusammenfassung

| Befehl | Funktion |
|--------|----------|
| `ping` | Erreichbarkeit |
| `traceroute` / `mtr` | Route verfolgen |
| `dig` / `nslookup` | DNS-Abfrage |
| `nc -zv` | Port-Test |
| `ss -tanp` | Verbindungen |
| `tcpdump` | Pakete mitschneiden |

---

Weiter geht's mit [Speicher und Dateisysteme](../07_speicher_dateisysteme/01_theorie.md)!
