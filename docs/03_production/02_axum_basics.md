---
title: "02. Axum Framework"
---

Axum ist wie Express.js, aber mit Typsicherheit und ohne Runtime Cost.
Es baut auf **Tokio** und **Hyper** auf.

## Hello World

```rust
use axum::{routing::get, Router};

#[tokio::main]
async fn main() {
    let app = Router::new().route("/", get(|| async { "Hello, World!" }));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

## Extractors (Die Magie)

In Express fummeln wir `req.body` oder `req.params` raus. Wenn was fehlt, crasht es.
In Axum deklarieren wir im Funktionskopf, was wir brauchen. Axum extrahiert es **bevor** unsere Funktion aufgerufen wird.

### JSON Body

```rust
use axum::Json;
use serde::Deserialize;

#[derive(Deserialize)]
struct CreateUser {
    username: String,
}

// Wenn das JSON invalid ist, wird diese Funktion GAR NICHT aufgerufen (Axum sendet 400).
async fn create_user(Json(payload): Json<CreateUser>) -> String {
    format!("User {} created", payload.username)
}

// Router wiring:
// .route("/users", post(create_user))
```

### Path Params & Query Params

```rust
use axum::extract::{Path, Query};
use serde::Deserialize;

#[derive(Deserialize)]
struct Pagination {
    page: u32,
}

// GET /users/123?page=2
async fn get_user(
    Path(id): Path<u32>, 
    Query(params): Query<Pagination>
) -> String {
    format!("Get User {} on page {}", id, params.page)
}
```

## Shared State (Database Pools)

Wie kommen wir an die DB Verbindung? Globale Variablen sind böse. Dependency Injection ist der Weg.

```rust
use axum::{extract::State, routing::get, Router};
use std::sync::Arc;

struct AppState {
    db_string: String,
}

#[tokio::main]
async fn main() {
    let shared_state = Arc::new(AppState {
        db_string: "postgres://...".to_string(),
    });

    let app = Router::new()
        .route("/", get(handler))
        .with_state(shared_state); // State injizieren
}

// State extrahieren (Thread-safe dank Arc!)
async fn handler(State(state): State<Arc<AppState>>) -> String {
    format!("Connected to {}", state.db_string)
}
```

:::info[Middleware]
Axum nutzt `Tower` für Middleware (Logging, CORS, Auth).
`app.layer(CorsLayer::permissive())`
:::

---

## Zusammenfassung
1. **Router**: Definiert Endpoints.
2. **Handlers**: Asynchrone Funktionen.
3. **Extractors**: `Json`, `Path`, `State`, `Extension`. Deklaratives Parsen.
4. **Responders**: Handler können Strings, JSON oder HTML zurückgeben (alles was `IntoResponse` implementiert).
