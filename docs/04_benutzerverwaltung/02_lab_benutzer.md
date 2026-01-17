---
title: "Lab: Benutzer anlegen"
sidebar_position: 2
---

# Lab: Benutzer anlegen

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden
:::

In diesem Lab lernst du, Benutzer und deren Passwörter zu verwalten.

---

## Aufgabe 1: Ersten Benutzer anlegen

1. Erstelle einen neuen Benutzer `webadmin` mit Home-Verzeichnis und bash als Shell
2. Setze ein Passwort für webadmin
3. Logge dich als webadmin ein und prüfe das Home-Verzeichnis
4. Logge dich wieder aus

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Benutzer anlegen
sudo useradd -m -s /bin/bash webadmin
# -m = Home-Verzeichnis erstellen
# -s = Shell festlegen

# Prüfen ob angelegt
grep webadmin /etc/passwd
id webadmin

# 2. Passwort setzen
sudo passwd webadmin
# Passwort zweimal eingeben (z.B. "webadmin123")

# 3. Als webadmin einloggen
su - webadmin
# "-" = Login-Shell (lädt Profile)

pwd
# /home/webadmin

whoami
# webadmin

ls -la
# Zeigt Dateien im Home

# 4. Ausloggen
exit
```

</details>

---

## Aufgabe 2: Benutzer-Informationen auslesen

1. Zeige alle Informationen über den User webadmin
2. Welche UID und GID hat webadmin?
3. Zeige den Eintrag in /etc/passwd und /etc/shadow

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Alle Infos
id webadmin
# uid=1001(webadmin) gid=1001(webadmin) groups=1001(webadmin)

# 2. UID und GID
id -u webadmin   # UID
id -g webadmin   # GID

# 3. passwd-Eintrag
grep webadmin /etc/passwd
# webadmin:x:1001:1001::/home/webadmin:/bin/bash

# shadow-Eintrag (braucht root)
sudo grep webadmin /etc/shadow
# webadmin:$6$...(gehashtes Passwort)...:...

# Finger-Infos (falls chfn genutzt wurde)
finger webadmin 2>/dev/null || echo "finger nicht installiert"
```

</details>

---

## Aufgabe 3: Gruppe erstellen und Benutzer hinzufügen

1. Erstelle eine Gruppe `entwickler`
2. Füge webadmin zur Gruppe hinzu
3. Prüfe die Gruppenmitgliedschaft

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Gruppe erstellen
sudo groupadd entwickler

# Prüfen
grep entwickler /etc/group

# 2. webadmin hinzufügen
sudo usermod -aG entwickler webadmin
# WICHTIG: -a (append) nicht vergessen!

# 3. Prüfen
groups webadmin
# webadmin : webadmin entwickler

id webadmin
# groups=...,entwickler

# Oder in /etc/group schauen
grep entwickler /etc/group
# entwickler:x:1002:webadmin
```

</details>

---

## Aufgabe 4: sudo-Rechte konfigurieren

Konfiguriere sudo so, dass webadmin nur nginx-Befehle ausführen darf:

1. Installiere nginx (falls nicht vorhanden)
2. Erstelle eine sudo-Regel für webadmin
3. Teste als webadmin

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. nginx installieren
sudo apt install nginx

# 2. sudo-Regel erstellen
sudo visudo -f /etc/sudoers.d/webadmin

# Folgende Zeile einfügen:
webadmin ALL=(ALL) /usr/bin/systemctl restart nginx, /usr/bin/systemctl status nginx, /usr/bin/systemctl stop nginx, /usr/bin/systemctl start nginx

# Speichern und beenden

# 3. Testen
su - webadmin

# Das sollte funktionieren:
sudo systemctl status nginx
sudo systemctl restart nginx

# Das sollte NICHT funktionieren:
sudo apt update
# Sorry, user webadmin is not allowed to execute '/usr/bin/apt update' as root

exit
```

</details>

---

## Aufgabe 5: Passwort-Alterung konfigurieren

1. Zeige die Passwort-Einstellungen von webadmin
2. Setze: Passwort muss alle 90 Tage geändert werden
3. Setze: Warnung 14 Tage vorher
4. Erzwinge Passwortänderung beim nächsten Login

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Aktuelle Einstellungen
sudo chage -l webadmin

# 2. Maximale Gültigkeit 90 Tage
sudo chage -M 90 webadmin

# 3. Warnung 14 Tage vorher
sudo chage -W 14 webadmin

# 4. Passwort sofort ablaufen lassen
sudo chage -d 0 webadmin
# oder
sudo passwd -e webadmin

# Prüfen
sudo chage -l webadmin
# Password expires: 90 Tage ab letzter Änderung
# Password inactive: never
# Account expires: never
# ...
# Last password change: password must be changed

