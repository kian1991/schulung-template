---
title: "04. Labs: Production"
---

Heute haben wir die Komfortzone verlassen. Async Rust ist mächtig, aber erfordert Disziplin (Future polling, Thread-Safety).
Dafür haben wir jetzt einen High-Performance Backend Stack.

## Recap

1. **Tokio:** Unsere Async Runtime (Thread Pool).
2. **Axum:** Ergonomisches, Type-Safe Web Framework.
3. **Handle & Extract:** `async fn handler(Json(body): ...)`
4. **SQLx:** Compile-time Checked Queries (`query!`).

## Deine Missionen

### 1. Axum Drills
Bau dir Muskelgedächtnis für Handler und Extractors auf.

*(Siehe "Übungen > Production > Drills" in der Sidebar)*

### 2. Capstone: Task Microservice
Wir bauen eine volle CRUD API mit Postgres.
Du wirst Docker nutzen, SQL-Migrationen schreiben und Axum Endpoints verdrahten.
Das ist "Real World Rust".

*(Siehe "Übungen > Production > Task Microservice" in der Sidebar)*
