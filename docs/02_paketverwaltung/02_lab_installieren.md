---
title: "Lab: Software installieren"
sidebar_position: 2
---

# Lab: Software installieren

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

In diesem Lab lernst du, Software zu suchen, installieren und verwalten.

---

## Aufgabe 1: System aktualisieren

1. Aktualisiere die Paketlisten
2. Zeige an, welche Updates verfügbar sind
3. Führe das Upgrade durch

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Paketlisten aktualisieren
sudo apt update

# 2. Verfügbare Updates anzeigen
apt list --upgradable

# 3. Upgrade durchführen
sudo apt upgrade

# Oder alles in einem:
sudo apt update && sudo apt upgrade -y
```

**Was passiert hier?**
- `apt update` lädt die Paketlisten von den Repositories
- `apt upgrade` installiert neuere Versionen der installierten Pakete

</details>

---

## Aufgabe 2: Paket suchen und installieren

1. Suche nach dem Paket "htop"
2. Zeige Informationen über das Paket an
3. Installiere htop
4. Starte htop und beende es wieder (mit `q`)

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Suchen
apt search htop

# 2. Informationen
apt show htop
# Zeigt: Version, Größe, Abhängigkeiten, Beschreibung

# 3. Installieren
sudo apt install htop

# 4. Starten und testen
htop
# Beenden mit 'q'
```

</details>

---

## Aufgabe 3: Mehrere Pakete installieren

Installiere folgende nützliche Tools in einem Befehl:
- `tree` (Verzeichnisbaum anzeigen)
- `ncdu` (Speicherverbrauch interaktiv)
- `net-tools` (ifconfig, netstat)
- `curl` (HTTP-Client)

<details>
<summary>Lösung anzeigen</summary>

```bash
sudo apt install tree ncdu net-tools curl

# Oder ohne Nachfrage:
sudo apt install -y tree ncdu net-tools curl

# Testen:
tree ~/projekte
ncdu /var      # 'q' zum Beenden
ifconfig
curl -I https://example.com
```

</details>

---

## Aufgabe 4: Webserver installieren und testen

1. Installiere den nginx Webserver
2. Prüfe ob der Service läuft
3. Teste den Webserver lokal
4. Zeige die Startseite an

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Installieren
sudo apt install nginx

# 2. Service-Status prüfen
sudo systemctl status nginx
# Sollte "active (running)" zeigen

# 3. Lokal testen
curl http://localhost
# Zeigt HTML der Willkommensseite

# 4. Oder im Browser (wenn Desktop verfügbar)
# http://localhost
# oder von Host: http://VM-IP

# Startseite anzeigen
cat /var/www/html/index.nginx-debian.html
```

</details>

---

## Aufgabe 5: Paket entfernen

1. Entferne nginx, aber behalte die Konfiguration
2. Prüfe ob Konfigurationsdateien noch vorhanden sind
3. Entferne nginx vollständig (purge)
4. Entferne nicht mehr benötigte Abhängigkeiten

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Entfernen (Konfiguration bleibt)
sudo apt remove nginx

# 2. Konfiguration prüfen
ls /etc/nginx/
# Sollte noch existieren!
dpkg -l nginx
# Status: "rc" (removed, config-files)

# 3. Vollständig entfernen
sudo apt purge nginx
ls /etc/nginx/
# Sollte nicht mehr existieren
dpkg -l nginx
# Status: "un" (uninstalled)

# 4. Verwaiste Abhängigkeiten entfernen
sudo apt autoremove
```

</details>

---

## Aufgabe 6: Pakete mit vim im Namen finden

1. Liste alle installierten Pakete auf, die "vim" im Namen haben
2. Falls vim nicht installiert ist, installiere `vim`
3. Zeige alle Dateien, die zum vim-Paket gehören

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Installierte vim-Pakete
dpkg -l | grep vim
# oder
dpkg -l '*vim*'

# 2. vim installieren (falls nötig)
sudo apt install vim

# 3. Dateien des Pakets
dpkg -L vim
# Zeigt alle installierten Dateien

