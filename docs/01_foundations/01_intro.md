---
title: "01. Intro & Toolchain"
---

Willkommen in der Rust-Welt. Bevor wir Code schreiben, müssen wir das Ecosystem verstehen. Wenn du von TypeScript kommst, wirst du dich sehr schnell zu Hause fühlen, die Tools sind nur etwas... strikter.

## The Mental Shift

| TypeScript / Node | Rust |
| :--- | :--- |
| **Runtime** (V8 / Node) | **Binary** (Machine Code) |
| **npm / yarn / pnpm** | **Cargo** |
| **package.json** | **Cargo.toml** |
| **node_modules** | **target/** |
| **tsc (Transpiler)** | **rustc (Compiler)** |
| **ESLint / Prettier** | **cargo clippy / cargo fmt** |

:::info[Der Compiler ist dein Freund]
In TypeScript ist der Compiler oft "best effort". In Rust ist er der Gatekeeper. Wenn es kompiliert, läuft es meistens auch (ohne Runtime-Errors). Das nennt man *Memory Safety without Garbage Collection*.
:::

## 1. Setup Check

Wir haben `rustup` installiert. Das ist dein Version Manager (wie `nvm`).

```bash
# Update
rustup update

# Check Version
cargo --version
```

## 2. Cargo: Dein neuer bester Freund

`Cargo` ist Build-System, Package Manager, Test Runner und Doc Generator in einem.

### Neues Projekt erstellen
```bash
cargo new mein-projekt
cd mein-projekt
```

Das generiert:
```
mein-projekt/
├── Cargo.toml      # package.json
├── src/
│   └── main.rs     # index.ts
└── .gitignore      # Ignoriert /target
```

### Build & Run

- **`cargo run`**: Kompiliert und führt aus (Dev Mode). Langsam beim ersten Mal, danach inkrementell.
- **`cargo build`**: Nur kompilieren.
- **`cargo check`**: **WICHTIG!** Kompiliert nicht fertig, prüft nur Typen. Viel schneller. Nutze das während du codest ständig.
- **`cargo build --release`**: Maximale Optimierung. Dauert länger, Binary wird winzig und extrem schnell.

:::tip[Cargo Watch]
Installiere `cargo-watch` (ähnlich `nodemon`):
`cargo install cargo-watch`
Dann: `cargo watch -x run` – startet bei jeder Dateiänderung neu.
:::

## 3. Hello World & die Main-Funktion

Öffne `src/main.rs`:

```rust
fn main() {
    println!("Hello, world!");
}
```

Drei Dinge fallen sofort auf:
1. `fn`: Keyword für Functions.
2. `main()`: Einstiegspunkt (wie in C/Java, anders als in JS-Scripts).
3. `println!`: Das `!` am Ende bedeutet **Macro**.
    - Funktionen in Rust haben eine feste Argument-Anzahl (keine Variadic args wie `console.log(...)`).
    - Macros generieren Code zur Compile-Zeit und erlauben variadische Argumente.

### "Variables" sind anders

```rust
fn main() {
    let x = 5;
    // x = 6; // FEHLER!
    println!("x ist: {}", x);
}
```

In Rust sind Variablen **immutable by default**. Das ist wie `const` in JS, aber strikter.
Wenn du Mutation willst, musst du es explizit machen:

```rust
let mut y = 10; // "mut" = mutable
y = 11;
```

:::warning[Mental Model]
In JS nutzen wir `const` für Arrays/Objekte, können aber deren Inhalt ändern.
In Rust friert `let` (ohne `mut`) **alles** ein, auch den Inhalt.
:::

## 4. Dependencies hinzufügen

Öffne `Cargo.toml`.

```toml
[dependencies]
serde = "1.0"  # JSON Serializer (der Standard)
```

Dann `cargo build`. Cargo lädt alles aus `crates.io` (der npm Registry).
Es gibt eine `Cargo.lock` (wie `package-lock.json`), um Versionen zu pinnen.

---

## Zusammenfassung
1. **Cargo** ersetzt npm/node CLI.
2. **`cargo check`** ist dein Loop für schnelles Feedback.
3. Variablen sind **Immutable** by default.
4. Wir nutzen **Macros** (`!`), um flexiblen Code zu generieren.
