---
title: "Drill: Axum Handlers"
---

Lerne die Magie der Axum Extractors kennen.

## Drill 1: The Echo

Erstelle einen Handler, der einen JSON Body empfängt und ihn einfach zurückgibt (Echo).
Challenge: Modifiziere ein Feld im JSON, bevor du es zurückgibst.

```rust
use axum::{Json, response::IntoResponse};
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
struct Message {
    content: String,
    // füge ein Feld 'processed: bool' hinzu (optional im input?)
}

// FIX SIGNATURE
async fn echo_handler(???) -> ??? {
    // ...
}
```

## Drill 2: Path Params

Erstelle einen Route `/math/add/:a/:b`.
Der Handler soll `a + b` als String zurückgeben.
Achte auf die Typen! Was passiert, wenn ich `/math/add/foo/5` aufrufe? (Axum macht das automatisch für dich!)

```rust
// Nutze axum::extract::Path
async fn add_handler(...) -> String {
    format!("{}", a + b)
}
```

## Drill 3: State Injection

Wir haben einen `AtomicU64` Counter im State.
Baue einen Handler, der den Counter inkrementiert und den neuen Wert zurückgibt.

```rust
use std::sync::{Arc, atomic::{AtomicU64, Ordering}};
use axum::extract::State;

struct AppState {
    counter: AtomicU64,
}

// ... Router Setup mit .with_state(...) ...

async fn count_handler(State(state): State<Arc<AppState>>) -> String {
    // benutze state.counter.fetch_add(...)
}
```
