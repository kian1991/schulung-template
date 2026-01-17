---
title: "Lab: Prozesse steuern"
sidebar_position: 3
---

# Lab: Prozesse steuern

:::info Zeitrahmen
**Dauer:** ca. 1,25 Stunden
:::

In diesem Lab lernst du, Prozesse zu starten, stoppen, in den Hintergrund zu schicken und mit Signalen zu steuern.

---

## Aufgabe 1: Job Control

1. Starte `sleep 300` im Vordergrund
2. Stoppe den Prozess mit Ctrl+Z
3. Zeige alle Jobs an
4. Setze den Job im Hintergrund fort
5. Hole ihn wieder in den Vordergrund
6. Beende ihn mit Ctrl+C

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Im Vordergrund starten
sleep 300
# Terminal ist blockiert

# 2. Stoppen
# Drücke Ctrl+Z
# Ausgabe: [1]+  Stopped                 sleep 300

# 3. Jobs anzeigen
jobs
# [1]+  Stopped                 sleep 300

jobs -l   # Mit PID

# 4. Im Hintergrund fortsetzen
bg
# oder
bg %1

jobs
# [1]+  Running                 sleep 300 &

# 5. In Vordergrund holen
fg
# oder
fg %1

# 6. Beenden
# Ctrl+C
```

</details>

---

## Aufgabe 2: Mehrere Hintergrund-Jobs

1. Starte drei verschiedene sleep-Befehle im Hintergrund (100, 200, 300 Sekunden)
2. Liste alle Jobs auf
3. Beende nur den mittleren (sleep 200)
4. Beende alle verbleibenden

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Mehrere Jobs starten
sleep 100 &
sleep 200 &
sleep 300 &

# 2. Jobs auflisten
jobs
# [1]   Running                 sleep 100 &
# [2]-  Running                 sleep 200 &
# [3]+  Running                 sleep 300 &

# 3. Mittleren beenden
kill %2
# oder nach PID:
kill $(pgrep -f "sleep 200")

jobs
# [1]   Running                 sleep 100 &
# [2]-  Terminated              sleep 200
# [3]+  Running                 sleep 300 &

# 4. Alle beenden
kill %1 %3
# oder
pkill sleep
```

</details>

---

## Aufgabe 3: Signale senden

1. Starte ein Skript das endlos läuft
2. Sende SIGTERM an das Skript
3. Starte es erneut und sende SIGKILL

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Endlos-Skript erstellen
cat << 'EOF' > ~/endless.sh
#!/bin/bash
echo "PID: $$"
while true; do
    echo "$(date): Still running..."
    sleep 5
done
EOF
chmod +x ~/endless.sh

# In Hintergrund starten
~/endless.sh &
# Notiere die PID aus der Ausgabe

# 2. SIGTERM senden
kill PID
# oder
kill -15 PID
# oder
kill -SIGTERM PID

# Das Skript sollte beendet werden
# (bash reagiert standardmäßig auf SIGTERM)

# 3. Neu starten
~/endless.sh &

# SIGKILL senden (brutal!)
kill -9 PID
# oder
kill -SIGKILL PID

# Immer beendet - kann nicht abgefangen werden!
```

</details>

---

## Aufgabe 4: SIGHUP - Konfiguration neu laden

SIGHUP wird oft verwendet, um Dienste ihre Konfiguration neu laden zu lassen.

1. Installiere und starte nginx (falls nicht vorhanden)
2. Zeige die nginx-Prozesse
3. Sende SIGHUP an den Master-Prozess
4. Prüfe ob neue Worker gestartet wurden

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. nginx installieren/starten
sudo apt install nginx
sudo systemctl start nginx

# 2. Prozesse anzeigen
ps aux | grep nginx
# Master-Prozess (root) und Worker (www-data)

# PID des Masters finden
MASTER_PID=$(pgrep -o nginx)
echo "Master PID: $MASTER_PID"

# 3. SIGHUP senden (graceful reload)
sudo kill -HUP $MASTER_PID
# oder
sudo kill -1 $MASTER_PID

# 4. Prüfen
ps aux | grep nginx
# Worker haben neue PIDs!

# Besser: systemctl nutzen
sudo systemctl reload nginx
# Macht intern das Gleiche
```

</details>

---

## Aufgabe 5: Mit pkill und killall arbeiten

1. Starte drei sleep-Prozesse (verschiedene Zeiten)
2. Beende alle mit `pkill`
3. Starte sie erneut
4. Beende alle mit `killall`

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Mehrere sleep-Prozesse
sleep 100 &
sleep 200 &
sleep 300 &

# 2. Mit pkill beenden
pkill sleep
# Beendet alle Prozesse die "sleep" heißen

jobs  # Sollte leer sein

# 3. Neu starten
sleep 100 &
sleep 200 &
sleep 300 &

# 4. Mit killall beenden
killall sleep

# Unterschied:
# pkill  - Pattern-Matching (kann Teil des Namens sein)
# killall - Exakter Name

# Beispiel:
# pkill fire      # Findet "firefox", "firewalld", etc.
# killall firefox # Nur exakt "firefox"
```

</details>

---

## Aufgabe 6: Prozess-Priorität ändern

1. Starte einen Prozess mit niedriger Priorität (nice 15)
2. Prüfe seine Priorität
3. Ändere die Priorität auf nice 10
4. Versuche als root eine negative Priorität zu setzen

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Mit nice starten
nice -n 15 sleep 1000 &

# 2. Priorität prüfen
ps -l | grep sleep
# NI-Spalte zeigt 15

# Oder:
PID=$(pgrep -n sleep)
ps -o pid,ni,cmd -p $PID

# 3. Priorität ändern
renice 10 -p $PID
# Ausgabe: $PID (process ID) old priority 15, new priority 10

ps -o pid,ni,cmd -p $PID

# 4. Negative Priorität (braucht root)
sudo renice -5 -p $PID
# Ausgabe: new priority -5

# Als normaler User geht das nicht:
renice -10 -p $PID
# renice: failed to set priority for $PID (process ID): Permission denied

# Aufräumen
kill $PID
```

