---
title: Shell Scripting (Erweitert)
sidebar_position: 1
---

# Shell Scripting - Erweiterte Themen

:::info Nur 5-Tage-Schulung
Dieses Modul ist Teil der 5-Tage-Schulung.
:::

## Arrays

```bash
# Array definieren
fruits=("apple" "banana" "cherry")

# Zugriff
echo ${fruits[0]}     # apple
echo ${fruits[@]}     # Alle Elemente
echo ${#fruits[@]}    # Anzahl

# Iterieren
for fruit in "${fruits[@]}"; do
    echo "$fruit"
done

# Hinzufügen
fruits+=("date")
```

## Funktionen

```bash
#!/bin/bash

greet() {
    local name="$1"
    echo "Hallo, $name!"
    return 0
}

greet "Linux"

# Mit Rückgabewert
calculate() {
    local result=$(( $1 + $2 ))
    echo "$result"
}

sum=$(calculate 5 3)
echo "Summe: $sum"
```

## Error Handling

```bash
#!/bin/bash
set -e          # Bei Fehler abbrechen
set -u          # Fehler bei undefinierten Variablen
set -o pipefail # Pipe-Fehler erkennen

# trap für Cleanup
cleanup() {
    echo "Räume auf..."
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

TMPDIR=$(mktemp -d)
```

## Debugging

```bash
#!/bin/bash
set -x  # Zeigt jeden Befehl vor Ausführung

# Oder nur Abschnitte:
set -x
commands...
set +x
```

## getopts - Argumente parsen

```bash
#!/bin/bash

usage() {
    echo "Usage: $0 [-v] [-f file] [-n num] argument"
    exit 1
}

verbose=false
file=""
num=1

while getopts "vf:n:" opt; do
    case $opt in
        v) verbose=true ;;
        f) file="$OPTARG" ;;
        n) num="$OPTARG" ;;
        *) usage ;;
    esac
done

shift $((OPTIND-1))

$verbose && echo "Verbose mode"
echo "File: $file"
echo "Num: $num"
echo "Args: $@"
```
