---
title: "Lab: Berechtigungen setzen"
sidebar_position: 2
---

# Lab: Berechtigungen setzen

:::info Zeitrahmen
**Dauer:** ca. 1,25 Stunden
:::

---

## Aufgabe 1: Berechtigungen lesen und verstehen

Analysiere folgende Ausgaben und erkläre die Berechtigungen:

```
-rwxr-xr-x  root root    script.sh
drwxrwxr-x  alice developers  projekt/
-rw-------  bob  bob     geheim.txt
```

<details>
<summary>Lösung anzeigen</summary>

```
-rwxr-xr-x  root root    script.sh
# - = Datei
# rwx = Owner (root): lesen, schreiben, ausführen
# r-x = Group (root): lesen, ausführen
# r-x = Others: lesen, ausführen
# Oktal: 755

drwxrwxr-x  alice developers  projekt/
# d = Verzeichnis
# rwx = Owner (alice): voller Zugriff
# rwx = Group (developers): voller Zugriff
# r-x = Others: lesen und betreten, nicht schreiben
# Oktal: 775

-rw-------  bob bob     geheim.txt
# - = Datei
# rw- = Owner (bob): lesen, schreiben
# --- = Group: kein Zugriff
# --- = Others: kein Zugriff
# Oktal: 600
```

</details>

---

## Aufgabe 2: Berechtigungen mit chmod setzen

1. Erstelle eine Datei `test.txt`
2. Setze Berechtigungen auf 640 (rw-r-----)
3. Mache die Datei für alle lesbar (644)
4. Entferne Schreibrechte für den Owner

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Datei erstellen
touch ~/test.txt
ls -l ~/test.txt

# 2. Auf 640 setzen
chmod 640 ~/test.txt
ls -l ~/test.txt
# -rw-r----- ...

# 3. Für alle lesbar (644)
chmod 644 ~/test.txt
# oder
chmod o+r ~/test.txt
ls -l ~/test.txt
# -rw-r--r-- ...

# 4. Schreibrechte entfernen
chmod u-w ~/test.txt
ls -l ~/test.txt
# -r--r--r-- ...

# Zurücksetzen
chmod 644 ~/test.txt
```

</details>

---

## Aufgabe 3: Verzeichnis für Gruppe erstellen

Erstelle ein Verzeichnis, in dem alle Mitglieder der Gruppe "developers" arbeiten können:

1. Erstelle Gruppe und Verzeichnis
2. Setze SGID (neue Dateien erben Gruppe)
3. Teste mit verschiedenen Usern

<details>
<summary>Lösung anzeigen</summary>

```bash
# Gruppe und User erstellen
sudo groupadd developers
sudo useradd -m -s /bin/bash alice
sudo useradd -m -s /bin/bash bob
sudo usermod -aG developers alice
sudo usermod -aG developers bob
echo "alice:alice123" | sudo chpasswd
echo "bob:bob123" | sudo chpasswd

# Verzeichnis erstellen
sudo mkdir /opt/projekt
sudo chown root:developers /opt/projekt
sudo chmod 2775 /opt/projekt
# 2 = SGID, 775 = rwxrwxr-x

ls -ld /opt/projekt
# drwxrwsr-x ... root developers ... /opt/projekt

# Testen als alice
su - alice
touch /opt/projekt/alice.txt
ls -l /opt/projekt/alice.txt
# -rw-rw-r-- alice developers ... (Gruppe ist developers!)
exit

# Testen als bob
su - bob
touch /opt/projekt/bob.txt
ls -l /opt/projekt/
# Beide Dateien haben Gruppe "developers"
exit
```

</details>

---

## Aufgabe 4: Sticky Bit verstehen

1. Erstelle ein Verzeichnis `/tmp/shared` mit Sticky Bit
2. Erstelle als verschiedene User Dateien
3. Versuche, die Datei des anderen zu löschen

<details>
<summary>Lösung anzeigen</summary>

```bash
# Verzeichnis mit Sticky Bit
sudo mkdir /tmp/shared
sudo chmod 1777 /tmp/shared
ls -ld /tmp/shared
# drwxrwxrwt ... (t = Sticky Bit)

