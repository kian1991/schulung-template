---
title: Kursübersicht
sidebar_position: 0
slug: /
---

# Linux Server Administration

Willkommen zur Schulung! In diesem praxisorientierten Kurs lernst du, Linux-Server professionell zu administrieren. Wir arbeiten mit **Ubuntu Server 24.04 LTS** und fokussieren uns auf hands-on Erfahrung.

:::tip Praxis steht im Vordergrund
Du wirst die meiste Zeit in Labs verbringen. Theorie gibt es nur so viel wie nötig - wir lernen am besten durch Ausprobieren!
:::

## Zielgruppe & Voraussetzungen

Dieser Kurs ist für Einsteiger konzipiert. Du solltest:
- Grundlegende Computerkenntnisse mitbringen
- Keine Angst vor der Kommandozeile haben
- Bereit sein, viel selbst auszuprobieren

## Kursformate

Dieser Kurs existiert in zwei Varianten:

### 4-Tage-Schulung (32h)

| Tag | Vormittag (4h) | Nachmittag (4h) |
|-----|----------------|-----------------|
| 1 | Einführung + Dateisystem | Paketverwaltung |
| 2 | Prozesse + Signale | Benutzer + Berechtigungen |
| 3 | Netzwerk + Firewall | Speicher + LVM/RAID |
| 4 | Systemd + Shell-Basics + Container | Monitoring + Backup + Sicherheit |

**Zusätzliche Themen:** Virtualisierung (Theorie), Docker-Container

### 5-Tage-Schulung (40h)

| Tag | Vormittag (4h) | Nachmittag (4h) |
|-----|----------------|-----------------|
| 1 | Einführung + Dateisystem | Paketverwaltung |
| 2 | Prozesse + Signale | Benutzer + Berechtigungen |
| 3 | Netzwerk + Firewall | Speicher + LVM/RAID |
| 4 | Systemd + Boot | Shell-Scripting (Teil 1) |
| 5 | Shell-Scripting (Teil 2) + Monitoring | Backup + Sicherheit + Bonding |

**Zusätzliche Themen:** Vollständiges Shell-Scripting, Netzwerk-Bonding, cgroups

## Themenübersicht

### Kernmodule (beide Varianten)

1. **Einführung** - Linux-Basics, erste Schritte mit Ubuntu
2. **Dateisystem** - FHS, Navigation, Dateien manipulieren
3. **Paketverwaltung** - apt, dpkg, Software installieren
4. **Prozesse & Signale** - Prozesse überwachen und steuern
5. **Benutzerverwaltung** - User, Gruppen, sudo
6. **Dateiberechtigungen** - rwx, ACLs, Spezial-Bits
7. **Netzwerk** - IP-Konfiguration, ufw Firewall, Diagnose
8. **Speicher** - Partitionen, Dateisysteme, ext4
9. **LVM & RAID** - Flexible Speicherverwaltung
10. **Systemd** - Services, Boot-Prozess, eigene Units
11. **Shell-Scripting** - Automatisierung mit Bash
12. **Monitoring** - Logs, Systemüberwachung
13. **Backup** - tar, rsync, Strategien
14. **Sicherheit** - System härten, AppArmor
15. **Fehlerbehebung** - Troubleshooting, Systemrettung

## Tech Stack

- **Ubuntu Server 24.04 LTS** in VirtualBox
- **VirtualBox** für VMs und Labs
- **Terminal/SSH** für alle Arbeiten

## Hinweise

:::info Ubuntu-Fokus
Wir konzentrieren uns auf Ubuntu/Debian. Andere Distributionen (RHEL, SUSE) nutzen teilweise andere Tools (rpm, yum, dnf, zypper) - das erwähnen wir kurz, üben es aber nicht.
:::

:::caution Vorbereitung
Stelle sicher, dass VirtualBox installiert ist und du die Ubuntu Server ISO heruntergeladen hast. Details findest du im VM-Setup-Dokument in den Assets.
:::

## Los geht's!

Springe direkt zur [Einführung](./00_einfuehrung/01_theorie.md) oder schaue dir zuerst das VM-Setup unter "Assets & Setup" an.
