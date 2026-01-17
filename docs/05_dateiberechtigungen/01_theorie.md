---
title: Dateiberechtigungen
sidebar_position: 1
---

# Dateiberechtigungen

## Das Berechtigungsmodell

Jede Datei und jedes Verzeichnis hat:
- Einen **Besitzer** (Owner)
- Eine **Gruppe** (Group)
- **Berechtigungen** für Owner, Group und Others

```
-rwxr-xr-- 1 alice developers 4096 Jan 15 10:00 script.sh
│├─┤├─┤├─┤   │     │
││  │  │     │     └─ Gruppen-Besitz
││  │  │     └─ Besitzer
││  │  └─ Others (alle anderen)
││  └─ Group (Gruppenmitglieder)
│└─ Owner (Besitzer)
└─ Dateityp (- = Datei, d = Verzeichnis)
```

## Berechtigungstypen

| Symbol | Oktal | Datei | Verzeichnis |
|--------|-------|-------|-------------|
| `r` (read) | 4 | Lesen | Auflisten |
| `w` (write) | 2 | Schreiben | Erstellen/Löschen |
| `x` (execute) | 1 | Ausführen | Betreten (cd) |

## Oktal-Notation

```
rwx = 4+2+1 = 7
rw- = 4+2+0 = 6
r-x = 4+0+1 = 5
r-- = 4+0+0 = 4
```

Beispiele:
- `755` = rwxr-xr-x (Owner: alles, Group+Others: lesen+ausführen)
- `644` = rw-r--r-- (Owner: lesen+schreiben, Rest: nur lesen)
- `700` = rwx------ (Nur Owner hat Zugriff)

## chmod - Berechtigungen ändern

```bash
# Oktal-Notation
chmod 755 script.sh
chmod 644 config.txt

# Symbolische Notation
chmod u+x script.sh      # User: execute hinzufügen
chmod g-w file.txt       # Group: write entfernen
chmod o=r file.txt       # Others: nur read
chmod a+r file.txt       # All: read hinzufügen
chmod u=rwx,g=rx,o= file # Explizit setzen

# Rekursiv
chmod -R 755 verzeichnis/
```

| Symbol | Bedeutung |
|--------|-----------|
| `u` | User (Owner) |
| `g` | Group |
| `o` | Others |
| `a` | All (ugo) |
| `+` | Hinzufügen |
| `-` | Entfernen |
| `=` | Setzen |

## chown/chgrp - Besitzer ändern

```bash
# Besitzer ändern
sudo chown alice file.txt

# Besitzer und Gruppe
sudo chown alice:developers file.txt

# Nur Gruppe
sudo chgrp developers file.txt
# oder
sudo chown :developers file.txt

# Rekursiv
sudo chown -R alice:developers projekt/
```

## Spezial-Bits

### SUID (Set User ID)

Programm läuft mit Rechten des Datei-Besitzers:

```bash
ls -l /usr/bin/passwd
# -rwsr-xr-x 1 root root ... /usr/bin/passwd
#    ^
# s statt x = SUID gesetzt

# SUID setzen
chmod u+s programm
chmod 4755 programm
```

### SGID (Set Group ID)

- Bei Dateien: Läuft mit Rechten der Datei-Gruppe
- Bei Verzeichnissen: Neue Dateien erben die Gruppe

```bash
# SGID auf Verzeichnis
chmod g+s verzeichnis/
chmod 2775 verzeichnis/

ls -ld verzeichnis/
# drwxrwsr-x
#       ^
```

### Sticky Bit

Nur Besitzer kann Dateien löschen (wichtig für /tmp):

```bash
ls -ld /tmp
# drwxrwxrwt
#          ^
# t = Sticky Bit

chmod +t verzeichnis/
chmod 1777 verzeichnis/
```

## umask - Standard-Berechtigungen

`umask` definiert, welche Berechtigungen bei neuen Dateien **entfernt** werden:

```bash
umask
# 0022

# Berechnung:
# Dateien: 666 - 022 = 644 (rw-r--r--)
# Verzeichnisse: 777 - 022 = 755 (rwxr-xr-x)

# Ändern (für aktuelle Shell)
umask 077   # Nur Owner hat Zugriff
# Dateien: 666 - 077 = 600
# Verzeichnisse: 777 - 077 = 700
```

## ACLs (Access Control Lists)

Für feinere Kontrolle als das Standard-Modell:

```bash
# ACLs installieren (falls nötig)
sudo apt install acl

# ACL für einzelnen User setzen
setfacl -m u:bob:rw file.txt

# ACL für Gruppe
setfacl -m g:developers:rx projekt/

# Default-ACL (für neue Dateien)
setfacl -d -m g:developers:rwx projekt/

# ACLs anzeigen
getfacl file.txt

# ACL entfernen
setfacl -x u:bob file.txt

# Alle ACLs entfernen
setfacl -b file.txt
```

Eine Datei mit ACLs hat ein `+` in der `ls -l` Ausgabe:
```
-rw-rw-r--+ 1 alice alice ... file.txt
          ^
```

## Zusammenfassung

| Befehl | Funktion |
|--------|----------|
| `chmod 755 datei` | Berechtigungen setzen |
| `chmod u+x datei` | Execute für Owner hinzufügen |
| `chown user:group datei` | Besitzer ändern |
| `chgrp group datei` | Gruppe ändern |
| `chmod u+s` / `chmod 4xxx` | SUID setzen |
| `chmod g+s` / `chmod 2xxx` | SGID setzen |
| `chmod +t` / `chmod 1xxx` | Sticky Bit setzen |
| `umask 022` | Standard-Berechtigungen |
| `setfacl -m u:user:rw` | ACL setzen |
| `getfacl datei` | ACLs anzeigen |

---

Weiter zum [Lab: Berechtigungen setzen](./02_lab_berechtigungen.md)!
