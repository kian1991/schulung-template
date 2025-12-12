---
title: "Final: The Citadel"
---

Herzlichen Glückwunsch. Du hast das Level "Rustacean" erreicht.
Jetzt bauen wir "The Citadel". Eine gesicherte API für User-Management.

## Architecture Guidelines

Wir bauen keine Spaghetti.
Wir nutzen **Ports & Adapters**.

1. **Domain Layer**: Struct `User`, Trait `UserRepository` (nur Rust Code).
2. **Infrastructure Layer**: Struct `PostgresRepository` (SQLx Code).
3. **Application Layer**: `AuthService` (Hashing, Logic).
4. **Transport Layer**: Axum Handlers (HTTP -> Logic).

## Requirements

1. **Password Hashing**: Nutze `argon2` crate. Passwörter NIEMALS im Klartext speichern.
2. **Unit Tests**: Teste den `AuthService` mit einem `MockRepository`.
3. **Integration Tests**: Ein Test, der die *echte* App (mit Test-DB) startet und `/register` aufruft.
4. **Login Endpoint**: Return 200 OK wenn PW stimmt, 401 wenn nicht.

## Deployment

Erstelle ein `Dockerfile`.
- Multi-Stage Builder.
- Distroless Image oder Alpine/Debian-Slim.
- Das Image muss unter 100MB sein.

## Checkliste

- [ ] `cargo check` passes
- [ ] `cargo clippy` is happy (keine Warnings!)
- [ ] `cargo test` (Unit & Integration) passes
- [ ] `docker build` erstellt ein Image

:::tip[Testing Axum]
Du kannst Axum Router direkt testen ohne HTTP Request:
`app.oneshot(Request::builder()...)`
:::
