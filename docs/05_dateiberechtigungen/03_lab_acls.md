---
title: "Lab: ACLs konfigurieren"
sidebar_position: 3
---

# Lab: ACLs konfigurieren

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

ACLs (Access Control Lists) erlauben feinere Rechtevergabe als das klassische Unix-Modell.

---

## Aufgabe 1: ACL-Unterstützung prüfen

1. Prüfe ob ACLs auf deinem Dateisystem unterstützt werden
2. Installiere die ACL-Tools falls nötig

<details>
<summary>Lösung anzeigen</summary>

```bash
# Dateisystem prüfen
mount | grep " / "
# Zeigt Mount-Optionen

# ACLs testen
touch /tmp/acltest
setfacl -m u:root:rw /tmp/acltest && echo "ACLs supported!"
rm /tmp/acltest

# ACL-Tools installieren
sudo apt install acl

# ext4 hat ACL-Support standardmäßig
# Für andere Dateisysteme ggf. mit "acl" Mount-Option mounten
```

</details>

---

## Aufgabe 2: ACL für einzelnen User setzen

1. Erstelle eine Datei die alice gehört
2. Gib bob Leserechte über ACL
3. Zeige die ACLs an

<details>
<summary>Lösung anzeigen</summary>

```bash
# Sicherstellen dass User existieren
sudo useradd -m bob 2>/dev/null || true

# Datei erstellen (als alice oder mit chown)
sudo touch /tmp/alice_file.txt
sudo chown alice:alice /tmp/alice_file.txt
sudo chmod 600 /tmp/alice_file.txt

ls -l /tmp/alice_file.txt
# -rw------- alice alice

# ACL für bob setzen
sudo setfacl -m u:bob:r /tmp/alice_file.txt

# ACLs anzeigen
getfacl /tmp/alice_file.txt
# user::rw-
# user:bob:r--
# group::---
# mask::r--
# other::---

# Beachte das + bei ls
ls -l /tmp/alice_file.txt
# -rw-r-----+ alice alice
#          ^
```

</details>

---

## Aufgabe 3: ACL für Gruppe setzen

Gib der Gruppe "auditors" Leserechte auf `/var/log/auth.log`:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Gruppe erstellen
sudo groupadd auditors 2>/dev/null || true

# ACL setzen
sudo setfacl -m g:auditors:r /var/log/auth.log

# Prüfen
getfacl /var/log/auth.log

# Testen
# User zu auditors hinzufügen
sudo usermod -aG auditors bob

# Als bob (neu einloggen für Gruppen-Update)
# su - bob
# cat /var/log/auth.log  # sollte funktionieren
```

</details>

---

## Aufgabe 4: Default-ACLs für Verzeichnisse

Konfiguriere ein Verzeichnis so, dass neue Dateien automatisch ACLs erben:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Verzeichnis erstellen
sudo mkdir /opt/shared
sudo chmod 770 /opt/shared

# Default-ACL setzen (für neue Dateien)
sudo setfacl -d -m g:developers:rwx /opt/shared
sudo setfacl -d -m u:bob:rx /opt/shared

# ACLs anzeigen
getfacl /opt/shared
# default:user::rwx
# default:user:bob:r-x
# default:group::rwx
# default:group:developers:rwx
# default:mask::rwx
# default:other::---

# Testen - neue Datei erstellen
sudo touch /opt/shared/newfile.txt
getfacl /opt/shared/newfile.txt
# Erbt die Default-ACLs!
```

</details>

---

## Aufgabe 5: ACLs entfernen

1. Entferne eine spezifische ACL
2. Entferne alle ACLs von einer Datei

<details>
<summary>Lösung anzeigen</summary>

```bash
# Spezifische ACL entfernen
sudo setfacl -x u:bob /tmp/alice_file.txt

getfacl /tmp/alice_file.txt
# user:bob fehlt jetzt

# Alle ACLs entfernen
sudo setfacl -b /tmp/alice_file.txt

getfacl /tmp/alice_file.txt
# Nur noch Standard-Rechte

ls -l /tmp/alice_file.txt
# Kein + mehr
```

</details>

---

## Aufgabe 6: ACLs kopieren

