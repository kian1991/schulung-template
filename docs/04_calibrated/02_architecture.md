---
title: "02. Architecture"
---

Wie strukturiert man große Rust-Projekte?
Ein populäres Pattern ist **Hexagonal Architecture** (Ports & Adapters).

Ziel: Entkopplung. Die Datenbank soll austauschbar sein (für Tests), der Webserver nur ein Detail.

## Traits as Ports

Unsere Business Logic ("Domain") definiert, was sie braucht, nicht *wie* es gemacht wird.

```rust
// Domain Layer (Pure Rust, no Frameworks)
use async_trait::async_trait;

#[async_trait]
pub trait UserRepository {
    async fn get_user(&self, id: i32) -> Result<User, String>;
    async fn create_user(&self, user: User) -> Result<(), String>;
}

pub struct UserService<R: UserRepository> {
    repo: R,
}

impl<R: UserRepository> UserService<R> {
    pub fn new(repo: R) -> Self {
        Self { repo }
    }

    pub async fn register(&self, user: User) {
        // Business Logic...
        self.repo.create_user(user).await;
    }
}
```

## Adapters

Der "Real World" Adapter implementiert den Trait.

```rust
// Infrastructure Layer (SQLx, Postgres)
pub struct PostgresRepo {
    pool: PgPool,
}

#[async_trait]
impl UserRepository for PostgresRepo {
    async fn get_user(&self, id: i32) -> Result<User, String> {
        // sqlx code here
    }
    // ...
}
```

## Dependency Injection (Wiring)

In `main.rs` (Composition Root) stecken wir alles zusammen.

```rust
#[tokio::main]
async fn main() {
    let pool = PgPool::connect(...).await.unwrap();
    let repo = PostgresRepo { pool };
    let service = UserService::new(repo);

    // Axum State bekommt den Service
}
```

## Testability

Der massive Vorteil: Für Unit Tests nutzen wir ein `MockRepo`.

```rust
struct MockRepo;

#[async_trait]
impl UserRepository for MockRepo {
    async fn get_user(&self, id: i32) -> Result<User, String> {
        Ok(User { ... }) // Return Dummy Data
    }
}

#[tokio::test]
async fn test_service() {
    let repo = MockRepo;
    let service = UserService::new(repo);
    // Test logic NO Database required!
}
```

:::tip[Mocking Libraries]
Für komplexe Mocks gibt es `mockall`.
`#[automock]` generiert den Mock-Code für dich.
:::

---

## Zusammenfassung
1. **Business Logic** definiert Traits (Ports).
2. **Infrastructure** implementiert Traits (Adapters).
3. **Main** verdrahtet alles (Dependency Injection).
4. **Tests** nutzen Mocks statt echter DBs.
