---
title: "03. Types: Structs & Enums"
---

In TypeScript bauen wir Typen mit Interfaces und Types. In Rust nutzen wir **Structs** für Produkttypen ("UND"-Verknüpfung) und **Enums** für Summentypen ("ODER"-Verknüpfung).

## Structs (Objekte)

Ein `struct` ist das, was du in TS als Interface für ein Objekt kennst.

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}

// Instanziierung
let user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};
```

### Methods (`impl`)

In TS schreiben wir Klassen. In Rust trennen wir Daten (`struct`) vom Verhalten (`impl`).

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    // Methoden nehmen &self (Instanz)
    fn area(&self) -> u32 {
        self.width * self.height
    }

    // Associated Functions (Static inputs, wie new)
    fn new(width: u32, height: u32) -> Self {
        Self { width, height }
    }
}
```

## Enums: Die Superpower

**Achtung:** Rust Enums sind NICHT wie TS Enums (die eigentlich nur glorifizierte Maps sind).
Rust Enums sind **Algebraic Data Types** (ADI). Das ist exakt wie **Discriminated Unions** in TypeScript, aber nativ.

### TS Analogie

```typescript
// TypeScript
type Message = 
  | { kind: "Quit" }
  | { kind: "Move", x: number, y: number }
  | { kind: "Write", content: string };
```

### Rust Reality

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 }, // Jede Variante kann Daten halten!
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

## Pattern Matching (`match`)

Hier glänzt Rust. `match` ist wie `switch`, aber es **zwingt** dich, alle Fälle zu behandeln (Exhaustiveness Check).

```rust
fn process(msg: Message) {
    match msg {
        Message::Quit => {
            println!("Bye!");
        }
        Message::Move { x, y } => {
            println!("Move to {}/{}", x, y);
        }
        Message::Write(text) => {
            println!("Text: {}", text);
        }
        // Ohne diesen Fall würde der Compiler FEHLERN!
        Message::ChangeColor(r, g, b) => {
            println!("RGB: {}, {}, {}", r, g, b);
        }
    }
}
```

:::tip[Destructuring]
Genau wie in JS kannst du Daten direkt im Pattern extrahieren (`{ x, y }` oder `(text)`).
:::

## Option & Result (Der Billion Dollar Mistake Fix)

Rust hat kein `null` oder `undefined`. Stattdessen gibt es zwei Standard-Enums:

### 1. `Option<T>` (Nullable)
Statt `T | null`:

```rust
enum Option<T> {
    Some(T),
    None,
}

let some_number = Some(5);
let absent_number: Option<i32> = None;
```

Du MUSST checken, ob es `Some` oder `None` ist, bevor du an den Wert kommst. Keine `undefined is not a function` Errors mehr!

### 2. `Result<T, E>` (Error Handling)
Statt Exceptions (`try/catch`):

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Funktionen, die fehlschlagen können, geben ein `Result` zurück. Du musst den Fehler explizit behandeln.

---

## Zusammenfassung
1. **Structs**: Halten Daten zusammen.
2. **impl Blocks**: Definieren Verhalten für Structs.
3. **Enums**: Können Daten halten (Discriminated Unions).
4. **match**: Zwingt dich, alle Enum-Varianten zu behandeln.
5. **Kein NULL**: `Option` zwingt dich zum Safety-Check.
