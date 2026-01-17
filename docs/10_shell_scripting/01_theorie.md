---
title: Shell Scripting Grundlagen
sidebar_position: 1
---

# Shell Scripting

## Was sind Shell-Skripte?

Ein Shell-Skript ist eine Textdatei mit einer Abfolge von Befehlen. Statt Befehle manuell einzugeben, werden sie automatisch ausgeführt.

## Erstes Skript

```bash
#!/bin/bash
# Mein erstes Skript

echo "Hallo $USER!"
echo "Heute ist $(date +%A)"
```

### Shebang

Die erste Zeile `#!/bin/bash` heißt **Shebang**:
- `#!` = Shebang-Zeichen
- `/bin/bash` = Interpreter

### Ausführbar machen

```bash
chmod +x script.sh
./script.sh
```

## Variablen

```bash
# Zuweisung (KEIN Leerzeichen um =)
name="Linux"
version=24

# Verwendung
echo "Willkommen zu $name Version $version"
echo "Oder mit Klammern: ${name}"

# Umgebungsvariablen
echo "Home: $HOME"
echo "User: $USER"
echo "PWD: $PWD"

# Befehlsausgabe speichern
datum=$(date +%Y-%m-%d)
files=$(ls | wc -l)
```

## Benutzereingaben

```bash
# Eingabe einlesen
echo -n "Dein Name: "
read name
echo "Hallo $name!"

# Mit Prompt
read -p "Alter: " alter

# Stille Eingabe (Passwort)
read -sp "Passwort: " password
```

## Bedingungen (if)

```bash
#!/bin/bash

if [ "$1" = "start" ]; then
    echo "Starte..."
elif [ "$1" = "stop" ]; then
    echo "Stoppe..."
else
    echo "Usage: $0 {start|stop}"
fi
```

### Test-Operatoren

**Strings:**
| Operator | Bedeutung |
|----------|-----------|
| `=` oder `==` | Gleich |
| `!=` | Ungleich |
| `-z` | Leer |
| `-n` | Nicht leer |

**Zahlen:**
| Operator | Bedeutung |
|----------|-----------|
| `-eq` | Gleich |
| `-ne` | Ungleich |
| `-lt` | Kleiner |
| `-le` | Kleiner oder gleich |
| `-gt` | Größer |
| `-ge` | Größer oder gleich |

**Dateien:**
| Operator | Bedeutung |
|----------|-----------|
| `-e` | Existiert |
| `-f` | Ist Datei |
| `-d` | Ist Verzeichnis |
| `-r` | Lesbar |
| `-w` | Schreibbar |
| `-x` | Ausführbar |

```bash
# Beispiele
if [ -f "/etc/passwd" ]; then
    echo "Datei existiert"
fi

if [ "$count" -gt 10 ]; then
    echo "Mehr als 10"
fi

if [ -z "$var" ]; then
    echo "Variable ist leer"
fi
```

## Schleifen

### for-Schleife

```bash
# Liste durchgehen
for name in Alice Bob Charlie; do
    echo "Hallo $name"
done

# Dateien durchgehen
for file in *.txt; do
    echo "Verarbeite: $file"
done

# Zahlenbereich
for i in {1..5}; do
    echo "Zahl: $i"
done

# C-Style
for ((i=0; i<5; i++)); do
    echo "Index: $i"
done
```

### while-Schleife

```bash
count=0
while [ $count -lt 5 ]; do
    echo "Count: $count"
    ((count++))
done

# Datei zeilenweise lesen
while read line; do
    echo "Zeile: $line"
done < datei.txt
```

## Kommandozeilen-Argumente

```bash
#!/bin/bash

echo "Skriptname: $0"
echo "Erstes Argument: $1"
echo "Zweites Argument: $2"
echo "Alle Argumente: $@"
echo "Anzahl Argumente: $#"
```

## Exit-Codes

```bash
# Erfolg
exit 0

# Fehler
exit 1

# Letzten Exit-Code prüfen
command
if [ $? -eq 0 ]; then
    echo "Erfolg"
else
    echo "Fehler"
fi

# Kurzform
command && echo "OK" || echo "Fehler"
```

## Praktische Beispiele

### Backup-Skript (einfach)

```bash
#!/bin/bash
backup_dir="/backup"
source_dir="/home"
date=$(date +%Y%m%d)

tar -czf "$backup_dir/home_$date.tar.gz" "$source_dir"
echo "Backup erstellt: home_$date.tar.gz"
```

### Disk-Space-Check

```bash
#!/bin/bash
threshold=80
usage=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ $usage -gt $threshold ]; then
    echo "WARNUNG: Festplatte zu ${usage}% voll!"
fi
```

---

Weiter zum [Lab: Erste Skripte](./02_lab_basics.md)!

:::info 5-Tage-Schulung
Für die erweiterte Shell-Scripting-Theorie siehe das Erweiterungsmodul "Shell Advanced" (nur 5-Tage-Schulung).
:::