# Interessant sind:
# /usr/bin/vim        - Das Programm
# /usr/share/vim/     - Konfiguration und Plugins
# /etc/vim/           - System-weite Konfiguration
```

</details>

---

## Aufgabe 7: Repository hinzufügen (PPA)

:::warning Optional
Dieses Lab ist optional und zeigt, wie man Drittanbieter-Repositories hinzufügt. Mache das auf Produktivsystemen nur wenn nötig!
:::

1. Füge das PPA für `neofetch` hinzu (als Beispiel)
2. Aktualisiere die Paketlisten
3. Installiere neofetch
4. Führe neofetch aus

<details>
<summary>Lösung anzeigen</summary>

```bash
# Hinweis: neofetch ist auch im Standard-Repository,
# dies ist nur ein Beispiel für den PPA-Prozess

# Zuerst: Notwendiges Tool installieren
sudo apt install software-properties-common

# PPA hinzufügen (Beispiel)
# sudo add-apt-repository ppa:dawidd6/neofetch
# ACHTUNG: Dieses PPA existiert evtl. nicht mehr!

# Alternative: Aus Standard-Repo installieren
sudo apt install neofetch

# Ausführen
neofetch
# Zeigt Systeminformationen mit ASCII-Logo

# PPA wieder entfernen (falls hinzugefügt):
# sudo add-apt-repository --remove ppa:dawidd6/neofetch
```

</details>

---

## Aufgabe 8: Upgrade simulieren

Bevor du ein Upgrade durchführst, kannst du simulieren was passieren würde:

1. Simuliere ein System-Upgrade
2. Zeige welche Pakete gehalten werden (held)

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Simulation (nichts wird installiert)
sudo apt upgrade --dry-run
# oder
sudo apt upgrade -s

# Zeigt:
# - Pakete die upgegradet werden
# - Neue Pakete die installiert werden
# - Pakete die entfernt werden
# - Download-Größe

# 2. Gehaltene Pakete
apt-mark showhold
# Normalerweise leer

# Zum Testen - Paket halten:
# sudo apt-mark hold nginx
# apt-mark showhold
# sudo apt-mark unhold nginx
```

</details>

---

## Aufgabe 9: Cache aufräumen

Finde heraus wie viel Speicher der Paket-Cache belegt und räume auf:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Cache-Verzeichnis
ls -lh /var/cache/apt/archives/

# Gesamtgröße
du -sh /var/cache/apt/archives/

# Nur veraltete Pakete entfernen
sudo apt autoclean

# ALLES entfernen (Downloads müssen ggf. wiederholt werden)
sudo apt clean

# Vorher/Nachher vergleichen
du -sh /var/cache/apt/archives/
```

</details>

---

## Aufgabe 10: Installationslog prüfen

Schau dir an, was kürzlich installiert wurde:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Apt-Log
less /var/log/apt/history.log

# Oder die letzten Einträge:
tail -50 /var/log/apt/history.log

# Detailliertes Log
less /var/log/dpkg.log

# Was wurde heute installiert?
grep "$(date +%Y-%m-%d)" /var/log/dpkg.log | grep "install"
```

</details>

---

## Bonus: Paket-Cache offline nutzen

Wenn du Pakete auf mehreren Maschinen ohne Internet installieren musst:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Auf der Maschine MIT Internet:
# Pakete herunterladen ohne zu installieren
apt download nginx
ls *.deb

# Alle Abhängigkeiten auch herunterladen (komplizierter)
apt-get download $(apt-cache depends --recurse nginx | grep -v "^  " | grep -v "<")

# .deb-Dateien auf USB-Stick kopieren, dann auf Zielmaschine:
sudo dpkg -i *.deb
sudo apt install -f   # Fehlende Abhängigkeiten nachinstallieren
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- System aktualisieren mit `apt update` und `apt upgrade`
- Pakete suchen und installieren
- Pakete entfernen (remove vs. purge)
- Paket-Informationen anzeigen
- PPAs (zusätzliche Repositories) verwalten
- Den Paket-Cache aufräumen

**Wichtige Befehle:**

| Aufgabe | Befehl |
|---------|--------|
| Updates prüfen | `sudo apt update` |
| System upgraden | `sudo apt upgrade` |
| Paket installieren | `sudo apt install PAKET` |
| Paket entfernen | `sudo apt remove PAKET` |
| Paket + Config entfernen | `sudo apt purge PAKET` |
| Aufräumen | `sudo apt autoremove && sudo apt clean` |

---

Weiter zum [Lab: Paket-Forensik](./03_lab_forensik.md)!