# Testen (beim Login muss Passwort geändert werden)
su - webadmin
# You are required to change your password immediately
```

</details>

---

## Aufgabe 6: Account sperren und entsperren

1. Sperre den Account von webadmin
2. Versuche dich als webadmin einzuloggen
3. Entsperre den Account wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Account sperren
sudo usermod -L webadmin

# Prüfen
sudo passwd -S webadmin
# webadmin L ... (L = Locked)

# In /etc/shadow hat das Passwort jetzt ein ! am Anfang
sudo grep webadmin /etc/shadow

# 2. Login-Versuch
su - webadmin
# Password:
# su: Authentication failure

# 3. Entsperren
sudo usermod -U webadmin

# Prüfen
sudo passwd -S webadmin
# webadmin P ... (P = Password set)

# Login sollte wieder funktionieren
su - webadmin
exit
```

</details>

---

## Aufgabe 7: Benutzer mit eingeschränkter Shell

Erstelle einen Benutzer, der sich nur per SFTP einloggen kann (keine Shell):

<details>
<summary>Lösung anzeigen</summary>

```bash
# Benutzer mit nologin-Shell erstellen
sudo useradd -m -s /usr/sbin/nologin sftpuser

# Passwort setzen
sudo passwd sftpuser

# Login-Versuch
su - sftpuser
# This account is currently not available.

# SSH-Versuch (falls SSH läuft)
ssh sftpuser@localhost
# This account is currently not available.
# Connection to localhost closed.

# SFTP funktioniert trotzdem:
# sftp sftpuser@localhost
# (würde Dateitransfer erlauben)

# Alternative: /bin/false als Shell
sudo useradd -m -s /bin/false noLoginUser
```

</details>

---

## Aufgabe 8: Benutzer modifizieren

1. Ändere den Kommentar (GECOS) von webadmin zu "Web Administrator"
2. Ändere das Home-Verzeichnis zu /var/www/admin (nicht verschieben!)
3. Mache die Änderung rückgängig

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Kommentar ändern
sudo usermod -c "Web Administrator" webadmin

# Prüfen
grep webadmin /etc/passwd
# webadmin:x:1001:1001:Web Administrator:/home/webadmin:/bin/bash

# 2. Home-Verzeichnis in passwd ändern (ohne zu verschieben)
sudo usermod -d /var/www/admin webadmin

grep webadmin /etc/passwd
# ...:/var/www/admin:...

# ACHTUNG: Das Verzeichnis existiert nicht und wurde nicht verschoben!
# Das ist selten sinnvoll. Normalerweise mit -m:
# sudo usermod -d /var/www/admin -m webadmin

# 3. Rückgängig machen
sudo usermod -d /home/webadmin webadmin

grep webadmin /etc/passwd
```

</details>

---

## Aufgabe 9: Benutzer löschen

1. Erstelle einen temporären Testuser
2. Lösche ihn ohne sein Home-Verzeichnis
3. Prüfe ob das Home noch existiert
4. Lösche das Home manuell
5. Erstelle nochmal und lösche komplett mit -r

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Testuser erstellen
sudo useradd -m -s /bin/bash testuser
sudo passwd testuser

# 2. Löschen ohne Home
sudo userdel testuser

# 3. Home prüfen
ls -la /home/testuser
# Existiert noch!

# 4. Manuell löschen
sudo rm -rf /home/testuser

# 5. Nochmal erstellen und komplett löschen
sudo useradd -m -s /bin/bash testuser
ls /home/testuser   # Existiert

sudo userdel -r testuser
ls /home/testuser
# ls: cannot access '/home/testuser': No such file or directory
```

</details>

---

## Aufgabe 10: System-Benutzer erstellen

Erstelle einen System-Account für einen hypothetischen Dienst:

<details>
<summary>Lösung anzeigen</summary>

```bash
# System-Account erstellen
sudo useradd --system --no-create-home --shell /usr/sbin/nologin myservice

# Prüfen
id myservice
# UID sollte < 1000 sein

grep myservice /etc/passwd
# myservice:x:xxx:xxx::/home/myservice:/usr/sbin/nologin

# System-Accounts haben typischerweise:
# - UID < 1000 (oder 500 auf älteren Systemen)
# - Kein Home-Verzeichnis
# - /sbin/nologin oder /bin/false als Shell
# - Werden für Dienste verwendet (nginx, mysql, etc.)

# Aufräumen
sudo userdel myservice
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Benutzer mit `useradd` anlegen
- Passwörter mit `passwd` setzen
- Benutzer mit `usermod` modifizieren
- Passwort-Alterung mit `chage` konfigurieren
- Accounts sperren/entsperren
- Benutzer mit `userdel` löschen

---

Weiter zum [Lab: Gruppen und sudo](./03_lab_gruppen.md)!