Kopiere ACLs von einer Datei auf eine andere:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Quelle mit ACLs vorbereiten
touch /tmp/source.txt
setfacl -m u:bob:rw /tmp/source.txt
setfacl -m g:developers:r /tmp/source.txt

# Ziel erstellen
touch /tmp/target.txt

# ACLs kopieren
getfacl /tmp/source.txt | setfacl --set-file=- /tmp/target.txt

# Prüfen
getfacl /tmp/target.txt

# Aufräumen
rm /tmp/source.txt /tmp/target.txt
```

</details>

---

## Aufgabe 7: Die mask verstehen

Die mask begrenzt die effektiven Rechte:

<details>
<summary>Lösung anzeigen</summary>

```bash
touch /tmp/masktest.txt
setfacl -m u:bob:rwx /tmp/masktest.txt

getfacl /tmp/masktest.txt
# user:bob:rwx

# mask setzen
setfacl -m m::r /tmp/masktest.txt

getfacl /tmp/masktest.txt
# user:bob:rwx    #effective:r--
# mask::r--

# Obwohl bob rwx hat, sind effektiv nur r-Rechte!
# Die mask ist wie ein Filter

rm /tmp/masktest.txt
```

</details>

---

## Aufgabe 8: Backup und Restore von ACLs

Sichere und stelle ACLs wieder her:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Verzeichnis mit ACLs vorbereiten
mkdir /tmp/acldir
touch /tmp/acldir/file{1,2,3}.txt
setfacl -m u:bob:rw /tmp/acldir/file1.txt
setfacl -m g:developers:rx /tmp/acldir/file2.txt

# ACLs sichern (rekursiv)
getfacl -R /tmp/acldir > /tmp/acl_backup.txt
cat /tmp/acl_backup.txt

# ACLs löschen
setfacl -R -b /tmp/acldir

# Prüfen - keine ACLs mehr
getfacl /tmp/acldir/file1.txt

# ACLs wiederherstellen
cd /
setfacl --restore=/tmp/acl_backup.txt

# Prüfen
getfacl /tmp/acldir/file1.txt
# ACLs sind zurück!

# Aufräumen
rm -rf /tmp/acldir /tmp/acl_backup.txt
```

</details>

---

## Aufgabe 9: Praktisches Szenario

Erstelle folgendes Setup:
- Verzeichnis `/opt/webapp`
- User `webdev` hat volle Rechte
- Gruppe `testers` hat Lese- und Ausführrechte
- Alle anderen haben keinen Zugriff
- Neue Dateien sollen diese Rechte erben

<details>
<summary>Lösung anzeigen</summary>

```bash
# Setup
sudo useradd -m webdev 2>/dev/null || true
sudo groupadd testers 2>/dev/null || true

# Verzeichnis erstellen
sudo mkdir -p /opt/webapp
sudo chown webdev:webdev /opt/webapp
sudo chmod 700 /opt/webapp

# ACLs setzen
sudo setfacl -m g:testers:rx /opt/webapp

# Default-ACLs für neue Dateien
sudo setfacl -d -m u::rwx /opt/webapp       # Owner
sudo setfacl -d -m g::--- /opt/webapp       # Gruppe
sudo setfacl -d -m g:testers:rx /opt/webapp # testers
sudo setfacl -d -m o::--- /opt/webapp       # Others

# Prüfen
getfacl /opt/webapp

# Testen
sudo -u webdev touch /opt/webapp/app.py
getfacl /opt/webapp/app.py
# testers hat rx
```

</details>

---

## Aufräumen

```bash
# Test-User und -Gruppen entfernen
sudo userdel -r alice 2>/dev/null
sudo userdel -r bob 2>/dev/null
sudo userdel -r webdev 2>/dev/null
sudo groupdel developers 2>/dev/null
sudo groupdel auditors 2>/dev/null
sudo groupdel testers 2>/dev/null

# Verzeichnisse entfernen
sudo rm -rf /opt/projekt /opt/shared /opt/webapp /tmp/shared
```

---

## Zusammenfassung

Du hast gelernt:
- ACLs für User und Gruppen setzen
- Default-ACLs für automatische Vererbung
- ACLs anzeigen, kopieren, sichern und wiederherstellen
- Die mask verstehen

---

Weiter geht's mit dem [Netzwerk](../06_netzwerk/01_theorie.md)!
