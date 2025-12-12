---
title: "04. Labs: Advanced Logic"
---

Heute haben wir Rust robuster gemacht. Abstraktionen mit Traits, Flexibilität mit Smart Pointers und Safety mit Error Handling.

## Recap

1. **Traits:** definieren Verhalten (wie Interfaces).
2. **Generic Bounds:** `fn foo<T: Display>(t: T)` sichern Typesafety.
3. **Smart Pointers:** `Box` (Heap), `Rc` (Shared), `RefCell` (Interior Mutability).
4. **Error Handling:** `Result` statt Exceptions. `?` Operator for the win.

## Deine Missionen

### 1. Error Drills
Falsche Typen, Panics und unsichere Unwraps. Mach den Code sauber.

*(Siehe "Übungen > Advanced > Drills" in der Sidebar)*

### 2. Capstone: Log Parser
Ein CLI Tool, das echte Files liest, parst und filtert. Du wirst alles kombinieren: File I/O, Strings, Enums, Error Handling.

*(Siehe "Übungen > Advanced > Log Parser" in der Sidebar)*
