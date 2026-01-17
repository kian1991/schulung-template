---
title: "Lab: Erste Skripte"
sidebar_position: 2
---

# Lab: Erste Skripte

:::info Zeitrahmen
**Dauer:** ca. 1,5 Stunden (4-Tage) / 4,5 Stunden (5-Tage)
:::

---

## Aufgabe 1: Hallo-Skript

Schreibe ein Skript das "Hallo $USER" ausgibt:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash
echo "Hallo $USER!"
echo "Willkommen auf $(hostname)"
```

```bash
chmod +x hallo.sh
./hallo.sh
```

</details>

---

## Aufgabe 2: Datei-Prüfung

Schreibe ein Skript das prüft ob eine Datei existiert:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <datei>"
    exit 1
fi

if [ -e "$1" ]; then
    if [ -f "$1" ]; then
        echo "$1 ist eine Datei"
    elif [ -d "$1" ]; then
        echo "$1 ist ein Verzeichnis"
    fi
else
    echo "$1 existiert nicht"
fi
```

</details>

---

## Aufgabe 3: Log-Dateien auflisten

Liste alle .log Dateien in /var/log auf:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

echo "Log-Dateien in /var/log:"
echo "========================"

count=0
for file in /var/log/*.log; do
    if [ -f "$file" ]; then
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "$file ($size)"
        ((count++))
    fi
done

echo "========================"
echo "Gefunden: $count Dateien"
```

</details>

---

## Aufgabe 4: Disk-Space-Warnung

Schreibe ein Skript das warnt wenn Disk-Usage > 80%:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

threshold=80

df -h | grep -vE '^Filesystem|tmpfs' | while read line; do
    usage=$(echo "$line" | awk '{print $5}' | tr -d '%')
    mount=$(echo "$line" | awk '{print $6}')
    
    if [ "$usage" -gt "$threshold" ]; then
        echo "WARNUNG: $mount ist zu ${usage}% voll!"
    fi
done
```

</details>

---

## Aufgabe 5: Einfaches Backup

Erstelle ein Backup-Skript für ein Verzeichnis:

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

# Konfiguration
SOURCE="${1:-$HOME}"
BACKUP_DIR="/tmp/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${DATE}.tar.gz"

# Backup-Verzeichnis erstellen
mkdir -p "$BACKUP_DIR"

# Backup erstellen
echo "Erstelle Backup von $SOURCE..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" "$SOURCE" 2>/dev/null

if [ $? -eq 0 ]; then
    size=$(ls -lh "$BACKUP_DIR/$BACKUP_NAME" | awk '{print $5}')
    echo "Backup erstellt: $BACKUP_DIR/$BACKUP_NAME ($size)"
else
    echo "Fehler beim Backup!"
    exit 1
fi
```

</details>

---

## 5-Tage Zusatz-Aufgaben

Die folgenden Aufgaben sind für die 5-Tage-Schulung:

### Aufgabe 6: Kommandozeilen-Argumente (getopts)

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

usage() {
    echo "Usage: $0 [-v] [-o output] input"
    exit 1
}

verbose=false
output=""

while getopts "vo:" opt; do
    case $opt in
        v) verbose=true ;;
        o) output="$OPTARG" ;;
        *) usage ;;
    esac
done

shift $((OPTIND-1))
input="$1"

[ -z "$input" ] && usage

$verbose && echo "Verarbeite: $input"
[ -n "$output" ] && echo "Ausgabe: $output"
```

</details>

---

### Aufgabe 7: User aus CSV anlegen

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash
# users.csv: username,fullname,group

[ ! -f "$1" ] && { echo "Usage: $0 users.csv"; exit 1; }

while IFS=, read -r username fullname group; do
    # Header überspringen
    [ "$username" = "username" ] && continue
    
    echo "Erstelle User: $username"
    sudo useradd -m -c "$fullname" -G "$group" "$username" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "  OK: $username erstellt"
    else
        echo "  SKIP: $username existiert bereits"
    fi
done < "$1"
```

</details>

---

### Aufgabe 8: System-Health-Check

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

echo "=== System Health Report ==="
echo "Datum: $(date)"
echo ""

# CPU Load
echo "--- CPU Load ---"
uptime | awk -F'load average:' '{print $2}'

# Memory
echo ""
echo "--- Memory ---"
free -h | grep Mem

# Disk
echo ""
echo "--- Disk (>70%) ---"
df -h | awk '$5+0 > 70 {print $6": "$5}'

# Top Processes
echo ""
echo "--- Top 5 CPU Prozesse ---"
ps aux --sort=-%cpu | head -6

# Services
echo ""
echo "--- Failed Services ---"
systemctl --failed --no-pager
```

</details>

---

### Aufgabe 9: Interaktives Menü

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

show_menu() {
    clear
    echo "=== Admin Menu ==="
    echo "1) Disk Space anzeigen"
    echo "2) Top Prozesse"
    echo "3) Service Status prüfen"
    echo "4) Beenden"
    echo ""
}

while true; do
    show_menu
    read -p "Wahl: " choice
    
    case $choice in
        1) df -h; read -p "Enter..." ;;
        2) top -bn1 | head -15; read -p "Enter..." ;;
        3) read -p "Service: " svc
           systemctl status "$svc" --no-pager
           read -p "Enter..." ;;
        4) echo "Bye!"; exit 0 ;;
        *) echo "Ungültige Wahl" ;;
    esac
done
```

</details>

---

### Aufgabe 10: Error-Handling mit trap

<details>
<summary>Lösung anzeigen</summary>

```bash
#!/bin/bash

# Temporäres Verzeichnis
TMPDIR=$(mktemp -d)

# Cleanup bei Exit
cleanup() {
    echo "Räume auf: $TMPDIR"
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

# Bei Fehler abbrechen
set -e

echo "Arbeite in $TMPDIR"
cd "$TMPDIR"

# Simuliere Arbeit
touch file1 file2 file3
ls -la

# Fehler simulieren (auskommentieren zum Testen)
# false

echo "Fertig!"
# cleanup wird automatisch aufgerufen
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- Skripte erstellen und ausführen
- Variablen und Benutzereingaben
- Bedingungen und Schleifen
- Dateien und Verzeichnisse prüfen
- Praktische Admin-Skripte

---

Weiter zu [Monitoring und Logging](../11_monitoring_logging/01_theorie.md)!
