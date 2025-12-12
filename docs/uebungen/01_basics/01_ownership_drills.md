---
title: "Drill: Fight the Borrow Checker"
---

Hier sind kleine Snippets, die **nicht kompilieren**. Deine Aufgabe: Mach, dass sie laufen, ohne die Logik komplett zu ändern.

## Drill 1: The Move

:::warning[Fehler]
"use of moved value"
:::

```rust
fn main() {
    let s1 = String::from("Hello");
    let s2 = s1;
    
    // FIX ME: Warum geht das nicht?
    println!("s1: {}, s2: {}", s1, s2);
}
```

<details>
<summary>Lösungshinweis</summary>
`s1` wurde in `s2` gemoved. Entweder `s1.clone()` nutzen (teuer) oder Reference `&s1` zuweisen (billig, aber s2 ist dann nur ein Borrow).
</details>

## Drill 2: Mutable Madness

:::warning[Fehler]
"cannot borrow `x` as mutable more than once at a time"
:::

```rust
fn main() {
    let mut x = 10;
    let y = &mut x;
    let z = &mut x; // FEHLER!

    *y += 1;
    *z += 1;
    
    println!("{}", x);
}
```

<details>
<summary>Lösungshinweis</summary>
Scopes! Du kannst `y` benutzen und beenden, bevor du `z` erstellst. Oder brauchst du wirklich zwei mutable References gleichzeitig? (Unmöglich in Rust).
</details>

## Drill 3: The Slice

Wir wollen das erste Wort zurückgeben, aber der Compiler meckert über Lifetimes (oder Ownership).

```rust
fn main() {
    let s = String::from("Hello World");
    let word = first_word(&s);
    // s.clear(); // Wenn du das einkommentierst, sollte es krachen!
    println!("First word: {}", word);
}

fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}
```

**Aufgabe:** Versuch mal `s` zu verändern (`s.clear()`), während `word` noch benutzt wird. Verstehe, warum Rust das verbietet.
