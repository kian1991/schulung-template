---
title: "01. Async & Tokio"
---

Async in Rust ist eine andere Liga als in Node.js.
In Node.js ist die Event Loop **built-in**.
In Rust ist Async ein **Opt-in**. Die Sprache liefert nur die Primitives (`Future`), aber keine Runtime. Wir müssen eine mitbringen. Die Standard-Wahl ist **Tokio**.

## Cold Futures vs Hot Promises

Dies ist der wichtigste Unterschied:

- **JS Promise (Hot):** Sobald du `new Promise(...)` schreibst, läuft der Code los.
- **Rust Future (Cold):** Ein Future ist wie ein Plan. Es passiert **NICHTS**, solange du es nicht pollt (via `.await`).

```rust
// Rust
let future = say_hello(); // Nichts passiert! Code läuft nicht.
// future.await; // JETZT läuft es.
```

Das macht Rust extrem effizient. Futures können einfach weggeworfen werden, ohne Side Effects (meistens).

## Die Runtime: Tokio

Weil Rust keine Runtime-Schicht hat, brauchen wir **Tokio**. Es nimmt unsere Futures und führt sie auf einem Thread-Pool aus (Multi-Threaded Work Stealing Scheduler).

Setup in `Cargo.toml`:
```toml
[dependencies]
tokio = { version = "1", features = ["full"] }
```

Und so sieht `main` aus:

```rust
#[tokio::main]
async fn main() {
    println!("Start");
    let res = do_work().await;
    println!("Ergebnis: {}", res);
}

async fn do_work() -> i32 {
    // Simuliere IO Wait (non-blocking!)
    tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
    42
}
```

## Concurrency: `tokio::spawn`

In Node.js läuft alles auf einem Thread. CPU-intensive Tasks blockieren alles.
In Rust/Tokio nutzen wir `spawn`, um Tasks auf den Thread-Pool zu werfen.

```rust
#[tokio::main]
async fn main() {
    let handle = tokio::spawn(async {
        // Das hier läuft PARALLEL (potenziell auf einem anderen Core)
        "Async Work"
    });

    let out = handle.await.unwrap();
    println!("Got: {}", out);
}
```

:::warning[Send Bound]
Da Tasks zwischen Threads wandern können, müssen alle Variablen, die du in einen `spawn` Block bewegst, **Send** sein (Thread-Safe). `Rc` ist NICHT Send. Benutz `Arc`.
:::

## Channels (Daten tauschen)

Wie kommunizieren Threads? **Don't communicate by sharing memory; share memory by communicating.**
Tokio bietet MPSC (Multi-Producer, Single-Consumer) Channels.

```rust
use tokio::sync::mpsc;

#[tokio::main]
async fn main() {
    let (tx, mut rx) = mpsc::channel(32);

    tokio::spawn(async move {
        tx.send("Hallo vom Thread").await.unwrap();
    });

    while let Some(msg) = rx.recv().await {
        println!("Empfangen: {}", msg);
    }
}
```

---

## Zusammenfassung
1. **Futures sind lazy:** Sie machen nichts ohne `.await`.
2. **Tokio** ist die Runtime (Event Loop + Thread Pool).
3. **`spawn`** startet echte parallele Tasks (anders als JS Promises).
4. **`Arc` + `Mutex`** oder **Channels** zur Kommunikation.
