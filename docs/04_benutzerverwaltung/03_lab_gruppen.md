---
title: "Lab: Gruppen und sudo"
sidebar_position: 3
---

# Lab: Gruppen und sudo

:::info Zeitrahmen
**Dauer:** ca. 1 Stunde
:::

In diesem Lab übst du die Gruppenverwaltung und sudo-Konfiguration.

---

## Aufgabe 1: Mehrere Benutzer und Gruppen anlegen

Erstelle folgendes Setup:
- Benutzer: alice, bob, charlie
- Gruppen: admins, developers
- alice und bob sind developers
- charlie ist admin

<details>
<summary>Lösung anzeigen</summary>

```bash
# Gruppen anlegen
sudo groupadd admins
sudo groupadd developers

# Benutzer anlegen
sudo useradd -m -s /bin/bash alice
sudo useradd -m -s /bin/bash bob
sudo useradd -m -s /bin/bash charlie

# Passwörter setzen (einfache für Lab)
echo "alice:alice123" | sudo chpasswd
echo "bob:bob123" | sudo chpasswd
echo "charlie:charlie123" | sudo chpasswd

# Gruppenmitgliedschaften
sudo usermod -aG developers alice
sudo usermod -aG developers bob
sudo usermod -aG admins charlie

# Prüfen
groups alice    # alice : alice developers
groups bob      # bob : bob developers
groups charlie  # charlie : charlie admins

# Oder alle auf einmal
for user in alice bob charlie; do echo "$user: $(groups $user)"; done
```

</details>

---

## Aufgabe 2: Gruppenrechte konfigurieren

Konfiguriere sudo so dass:
- admins alles dürfen
- developers nur apt nutzen dürfen

<details>
<summary>Lösung anzeigen</summary>

```bash
# Admin-Regel
sudo visudo -f /etc/sudoers.d/admins

# Einfügen:
%admins ALL=(ALL:ALL) ALL

# Speichern

# Developer-Regel
sudo visudo -f /etc/sudoers.d/developers

# Einfügen:
%developers ALL=(ALL) /usr/bin/apt, /usr/bin/apt-get

# Speichern

# Testen als charlie (admin)
su - charlie
sudo whoami        # root - funktioniert!
sudo apt update    # funktioniert
exit

# Testen als alice (developer)
su - alice
sudo apt update    # funktioniert
sudo whoami        # NICHT erlaubt!
exit
```

</details>

---

## Aufgabe 3: sudo ohne Passwort

Konfiguriere, dass charlie sudo ohne Passwort nutzen kann:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Regel anpassen
sudo visudo -f /etc/sudoers.d/admins

# Ändern zu:
%admins ALL=(ALL:ALL) NOPASSWD: ALL

# Testen
su - charlie
sudo apt update
# Kein Passwort nötig!
exit
```

:::warning Sicherheitshinweis
NOPASSWD ist praktisch für automatisierte Skripte, aber ein Sicherheitsrisiko. Nur wenn wirklich nötig!
:::

</details>

---

## Aufgabe 4: Benutzer aus Gruppe entfernen

1. Entferne bob aus der developers-Gruppe
2. Prüfe die Änderung
3. Füge ihn wieder hinzu

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Aus Gruppe entfernen
sudo gpasswd -d bob developers
# Removing user bob from group developers

# 2. Prüfen
groups bob
# bob : bob (nur noch eigene Gruppe)

grep developers /etc/group
# developers:x:1002:alice (bob fehlt)

# 3. Wieder hinzufügen
sudo gpasswd -a bob developers
# Adding user bob to group developers

groups bob
# bob : bob developers
```

</details>

---

## Aufgabe 5: Primäre Gruppe ändern

1. Ändere die primäre Gruppe von alice zu developers
2. Erstelle als alice eine Datei und prüfe den Gruppenbesitz
3. Ändere zurück

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Primäre Gruppe ändern
sudo usermod -g developers alice

id alice
# uid=1001(alice) gid=1002(developers) groups=1002(developers)

# 2. Datei erstellen
su - alice
touch testfile.txt
ls -l testfile.txt
# -rw-r--r-- 1 alice developers ... testfile.txt
#                   ^^^^^^^^^^^ Gruppen-Besitz!
rm testfile.txt
exit

# 3. Zurück ändern
sudo usermod -g alice alice

