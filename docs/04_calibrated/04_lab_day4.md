---
title: "04. Labs: Architecture"
---

Du kennst die Sprache. Du kennst die Runtime.
Heute zeigen wir, dass wir "Ship-Ready" sind.
Clean Code, Tests und Deployment sind keine Extras, sondern Standard.

## Recap

1. **Testing:** `cargo test` macht Unit & Integration Tests trivial.
2. **Architecture:** Ports & Adapters (mit Traits) entkoppeln die Logik.
3. **Deployment:** Multi-Stage Docker Builds + Distroless = Tiny Images.

## Deine Mission

### The Citadel: Full Stack Capstone

Dies ist deine Abschlussprüfung.
Du baust einen **Secure Authentication Service**.
- Hexagonal Architecture (Trennung von `AuthLogic` und `PostgresDB`).
- Password Hashing (Argon2).
- Unit Tests (mit Mocks für die DB).
- Integration Tests (gegen echte DB).
- Docker Image (< 100 MB).

*(Siehe "Übungen > Final Exam > The Citadel" in der Sidebar)*
