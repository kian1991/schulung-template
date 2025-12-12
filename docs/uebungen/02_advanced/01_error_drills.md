---
title: "Drill: Error Handling"
---

Errors sind Freunde, kein Futter.

## Drill 1: The Panic

Dieser Code stürzt ab, wenn die Zahl ungerade ist. Ändere ihn so, dass er ein `Result` zurückgibt und der Main-Code den Fehler behandelt (statt Crash).

```rust
fn get_even_number(n: i32) -> i32 {
    if n % 2 != 0 {
        panic!("Not even!");
    }
    n
}

fn main() {
    let n = get_even_number(5); // CRASH!
    println!("Got: {}", n);
}
```

## Drill 2: The Question Mark

Wir wollen `?` nutzen, aber die Funktionssignatur erlaubt es nicht. Fixe den Return Type.

```rust
use std::num::ParseIntError;

fn multiply(s1: &str, s2: &str) -> i32 { // FIX ME
    let n1 = s1.parse::<i32>()?;
    let n2 = s2.parse::<i32>()?;
    Ok(n1 * n2)
}

fn main() {
    match multiply("10", "2") {
        Ok(n) => println!("Result: {}", n),
        Err(e) => println!("Error: {}", e),
    }
}
```

## Drill 3: Option Handling

Hier ist ein `Option`, aber wir behandeln es wie einen garantieren Wert. Mache es sicher (ohne `unwrap`).

```rust
fn find_user(id: i32) -> Option<String> {
    if id == 1 {
        Some("Alice".to_string())
    } else {
        None
    }
}

fn main() {
    let user = find_user(99).unwrap(); // BÖSE!
    println!("Found user: {}", user);
}
```
