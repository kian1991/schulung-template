---
title: "03. Error Handling"
---

Rust hat **keine Exceptions**. Kein `try` / `catch`.
Das klingt erst mal schockierend, ist aber einer der größten Vorteile für Reliability. Fehler sind **Werte** (`Result<T, E>`), die du behandeln MUSST (oder explizit ignorieren).

## Recoverable vs. Unrecoverable Errors

In TS werfen wir Errors für alles.
In Rust unterscheiden wir strikt:

1.  **Panic!** (Unrecoverable): Code Bugs, Division by Zero, Out of Bounds. Das Programm stürzt ab.
```rust
panic!("This is messy");
```
2.  **Result** (Recoverable): Datei nicht gefunden, API down, Parse Error. Das Programm macht weiter.

## Result\<T, E\>

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Standardnutzung (via `match`):

```rust
use std::fs::File;

fn open_file() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => {
            println!("Problem opening the file: {:?}", error);
            return; // oder alternativen Pfad nehmen
        },
    };
}
```

Das ist sicher, aber sehr verbos.

## The `?` Operator (Dein Freund)

Das Fragezeichen ist wie **Propagation/Rethrow** in anderen Sprachen, aber typsicher.
Wenn ein Result `Ok` ist, gibt es den Wert zurück.
Wenn es `Err` ist, **returniert es sofort** aus der Funktion mit dem Error.

```rust
use std::fs::File;
use std::io::{self, Read};

// Beachte den Return Type!
fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();
    // Wenn open() failed, return Error sofort.
    // Wenn nicht, gib mir das File und mach weiter.
    File::open("hello.txt")?.read_to_string(&mut s)?;
    Ok(s)
}
```

Das `?` funktioniert nur in Funktionen, die `Result` zurückgeben (oder `Option`).

:::tip[TS Analogie]
Denk an `?` wie an `await`. Es "entpackt" das Result, aber wenn es fehlschlägt, bricht es ab (bubble up).
:::

## Unwrap & Expect (Die schnelle Nummer)

Manchmal bist du faul oder sicher, dass es klappt.

- `.unwrap()`: Wenn `Ok`, gib Wert. Wenn `Err`, **PANIC**.
- `.expect("msg")`: Wie unwrap, aber mit eigener Fehlermeldung beim Crash.

Nutze das nur in Prototypen oder Tests. In Production Code wollen wir Crashes vermeiden!

## Custom Errors

In großen Apps definieren wir eigene Error-Typen (oft Enums), die alle möglichen Fehler bündeln.
Das Library `thiserror` (für Libs) oder `anyhow` (für Apps) ist hier der Standard.

```rust
// Mit 'thiserror' crate (quasi Standard)
#[derive(thiserror::Error, Debug)]
pub enum MyError {
    #[error("File not found")]
    Io(#[from] std::io::Error),
    #[error("Invalid data")]
    Parse(#[from] serde_json::Error),
}
```

---

## Zusammenfassung
1. **Keine Exceptions**: Fehler sind normale Werte.
2. **`Panic!`** ist für Bugs, **`Result`** für Runtime Fehler.
3. **`?` Operator** propagiert Fehler elegant nach oben.
4. **`unwrap()`** ist gefährlich (Crash-Gefahr), **`match`** oder **`?`** ist sicher.
