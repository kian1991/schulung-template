---
title: "Lab 2: The Log Parser"
---

Wir bauen ein CLI Tool, das Logfiles analysiert.
Es soll robust sein: Dateifehler abfangen, Parsingfehler melden (aber nicht crashen).

## Das Format

Das Logfile sieht so aus:
```text
INFO: Server started
ERROR: Database connection failed
WARN: High memory usage
INFO: Request processed
CRITICAL: System meltdown
```

## Aufgabe

1. Lese die Datei `app.log` (erstell dir eine Dummy Datei).
2. Filtere nach einem Level (z.B. nur "ERROR").
3. Implementiere ein `enum LogLevel`.
4. Implementiere `FromStr` Trait für `LogLevel` (Parsing "ERROR" -> `LogLevel::Error`).

## Requirements

- Nutze `std::fs::read_to_string` oder `BufReader`.
- Nutze `Result` für das Parsing.
- Wenn eine Zeile kaputt ist, soll das Programm eine Warnung ausgeben, aber weiter machen!

## Starter Code

```rust
use std::fs;
use std::str::FromStr;

enum LogLevel {
    Info,
    Warning,
    Error,
}

// Damit wir `parse()` nutzen können!
impl FromStr for LogLevel {
    type Err = (); // Oder besserer Error Type

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "INFO" => Ok(LogLevel::Info),
            "WARN" => Ok(LogLevel::Warning),
            "ERROR" => Ok(LogLevel::Error),
            _ => Err(()),
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string("app.log")?;

    for line in content.lines() {
        // Parse die Zeile
        // Pattern: "LEVEL: Message"
        // Nutze .split_once(": ")
    }

    Ok(())
}
```

## Bonus

Mach den Pfad und den Filter via CLI Arguments konfigurierbar (`std::env::args`).
Beispiel: `cargo run app.log ERROR`
