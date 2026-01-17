---
title: "Lab: Paket-Forensik"
sidebar_position: 3
---

# Lab: Paket-Forensik

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

In diesem Lab lernst du, Pakete zu untersuchen und herauszufinden, woher Dateien kommen.

---

## Aufgabe 1: Welches Paket hat diese Datei installiert?

Finde heraus, zu welchem Paket diese Dateien gehören:

1. `/usr/bin/ssh`
2. `/bin/ls`
3. `/usr/bin/vim`

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. SSH
dpkg -S /usr/bin/ssh
# openssh-client: /usr/bin/ssh

# 2. ls
dpkg -S /bin/ls
# coreutils: /bin/ls

# 3. vim
dpkg -S /usr/bin/vim
# vim: /usr/bin/vim
# oder vim-tiny, vim-basic, etc.

# Tipp: Funktioniert auch mit Wildcards
dpkg -S '*ssh*' | head
```

</details>

---

## Aufgabe 2: Dateien eines Pakets auflisten

1. Liste alle Dateien auf, die zum Paket `coreutils` gehören
2. Wie viele Dateien sind das?
3. Welche Binaries (in /usr/bin) sind enthalten?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Alle Dateien
dpkg -L coreutils

# 2. Anzahl
dpkg -L coreutils | wc -l

# 3. Nur Binaries
dpkg -L coreutils | grep "/usr/bin/"
# oder
dpkg -L coreutils | grep "^/usr/bin"

# Interessante coreutils-Befehle:
# cat, cp, mv, rm, ls, mkdir, chmod, chown, head, tail, sort, wc, ...
```

</details>

---

## Aufgabe 3: Abhängigkeiten analysieren

1. Zeige die Abhängigkeiten von `nginx` an
2. Zeige umgekehrte Abhängigkeiten: Welche Pakete hängen von `libc6` ab?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Abhängigkeiten von nginx
apt depends nginx
# oder
apt-cache depends nginx

# Zeigt:
# - Depends: Was nginx braucht
# - Recommends: Empfohlen
# - Suggests: Optional

# 2. Umgekehrte Abhängigkeiten (was braucht libc6?)
apt rdepends libc6 | head -30
# oder
apt-cache rdepends libc6 | head -30

# libc6 ist die C-Standardbibliothek - fast alles hängt davon ab!
```

</details>

---

## Aufgabe 4: .deb Paket manuell herunterladen und untersuchen

1. Lade das Paket `cowsay` herunter (ohne zu installieren)
2. Untersuche den Inhalt der .deb Datei
3. Zeige die Paket-Informationen
4. Installiere es mit dpkg

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Herunterladen
apt download cowsay
ls *.deb
# cowsay_3.03+dfsg2-8_all.deb (oder ähnlich)

# 2. Inhalt anzeigen (Dateiliste)
dpkg -c cowsay*.deb
# oder
dpkg --contents cowsay*.deb

# 3. Paket-Informationen
dpkg -I cowsay*.deb
# oder
dpkg --info cowsay*.deb
# Zeigt: Version, Maintainer, Abhängigkeiten, Beschreibung

# 4. Installieren
sudo dpkg -i cowsay*.deb

# Falls Abhängigkeiten fehlen:
sudo apt install -f

# Testen!
cowsay "Hallo Linux!"

# Aufräumen
rm cowsay*.deb
```

</details>

---

## Aufgabe 5: Paket-Status verstehen

1. Zeige den Status aller Pakete die "nginx" im Namen haben
2. Was bedeuten die Buchstaben am Anfang?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. nginx-Pakete anzeigen
dpkg -l '*nginx*'

# 2. Status-Bedeutung (erste zwei Spalten):
# Desired=Unknown/Install/Remove/Purge/Hold
# Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend

# Häufige Kombinationen:
# ii - Installed, gewünscht: Install (normal)
# rc - Removed, Config-files vorhanden (nach apt remove)
# un - Not installed, gewünscht: Unknown (nie installiert)
# hi - Installed, gewünscht: Hold (Version eingefroren)

# Beispiel: Paket entfernen und Status prüfen
sudo apt remove cowsay
dpkg -l cowsay
# rc = removed, config-files remaining

sudo apt purge cowsay
dpkg -l cowsay
# un = nicht installiert
```

</details>

---

## Aufgabe 6: Konfigurationsdateien finden

1. Welche Konfigurationsdateien gehören zu `ssh`?
2. Zeige die Änderungen an Konfigurationsdateien seit der Installation

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. SSH Konfigurationsdateien
dpkg -L openssh-client | grep "/etc/"
dpkg -L openssh-server | grep "/etc/" 2>/dev/null

# Oder alle Konfigdateien eines Pakets
cat /var/lib/dpkg/info/openssh-client.conffiles

# 2. Änderungen an Konfigdateien prüfen
sudo debsums -ce openssh-client
# -c = only changed
# -e = config files only

# Falls debsums nicht installiert:
sudo apt install debsums

# Alle veränderten Konfigdateien im System:
sudo debsums -ce
```

