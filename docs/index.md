---
title: "Rust Deep Dive: From TypeScript to Systems"
---

Willkommen zum **Rust Deep Dive**. Dieser Kurs ist speziell für erfahrene Entwickler (insb. mit TypeScript/Node.js Background) konzipiert, die verstehen wollen, wie Rust *wirklich* tickt – ohne dabei in theoretischen Abhandlungen zu versinken.

Wir übersetzen deine mentalen Modelle:
- **Interfaces** -> **Traits**
- **Promises** -> **Futures**
- **Garbage Collection** -> **Ownership & Borrowing**

## Setup & Voraussetzungen

:::warning[Voraussetzungen]
Du solltest folgende Tools installiert haben:
- **Rust (via Rustup):** `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **VS Code** mit der **rust-analyzer** Extension (NICHT die "offizielle" deprecated Extension).
- **Docker & Docker Compose** (für Datenbank-Labs).
:::

:::tip[Dev Environment]
Wir nutzen **Bun** oder **Node** nur für Vergleiche. Dein Fokus liegt auf `cargo`, dem Rust-Build-Tool (dein neues `npm`).
:::

## Agenda

### Modul 1: The Mental Shift (Foundations)
Wir brechen dein Verständnis von Speicherverwaltung auf und setzen es neu zusammen.
- **Intro:** `npm` vs `cargo`, Toolchain Setup.
- **Ownership:** Warum Rust keinen Garbage Collector braucht (Stack vs Heap Deep Dive).
- **Types:** Enums sind nicht das, was du denkst. Pattern Matching als Superpower.
- **Lab:** Bau eines CLI-Inventory-Systems.

### Modul 2: System Logic & Design
Abstraktionen, die zur Compile-Zeit nichts kosten.
- **Traits:** Polymorphismus ohne VTable-Overhead.
- **Smart Pointers:** Wenn der Borrow-Checker nervt (`Box`, `Rc`, `Arc`, `RefCell`).
- **Error Handling:** Warum `try/catch` Vergangenheit ist (`Result`, `Option`, `?`).
- **Lab:** High-Performance Log-Parser CLI.

### Modul 3: Production Rust (Async & Web)
Wir bauen echte Software.
- **Async Runtime:** Wie `Tokio` funktioniert (vs. Node Event Loop).
- **Axum Framework:** Web-Server schreiben, die sich wie Express/Koa anfühlen, aber 10x schneller sind.
- **SQLx:** Type-Safe SQL Queries (Compile-Time Checks für deine DB!).
- **Lab:** Async Task Microservice.

### Modul 4: Architecture, Testing & DevOps
Software professionell shippen.
- **Testing:** Unit-, Integration- und Doc-Tests.
- **Architecture:** Hexagonal Architecture & Dependency Injection in Rust.
- **Deployment:** Multi-Stage Docker Builds & Distroless Images für \<20MB Container.
- **Capstone:** "The Citadel" – Full Stack Service mit DB & Docker.