</details>

---

## Aufgabe 7: Zombie-Prozess verstehen

Erstelle einen "Zombie" und verstehe was passiert:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Skript das einen Zombie erzeugt
cat << 'EOF' > ~/make_zombie.sh
#!/bin/bash
# Dieses Skript erzeugt einen Zombie
# Der Kindprozess beendet sich, aber wir warten nicht auf ihn

# Kind starten, das sich sofort beendet
( exit 0 ) &
CHILD_PID=$!

echo "Child PID: $CHILD_PID"
echo "Sleeping 30 seconds (Child is zombie)..."
echo "In anderem Terminal: ps aux | grep defunct"

sleep 30

# Jetzt erst auf Kind warten (räumt Zombie auf)
wait $CHILD_PID
echo "Zombie cleaned up"
EOF
chmod +x ~/make_zombie.sh

# In Terminal 1:
~/make_zombie.sh

# In Terminal 2 (während die 30 Sek. laufen):
ps aux | grep defunct
# Zeigt den Zombie mit Status Z

# Nach wait() verschwindet der Zombie
```

**Was ist ein Zombie?**
- Kindprozess ist beendet
- Elternprozess hat Exit-Status nicht abgeholt (`wait()`)
- Kernel muss Exit-Status aufbewahren
- Zombie verbraucht keine Ressourcen, nur PID-Tabelleneintrag

</details>

---

## Aufgabe 8: nohup - Prozess überlebt Logout

1. Starte einen Prozess mit `nohup`
2. Logge dich aus und wieder ein
3. Prüfe ob der Prozess noch läuft

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Prozess mit nohup starten
nohup sleep 600 &
# Ausgabe: nohup: ignoring input and appending output to 'nohup.out'

# Die PID merken oder notieren
pgrep -a sleep

# 2. Ausloggen
exit

# Wieder einloggen (SSH)
ssh student@localhost -p 2222

# 3. Prüfen
pgrep -a sleep
# Der Prozess läuft noch!

ps aux | grep sleep

# Ausgabe-Datei anschauen
cat ~/nohup.out

# Aufräumen
pkill sleep
rm ~/nohup.out
```

**Wann nohup nutzen?**
- Lange laufende Jobs über SSH
- Alternative: `screen` oder `tmux` (besser!)

</details>

---

## Aufgabe 9: Prozess-Limits anzeigen

1. Zeige die Ressourcen-Limits für deine Shell
2. Was ist das Maximum an offenen Dateien?
3. Was ist die maximale Prozessanzahl?

<details>
<summary>Lösung anzeigen</summary>

```bash
# 1. Alle Limits anzeigen
ulimit -a

# 2. Offene Dateien
ulimit -n
# Soft-Limit

ulimit -Hn
# Hard-Limit (Maximum)

# 3. Maximale Prozesse
ulimit -u

# Für einen bestimmten Prozess:
PID=$$  # Eigene Shell
cat /proc/$PID/limits

# System-weite Limits
cat /etc/security/limits.conf
```

</details>

---

## Aufgabe 10: Signale abfangen (für Skripte)

Schreibe ein Skript das SIGINT und SIGTERM abfängt:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Skript erstellen
cat << 'EOF' > ~/signal_test.sh
#!/bin/bash

# Signal-Handler definieren
cleanup() {
    echo ""
    echo "Signal empfangen! Räume auf..."
    echo "Tschüss!"
    exit 0
}

# Signale abfangen
trap cleanup SIGINT SIGTERM

echo "PID: $$"
echo "Drücke Ctrl+C oder sende SIGTERM um zu beenden"
echo "Zum brutalen Beenden: kill -9 $$"
echo ""

counter=0
while true; do
    echo "Läuft seit $counter Sekunden..."
    ((counter++))
    sleep 1
done
EOF
chmod +x ~/signal_test.sh

# Testen
~/signal_test.sh

# Ctrl+C drücken
# → "Signal empfangen! Räume auf..."

# Oder in anderem Terminal:
# kill PID
# → Gleiche Ausgabe

# Nur kill -9 übergeht den Handler!
```

</details>

---

## Bonus: Alle Prozesse eines Users beenden

:::warning Vorsicht!
Nur auf Test-Systemen ausprobieren!
:::

<details>
<summary>Lösung anzeigen</summary>

```bash
# Alle Prozesse von User "testuser" beenden
pkill -u testuser

# Oder mit killall
killall -u testuser

# Als root: Bestimmten User ausloggen
sudo pkill -KILL -u testuser

# Eigene Session NICHT beenden:
# Besser: Nur bestimmte Prozesse
pgrep -u student | grep -v $$ | xargs kill
```

</details>

---

## Zusammenfassung

Du hast gelernt:

- Jobs zwischen Vorder- und Hintergrund wechseln
- Signale an Prozesse senden (SIGTERM, SIGKILL, SIGHUP)
- Mit `pkill` und `killall` mehrere Prozesse beenden
- Prozess-Prioritäten mit `nice` und `renice` ändern
- Was Zombie-Prozesse sind
- Prozesse mit `nohup` am Leben halten
- Signale in Skripten abfangen mit `trap`

---

Weiter geht's mit der [Benutzerverwaltung](../04_benutzerverwaltung/01_theorie.md)!