</details>

---

## Aufgabe 7: Paket-Integrität prüfen

Prüfe, ob alle Dateien eines Pakets noch intakt sind:

<details>
<summary>Lösung anzeigen</summary>

```bash
# debsums installieren
sudo apt install debsums

# Einzelnes Paket prüfen
sudo debsums coreutils
# OK = Datei ist unverändert
# FAILED = Datei wurde modifiziert

# Nur veränderte Dateien anzeigen
sudo debsums -c coreutils

# Alle Pakete prüfen (dauert!)
# sudo debsums -s   # -s = silent, nur Fehler
```

</details>

---

## Aufgabe 8: Verfügbare Versionen

1. Welche Version von `nginx` ist aktuell installiert?
2. Welche Versionen sind verfügbar?
3. Aus welchem Repository kommt das Paket?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Installierte Version
dpkg -l nginx | grep "^ii"
# oder
apt show nginx 2>/dev/null | grep "^Version"

# 2. Verfügbare Versionen
apt-cache policy nginx
# oder
apt policy nginx

# Zeigt:
# - Installierte Version
# - Candidate (würde installiert werden)
# - Versions-Tabelle mit Prioritäten

# 3. Repository-Quelle
apt-cache policy nginx | grep "http"
# Zeigt die Repository-URL
```

</details>

---

## Aufgabe 9: Nach Paketen in Repositories suchen

1. Suche nach Paketen die "monitoring" in der Beschreibung haben
2. Suche nach Paketen die eine bestimmte Datei bereitstellen würden

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Suche in Beschreibung
apt search monitoring
# Viele Ergebnisse!

# Genauer:
apt-cache search monitoring | grep -i system

# 2. Welches Paket stellt eine Datei bereit?
# Für NICHT installierte Pakete:
sudo apt install apt-file
sudo apt-file update

# Suchen
apt-file search /usr/bin/htop
# htop: /usr/bin/htop

apt-file search netstat
# net-tools: /bin/netstat

# Auch für Dateien die es noch nicht gibt!
apt-file search /usr/bin/docker
```

</details>

---

## Aufgabe 10: Installierte Pakete sichern und wiederherstellen

Erstelle eine Liste aller installierten Pakete (nützlich für Backups/Migration):

<details>
<summary>Lösung anzeigen</summary>

```bash
# Liste erstellen
dpkg --get-selections > ~/installed-packages.txt

# Anschauen
head ~/installed-packages.txt

# Nur manuell installierte Pakete (nicht automatische Abhängigkeiten)
apt-mark showmanual > ~/manual-packages.txt

# Auf einem neuen System wiederherstellen:
# sudo dpkg --set-selections < installed-packages.txt
# sudo apt-get dselect-upgrade

# Oder einfacher mit der manuellen Liste:
# xargs sudo apt install < manual-packages.txt
```

</details>

---

## Bonus: .deb Paket entpacken (ohne zu installieren)

Schau dir an, was in einem Paket steckt:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Paket herunterladen
apt download sl  # Kleines Fun-Paket

# In temporäres Verzeichnis entpacken
mkdir /tmp/sl-paket
dpkg-deb -x sl*.deb /tmp/sl-paket

# Anschauen
tree /tmp/sl-paket
ls -la /tmp/sl-paket/usr/games/

# Control-Dateien extrahieren
dpkg-deb -e sl*.deb /tmp/sl-control
cat /tmp/sl-control/control

# Aufräumen
rm -rf /tmp/sl-paket /tmp/sl-control sl*.deb

# Tipp: sl installieren und ausprobieren!
# sudo apt install sl
# sl
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Herausfinden, welches Paket eine Datei installiert hat
- Dateien eines Pakets auflisten
- Abhängigkeiten analysieren
- .deb Pakete untersuchen und manuell installieren
- Paket-Integrität prüfen
- Installierte Pakete exportieren

**Wichtige Befehle:**

| Aufgabe | Befehl |
|---------|--------|
| Datei → Paket | `dpkg -S /pfad/datei` |
| Paket → Dateien | `dpkg -L paket` |
| Abhängigkeiten | `apt depends paket` |
| Umgekehrte Deps | `apt rdepends paket` |
| .deb Info | `dpkg -I paket.deb` |
| .deb Inhalt | `dpkg -c paket.deb` |
| .deb installieren | `sudo dpkg -i paket.deb` |
| Integrität prüfen | `debsums -c paket` |
| Datei suchen | `apt-file search datei` |

---

Weiter geht's mit [Prozesse und Signale](../03_prozesse_signale/01_theorie.md)!