# Als alice Datei erstellen
su - alice
touch /tmp/shared/alice.txt
exit

# Als bob versuchen zu löschen
su - bob
rm /tmp/shared/alice.txt
# rm: cannot remove '/tmp/shared/alice.txt': Operation not permitted

# Eigene Datei geht
touch /tmp/shared/bob.txt
rm /tmp/shared/bob.txt  # OK
exit

# Sticky Bit bedeutet: Nur Besitzer kann löschen
```

</details>

---

## Aufgabe 5: SUID verstehen

Warum hat `/usr/bin/passwd` das SUID-Bit?

<details>
<summary>Lösung anzeigen</summary>

```bash
# passwd untersuchen
ls -l /usr/bin/passwd
# -rwsr-xr-x root root ... /usr/bin/passwd

# passwd muss /etc/shadow schreiben
ls -l /etc/shadow
# -rw-r----- root shadow ... /etc/shadow

# Nur root kann shadow schreiben!
# SUID = passwd läuft als root, auch wenn normaler User es aufruft
# → Kann das Passwort ändern

# Demonstration (nicht nachmachen auf Produktivsystemen!)
# Eigenes SUID-Programm:
echo '#!/bin/bash
echo "Running as: $(whoami)"
id' > /tmp/suid_test.sh
chmod 755 /tmp/suid_test.sh

# Als normaler User:
/tmp/suid_test.sh
# Running as: student

# ACHTUNG: SUID auf Shell-Skripte funktioniert aus Sicherheitsgründen NICHT!
# Nur auf kompilierte Binaries
```

</details>

---

## Aufgabe 6: umask verstehen

1. Zeige die aktuelle umask an
2. Erstelle eine Datei und ein Verzeichnis - welche Rechte haben sie?
3. Ändere umask auf 077 und wiederhole

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Aktuelle umask
umask
# 0022

# 2. Datei und Verzeichnis erstellen
touch test_file
mkdir test_dir
ls -l test_file
# -rw-r--r-- (666 - 022 = 644)
ls -ld test_dir
# drwxr-xr-x (777 - 022 = 755)

# 3. umask ändern
umask 077
touch private_file
mkdir private_dir
ls -l private_file
# -rw------- (666 - 077 = 600)
ls -ld private_dir
# drwx------ (777 - 077 = 700)

# Aufräumen
rm test_file private_file
rmdir test_dir private_dir

# umask zurücksetzen
umask 022
```

</details>

---

## Aufgabe 7: Besitzer ändern

1. Erstelle eine Datei als student
2. Ändere den Besitzer zu root
3. Ändere Besitzer und Gruppe gleichzeitig

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Datei erstellen
touch ~/myfile.txt
ls -l ~/myfile.txt
# -rw-r--r-- student student ...

# 2. Besitzer ändern (braucht sudo)
sudo chown root ~/myfile.txt
ls -l ~/myfile.txt
# -rw-r--r-- root student ...

# 3. Besitzer und Gruppe
sudo chown alice:developers ~/myfile.txt
ls -l ~/myfile.txt
# -rw-r--r-- alice developers ...

# Nur Gruppe ändern
sudo chgrp staff ~/myfile.txt 2>/dev/null || sudo chown :student ~/myfile.txt
ls -l ~/myfile.txt

# Aufräumen
sudo rm ~/myfile.txt
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- Berechtigungen lesen und interpretieren
- `chmod` in Oktal- und symbolischer Notation
- SUID, SGID, Sticky Bit verstehen und setzen
- `umask` für Standard-Berechtigungen
- `chown` und `chgrp` für Besitzwechsel

---

Weiter zum [Lab: ACLs konfigurieren](./03_lab_acls.md)!