id alice
# gid=1001(alice)
```

</details>

---

## Aufgabe 6: Gruppenadministrator

Mache alice zum Administrator der developers-Gruppe:

<details>
<summary>Lösung anzeigen</summary>

```bash
# alice als Gruppenadmin setzen
sudo gpasswd -A alice developers

# Prüfen
cat /etc/gshadow | grep developers
# developers:!:alice:alice,bob
#              ^^^^^ Admin

# Jetzt kann alice andere zur Gruppe hinzufügen
su - alice

# Als alice bob entfernen und hinzufügen
gpasswd -d bob developers
gpasswd -a bob developers

exit

# Admins können:
# - Mitglieder hinzufügen/entfernen
# - Gruppen-Passwort setzen (selten genutzt)
```

</details>

---

## Aufgabe 7: Effektive Gruppe wechseln

Ohne neu einzuloggen die Gruppe wechseln:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Als alice einloggen
su - alice

# Aktuelle Gruppen
groups
# alice developers

# Effektive Gruppe anzeigen
id -gn
# alice (primäre Gruppe)

# Neue Shell mit anderer effektiver Gruppe
newgrp developers

id -gn
# developers

# Datei erstellen
touch grouptest.txt
ls -l grouptest.txt
# Gruppe ist jetzt "developers"

# Zurück
exit  # Verlässt newgrp-Shell
exit  # Verlässt alice-Shell

# Aufräumen
sudo rm /home/alice/grouptest.txt
```

</details>

---

## Aufgabe 8: sudo-Log prüfen

Finde heraus, welche sudo-Befehle ausgeführt wurden:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Auth-Log durchsuchen
sudo grep sudo /var/log/auth.log | tail -20

# Nur erfolgreiche sudo-Befehle
sudo grep "COMMAND=" /var/log/auth.log | tail -10

# Nach User filtern
sudo grep "charlie.*COMMAND=" /var/log/auth.log

# Fehlgeschlagene sudo-Versuche
sudo grep "NOT_ALLOWED" /var/log/auth.log

# Alternative: journalctl
sudo journalctl | grep sudo | tail -20
```

</details>

---

## Aufgabe 9: Alle Benutzer einer Gruppe anzeigen

Verschiedene Wege, Gruppenmitglieder zu finden:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Methode 1: /etc/group direkt
grep developers /etc/group
# developers:x:1002:alice,bob

# Methode 2: getent
getent group developers

# Methode 3: Alle User durchgehen
for user in $(cut -d: -f1 /etc/passwd); do
    if groups $user 2>/dev/null | grep -q developers; then
        echo $user
    fi
done

# Methode 4: Mit lid (falls installiert)
# sudo apt install libuser
# lid -g developers
```

</details>

---

## Aufgabe 10: Aufräumen

Lösche die Test-Benutzer und -Gruppen:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Benutzer löschen (mit Home-Verzeichnissen)
sudo userdel -r alice
sudo userdel -r bob
sudo userdel -r charlie

# Gruppen löschen
sudo groupdel admins
sudo groupdel developers

# sudoers-Dateien entfernen
sudo rm /etc/sudoers.d/admins
sudo rm /etc/sudoers.d/developers

# Prüfen
grep -E "alice|bob|charlie" /etc/passwd
# Keine Ausgabe = gelöscht

grep -E "admins|developers" /etc/group
# Keine Ausgabe = gelöscht
```

</details>

---

## Bonus: Private User Groups (PUG)

Ubuntu verwendet standardmäßig "Private User Groups":

<details>
<summary>Lösung anzeigen</summary>

```bash
# Bei useradd wird automatisch eine gleichnamige Gruppe erstellt
sudo useradd -m testpug

id testpug
# uid=1001(testpug) gid=1001(testpug) groups=1001(testpug)

grep testpug /etc/group
# testpug:x:1001:

# Vorteile:
# - Jeder User hat eigene Gruppe
# - umask 002 möglich (Gruppe kann schreiben)
# - Dateien standardmäßig nur für den User

# Aufräumen
sudo userdel -r testpug
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Gruppen erstellen und verwalten
- Benutzer zu Gruppen hinzufügen/entfernen
- sudo für Gruppen konfigurieren
- Primäre Gruppe ändern
- Gruppenadministratoren festlegen
- sudo-Aktivitäten prüfen

---

Weiter geht's mit den [Dateiberechtigungen](../05_dateiberechtigungen/01_theorie.md)!
