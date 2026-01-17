---
title: "Lab: Dateien manipulieren"
sidebar_position: 3
---

# Lab: Dateien manipulieren

:::info Zeitrahmen
**Dauer:** ca. 1,25 Stunden
:::

In diesem Lab lernst du, Dateien und Verzeichnisse zu erstellen, kopieren, verschieben und zu löschen.

---

## Aufgabe 1: Dateien erstellen und bearbeiten

1. Erstelle eine leere Datei namens `test.txt` in deinem Home-Verzeichnis
2. Schreibe "Hallo Linux!" in die Datei
3. Füge eine zweite Zeile hinzu: "Das ist Zeile 2"
4. Zeige den Inhalt an

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Leere Datei erstellen
touch ~/test.txt

# 2. Text hineinschreiben (überschreibt!)
echo "Hallo Linux!" > ~/test.txt

# 3. Text anhängen (>>)
echo "Das ist Zeile 2" >> ~/test.txt

# 4. Inhalt anzeigen
cat ~/test.txt
```

**Wichtig:**
- `>` überschreibt die Datei
- `>>` hängt an

</details>

---

## Aufgabe 2: Kopieren und Umbenennen

1. Kopiere `test.txt` nach `test_backup.txt`
2. Benenne `test.txt` um in `meine_datei.txt`
3. Erstelle ein Verzeichnis `backup` und kopiere beide Dateien hinein

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Kopieren
cp ~/test.txt ~/test_backup.txt

# 2. Umbenennen (mv = move, funktioniert auch zum Umbenennen)
mv ~/test.txt ~/meine_datei.txt

# 3. Verzeichnis erstellen und Dateien kopieren
mkdir ~/backup
cp ~/meine_datei.txt ~/test_backup.txt ~/backup/

# Oder mit Wildcard:
cp ~/*.txt ~/backup/

# Überprüfen
ls ~/backup/
```

</details>

---

## Aufgabe 3: Dateien löschen

1. Lösche `test_backup.txt` aus dem Home-Verzeichnis
2. Lösche das `backup`-Verzeichnis mit allem Inhalt

:::warning Vorsicht mit rm!
`rm` löscht unwiderruflich! Es gibt keinen Papierkorb.
:::

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Einzelne Datei löschen
rm ~/test_backup.txt

# 2. Verzeichnis mit Inhalt löschen
rm -r ~/backup
# -r = recursive (notwendig für Verzeichnisse)

# Sicherer mit Bestätigung:
rm -ri ~/backup
# -i = interactive, fragt bei jeder Datei

