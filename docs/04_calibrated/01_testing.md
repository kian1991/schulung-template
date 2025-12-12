---
title: "01. Testing"
---

In JS brauchen wir externe Runner (Jest, Vitest).
In Rust ist alles eingebaut: `cargo test`.
Tests sind "First Class Citizens".

## Unit Tests

Sie leben **in der gleichen Datei** wie der Code (oft in einem `mod tests`).
Vorteil: Sie können private Funktionen testen.

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*; // Importiere parent scope

    #[test]
    fn it_works() {
        assert_eq!(add(2, 2), 4);
    }
    
    #[test]
    fn it_fails() {
        // assert_ne!(add(2, 2), 5);
    }
}
```

Ausführen: `cargo test`

## Integration Tests

Sie leben im Ordner `tests/` (neben `src`).
Sie behandeln deine Crate wie eine Black Box (nur Public API).

```rust
// tests/integration_test.rs
use my_project;

#[test]
fn test_public_api() {
    assert_eq!(my_project::some_public_fn(), 42);
}
```

## Doc Tests (The Coolest Feature)

Du schreibst Doku in Markdown-Kommentaren (`///`).
Der Code in den Code-Blöcken wird **ausgeführt und getestet**!

```rust
/// Adds two numbers.
///
/// # Examples
///
/// ```
/// let result = my_crate::add(2, 2);
/// assert_eq!(result, 4);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

Nie wieder veraltete Beispiele in der Doku! `cargo test` prüft auch das.

## Test Utilities

- **`assert_eq!(left, right)`**: Prüft Gleichheit.
- **`#[should_panic]`**: Test besteht nur, wenn der Code crasht.
- **`#[ignore]`**: Test überspringen (z.B. langer DB Test). `cargo test -- --ignored` führt ihn aus.

---

## Zusammenfassung
1. **Unit Tests** im Code (`mod tests`).
2. **Integration Tests** in `tests/`.
3. **Doc Tests** in `///` Kommentaren.
4. **`cargo test`** führt alles aus.
