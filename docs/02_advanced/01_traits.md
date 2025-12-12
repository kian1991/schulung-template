---
title: "01. Traits & Generics"
---

Hier wird Rust richtig mächtig.
In TypeScript nutzen wir Interfaces, um Verhalten zu definieren (`implements`).
In Rust nutzen wir **Traits**. Der Unterschied? Traits können **Default Implementations** haben und werden **explizit** implementiert (kein Duck Typing).

## Traits (Die Interfaces von Rust)

Ein Trait definiert *Shared Behavior*.

```rust
pub trait Summary {
    fn summarize(&self) -> String;

    // Default Implementation (optional override)
    fn reading_time(&self) -> String {
        String::from("Unbekannte Lesezeit")
    }
}
```

### Implementierung

Wir "öffnen" den Typ nicht, wir schreiben einen `impl` Block. Das ist cool, weil wir Traits für Typen implementieren können, die uns gar nicht gehören (z.B. `Display` für `Vec<T>`).

```rust
struct Article {
    title: String,
    author: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}, by {}", self.title, self.author)
    }
}
```

## Generics (Die gleiche Syntax wie TS)

Das kennst du aus TypeScript. Wir schreiben Funktionen, die mit verschiedenen Typen arbeiten.

```rust
// TypeScript: function identity<T>(arg: T): T { ... }

// Rust
fn identity<T>(arg: T) -> T {
    arg
}
```

Aber was, wenn wir *Constraints* haben? In TS: `<T extends Summary>`.
In Rust: **Trait Bounds**.

```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking News! {}", item.summarize());
}
```

Das sagt: "T kann irgendein Typ sein, ABER er muss `Summary` implementieren."

### `impl Trait` (Syntactic Sugar)

Für einfache Fälle geht auch das:

```rust
pub fn notify(item: &impl Summary) { ... }
```

### Multiple Bounds

Was, wenn wir Summary UND Display brauchen?

```rust
pub fn notify<T: Summary + Display>(item: &T) { ... }
```

Oder sauberer mit `where`:

```rust
fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{
    // ...
}
```

## Common Traits (Die du kennen musst)

Rust hat keine "Base Object Class" wie Java. Stattdessen gibt es Standard-Traits, die du oft ableiten (`derive`) kannst.

- `Debug`: Erlaubt `println!("{:?}", x)` (für Developer Output).
- `Clone`: Erlaubt `x.clone()` (Deep Copy).
- `Copy`: Erlaubt implizites Kopieren (nur für Stack-Data).
- `PartialEq` / `Eq`: Erlaubt `x == y`.

```rust
#[derive(Debug, Clone, PartialEq)]
struct User {
    id: u32,
    name: String
}
```

Das `#[derive(...)]` Macro schreibt den Implementation-Code für dich. Magie! ✨

---

## Zusammenfassung
1. **Traits** sind Interfaces.
2. **Bounds** (`T: Summary`) erzwingen Verhalten zur Compile-Zeit.
3. **Derive** generiert Standard-Code (`Debug`, `Clone`) automatisch.
