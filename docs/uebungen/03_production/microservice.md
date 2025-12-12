---
title: "Lab 3: Task Microservice"
---

Wir bauen eine echte JSON API mit Datenbank. "The Real Deal".

## The Stack
- **Axum** (Web)
- **Tokio** (Runtime)
- **SQLx** (Database)
- **Serde** (JSON)

## Setup

1. `docker run -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=todo -p 5432:5432 -d postgres`
2. `.env`: `DATABASE_URL=postgres://postgres:secret@localhost:5432/todo`
3. `sqlx migrate add create_tasks`
4. In `migrations/...sql`:
    ```sql
    CREATE TABLE tasks (
        id BIGSERIAL PRIMARY KEY,
        title TEXT NOT NULL,
        done BOOLEAN NOT NULL DEFAULT FALSE
    );
    ```
5. `sqlx migrate run`

## Mission

Implementiere folgende Endpoints:

1. `POST /tasks`: Body `{ title: "Learn Rust" }`. Return Created Task.
2. `GET /tasks`: Return List of Tasks `[{ id: 1, title: "...", done: false }]`.
3. `PATCH /tasks/:id`: Body `{ done: true }`. Mark task as done.

## Starter Hints

### Structs
Du brauchst ein Struct für die DB (`FromRow`) und eines für den Request. Kannst du beides in einem? Oder lieber trennen (DTO Pattern)?

```rust
#[derive(Deserialize)]
struct CreateTask {
    title: String,
}

#[derive(Serialize, FromRow)]
struct Task {
    id: i64,
    title: String,
    done: bool,
}
```

### Dependency Injection
Vergiss nicht, den `PgPool` via `State` zu sharen!

```rust
#[tokio::main]
async fn main() {
    let pool = PgPoolOptions::new().connect(...).await.unwrap();
    let app = Router::new().route(...).with_state(pool);
    // ...
}
```

### SQLx Query
Nutze das `query!` Macro!

```rust
sqlx::query!("INSERT INTO tasks (title) VALUES ($1) RETURNING *", payload.title)
    .fetch_one(&pool)
    .await?
```

## Bonus

Füge Validierung hinzu: `title` darf nicht leer sein. Wenn doch -> HTTP 400 Bad Request (Custom Error Type implementieren, der `IntoResponse` kann!).