# Oder: Erst leeren, dann löschen
rm ~/backup/*
rmdir ~/backup  # Funktioniert nur bei leeren Verzeichnissen
```

</details>

---

## Aufgabe 4: Log-Dateien untersuchen

1. Zeige die ersten 10 Zeilen von `/var/log/syslog`
2. Zeige die letzten 20 Zeilen
3. Folge der Datei live (neue Einträge werden angezeigt)
4. Öffne die Datei in einem Pager zum Durchblättern

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Erste 10 Zeilen
head /var/log/syslog
# oder explizit:
head -n 10 /var/log/syslog

# 2. Letzte 20 Zeilen
tail -n 20 /var/log/syslog
# oder kurz:
tail -20 /var/log/syslog

# 3. Live folgen (Ctrl+C zum Beenden)
tail -f /var/log/syslog
# Öffne ein zweites Terminal und führe einen Befehl aus
# Du siehst die neuen Log-Einträge!

# 4. Im Pager öffnen
less /var/log/syslog
# Navigation: Space, b, /, q
# Tipp: less +F verhält sich wie tail -f
```

</details>

---

## Aufgabe 5: Symbolic Links erstellen

1. Erstelle einen Symlink von `~/logs` der auf `/var/log` zeigt
2. Verifiziere, dass der Link funktioniert
3. Zeige die Link-Details an
4. Lösche den Symlink (ohne das Ziel zu löschen!)

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Symlink erstellen
ln -s /var/log ~/logs
# Syntax: ln -s ZIEL LINKNAME

# 2. Testen
ls ~/logs
# Zeigt den Inhalt von /var/log!

# 3. Link-Details
ls -l ~/logs
# lrwxrwxrwx ... logs -> /var/log
# 'l' am Anfang = Link

# 4. Symlink löschen
rm ~/logs
# Löscht nur den Link, nicht /var/log!
# ACHTUNG: rm ~/logs/ (mit Slash) würde evtl. den Inhalt löschen!
```

</details>

---

## Aufgabe 6: Mit grep suchen

1. Suche nach deinem Benutzernamen in `/etc/passwd`
2. Suche nach allen Zeilen die "error" enthalten in `/var/log/syslog` (case-insensitive)
3. Zeige 2 Zeilen Kontext vor und nach jedem Treffer

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Benutzer in passwd finden
grep student /etc/passwd
# Zeigt die komplette Zeile

# 2. Case-insensitive Suche
grep -i error /var/log/syslog
# -i = ignore case

# 3. Mit Kontext
grep -i -B 2 -A 2 error /var/log/syslog
# -B 2 = 2 Zeilen Before
# -A 2 = 2 Zeilen After
# Oder kombiniert:
grep -i -C 2 error /var/log/syslog
# -C 2 = 2 Zeilen Context (before AND after)

# Bonus: Nur Anzahl der Treffer
grep -ic error /var/log/syslog
```

</details>

---

## Aufgabe 7: Pipes verwenden

Pipes (`|`) verbinden die Ausgabe eines Befehls mit der Eingabe des nächsten.

1. Zeige alle Benutzer (nur Namen) sortiert
2. Zähle wie viele Dateien in `/etc` liegen
3. Finde die 5 größten Dateien in `/var/log`

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Benutzer sortiert
# /etc/passwd Format: username:x:uid:gid:info:home:shell
cut -d: -f1 /etc/passwd | sort
# cut: Spalte 1, Trennzeichen ":"
# sort: alphabetisch sortieren

# 2. Dateien zählen in /etc
ls /etc | wc -l
# ls gibt Dateien aus, wc -l zählt Zeilen

# 3. Größte Dateien in /var/log
ls -lS /var/log | head -6
# -S = Sort by Size (größte zuerst)
# head -6 weil erste Zeile "total" ist

# Oder mit du für Verzeichnisse:
sudo du -sh /var/log/* | sort -hr | head -5
# sort -hr = human-readable, reverse (größte zuerst)
```

</details>

---

## Aufgabe 8: Dateien finden

1. Finde alle `.log` Dateien in `/var/log`
2. Finde alle Dateien die in den letzten 24 Stunden geändert wurden (in `/etc`)
3. Finde alle Dateien größer als 10MB im gesamten System

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. .log Dateien
find /var/log -name "*.log"
# oder nur im Verzeichnis selbst (nicht rekursiv):
find /var/log -maxdepth 1 -name "*.log"

# 2. Kürzlich geänderte Dateien
find /etc -mtime -1 2>/dev/null
# -mtime -1 = modified time weniger als 1 Tag
# 2>/dev/null unterdrückt "Permission denied"

# Oder mit -mmin für Minuten:
find /etc -mmin -60 2>/dev/null  # letzte Stunde

# 3. Große Dateien
sudo find / -size +10M 2>/dev/null
# -size +10M = größer als 10 Megabyte
# Kann einen Moment dauern!

# Nützliche Variante - mit Größe anzeigen:
sudo find / -size +10M -exec ls -lh {} \; 2>/dev/null
```

</details>

---

## Aufgabe 9: Textdateien erstellen mit Here-Doc

Erstelle eine Datei `server_info.txt` mit mehreren Zeilen auf einmal:

```
Servername: ubuntu-server
Erstellt: [heutiges Datum]
Admin: student
```

<details>
<summary>Lösung anzeigen</summary>

```bash
# Methode 1: Here-Document
cat << EOF > ~/server_info.txt
Servername: ubuntu-server
Erstellt: $(date)
Admin: student
EOF

# Methode 2: Mehrere echo-Befehle
echo "Servername: ubuntu-server" > ~/server_info.txt
echo "Erstellt: $(date)" >> ~/server_info.txt
echo "Admin: student" >> ~/server_info.txt

# Überprüfen
cat ~/server_info.txt

# $(date) wird durch das aktuelle Datum ersetzt
# Das nennt sich "Command Substitution"
```

</details>

---

## Aufgabe 10: Arbeiten mit Wildcards

Wildcards (Jokerzeichen) helfen, mehrere Dateien auf einmal anzusprechen:

| Wildcard | Bedeutung |
|----------|-----------|
| `*` | Beliebig viele Zeichen |
| `?` | Genau ein Zeichen |
| `[abc]` | Ein Zeichen aus der Menge |
| `[0-9]` | Eine Ziffer |

1. Liste alle `.conf` Dateien in `/etc` auf
2. Erstelle Dateien `test1.txt`, `test2.txt`, `test3.txt` mit einem Befehl
3. Lösche alle diese Testdateien mit einem Befehl

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. .conf Dateien
ls /etc/*.conf

# 2. Mehrere Dateien erstellen
# Mit Brace Expansion (kein Wildcard, aber ähnlich):
touch ~/test{1,2,3}.txt
# Erstellt: test1.txt test2.txt test3.txt

# Oder mit Sequenz:
touch ~/test{1..5}.txt
# Erstellt: test1.txt bis test5.txt

# 3. Alle test*.txt löschen
rm ~/test*.txt
# * matcht: 1, 2, 3 (und alle anderen)

# Sicherer - erst anzeigen was gelöscht wird:
ls ~/test*.txt
rm ~/test*.txt
```

</details>

---

## Bonus: Archiv erstellen

Erstelle ein tar-Archiv deines `projekte`-Verzeichnisses:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Archiv erstellen
tar -cvf ~/projekte.tar ~/projekte
# -c = create
# -v = verbose (zeigt Dateien)
# -f = filename

# Mit Kompression (gzip):
tar -czvf ~/projekte.tar.gz ~/projekte
# -z = gzip

# Inhalt anzeigen ohne zu entpacken:
tar -tzvf ~/projekte.tar.gz

# Entpacken:
tar -xzvf ~/projekte.tar.gz -C /tmp
# -x = extract
# -C = Zielverzeichnis
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Dateien erstellen, kopieren, verschieben, löschen
- Symbolic Links erstellen und verstehen
- Mit `grep` in Dateien suchen
- Pipes für komplexe Operationen
- `find` für die Dateisuche
- Wildcards für Dateioperationen

**Neue Befehle:**

| Befehl | Funktion |
|--------|----------|
| `touch` | Leere Datei erstellen |
| `cp` | Kopieren |
| `mv` | Verschieben/Umbenennen |
| `rm` | Löschen |
| `ln -s` | Symlink erstellen |
| `head/tail` | Anfang/Ende einer Datei |
| `grep` | In Dateien suchen |
| `cut` | Spalten ausschneiden |
| `sort` | Sortieren |
| `wc` | Wörter/Zeilen zählen |
| `tar` | Archive erstellen |

**Wichtige Konzepte:**

- `>` überschreibt, `>>` hängt an
- `|` verbindet Befehle (Pipe)
- `*`, `?`, `[]` sind Wildcards
- `$(command)` führt Befehl aus und setzt Ergebnis ein

---

Weiter geht's mit der [Paketverwaltung](../02_paketverwaltung/01_theorie.md)!
