---
title: "03. SQLx Database"
---

In Node.js nutzen wir oft ORMs (Prisma, TypeORM) oder Query Builder (Knex).
In Rust ist **SQLx** der Goldstandard für "Pure SQL", aber sicher.
Es ist **kein ORM**. Du schreibst SQL. Aber der Compiler prüft dein SQL.

## Das Killer Feature: Compile-Time Checks

Stell dir vor, du schreibst:
`SELECT * FROM users WHERE id = $1`

Und du hast einen Typo (`usrs`).
Node.js: Crash zur Runtime.
Rust (SQLx): `cargo check` **fällt fehl**.

Wie? Das `sqlx::query!` Macro verbindet sich zur Compile-Time mit deiner DB, führt einen `EXPLAIN` aus und checkt Types.

## Setup

```toml
[dependencies]
sqlx = { version = "0.7", features = ["runtime-tokio-native-tls", "postgres"] }
dotenvy = "0.15"
```

Du brauchst eine `.env` Datei:
`DATABASE_URL=postgres://user:pass@localhost/mydb`

## Querying

Wir brauchen einen Connection Pool (Thread-safe).

```rust
use sqlx::postgres::PgPoolOptions;

#[tokio::main]
async fn main() -> Result<(), sqlx::Error> {
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect("postgres://...").await?;

    // Einfache Query
    let row: (i64,) = sqlx::query_as("SELECT count(*) FROM users")
        .fetch_one(&pool).await?;

    println!("Users: {}", row.0);
    Ok(())
}
```

## Mapping auf Structs (`FromRow`)

Kein manuelles Mappen nötig.

```rust
#[derive(sqlx::FromRow, Debug)]
struct User {
    id: i32,
    username: String,
    active: bool,
}

// Holen
let users = sqlx::query_as::<_, User>("SELECT * FROM users")
    .fetch_all(&pool)
    .await?;

// Insert
sqlx::query("INSERT INTO users (username) VALUES ($1)")
    .bind("Alice")
    .execute(&pool)
    .await?;
```

## Das `query!` Macro

Das hier ist Magie. Wenn du `sqlx-cli` installiert hast (`cargo install sqlx-cli`) und `DATABASE_URL` gesetzt ist:

```rust
let users = sqlx::query!(
    "SELECT id, username FROM users WHERE active = $1", 
    true
)
.fetch_all(&pool)
.await?;

for user in users {
    // user.username ist typtreu! Wenn die DB sagt "VARCHAR NOT NULL", ist es String.
    // Wenn "VARCHAR", ist es Option<String>.
    println!("{}", user.username);
}
```

:::warning[Migrations]
SQLx hat auch ein eingebautes Migrations-System.
`sqlx migrate add create_users_table`
`sqlx migrate run`
Das ist Best Practice!
:::

---

## Zusammenfassung
1. **SQLx** ist async und type-safe.
2. **`FromRow`** mappt DB Rows auf Structs.
3. **`query!` Macro** prüft SQL zur Compile-Zeit (erfordert laufende DB beim Kompilieren, oder "Offline Mode" mit JSON Files).
