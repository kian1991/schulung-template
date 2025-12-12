---
title: "02. Smart Pointers"
---

Bisher haben wir gelernt: Ein Wert hat GENAU EINEN Owner. Das ist sicher, aber manchmal zu restriktiv.
Was ist mit Listen, Graphen oder Daten, die von mehreren Stellen genutzt werden?
Hier kommen **Smart Pointers** ins Spiel.

## `Box<T>` (Ab auf den Heap)

Standardmäßig landen primitive Typen und kleine Structs auf dem **Stack**. Wenn du etwas bewusst auf den **Heap** legen willst (z.B. weil es riesig ist oder eine rekursive Struktur hat), nutzt du `Box`.

```rust
// Rekursive Typen gehen NUR mit Box (da Größe zur Compile-Zeit unbekannt)
enum List {
    Cons(i32, Box<List>),
    Nil,
}

let list = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
```

In TS ist *alles* (Objekte) implizit "boxed" (also ein Pointer auf Heap-Daten). In Rust ist `Box<T>` der Weg, dieses Verhalten explizit zu erzwingen.

## `Rc<T>` (Shared Ownership)

Manchmal *brauchen* wir mehrere Owner. Stell dir einen Graphen vor: Ein Node wird von mehreren Edges gehalten. Wer ist der Owner?
`Rc` (Reference Counted) erlaubt genau das.

```rust
use std::rc::Rc;

let value = Rc::new(5);
let ref1 = Rc::clone(&value); // Counter +1
let ref2 = Rc::clone(&value); // Counter +2

// value stirbt erst, wenn ALLE Pointer weg sind (Count == 0).
```

:::warning[Single Threaded!]
`Rc` ist NICHT Thread-Safe. Für Multi-Threading (Day 3) nutzen wir den großen Bruder `Arc` (Atomic Rc).
:::

## `RefCell<T>` (Interior Mutability)

Erinnerst du dich? "Entweder viele Reader ODER ein Writer".
Manchmal ist das zur Compile-Zeit unmöglich zu beweisen, aber du *weißt*, dass es zur Runtime sicher ist.

`RefCell` verschiebt den Borrow-Check von **Compile-Time** auf **Runtime**.
Das nennt man **Interior Mutability pattern**: Von außen sieht das Ding immutabel aus, aber innen drin mutieren wir es.

```rust
use std::cell::RefCell;

let data = RefCell::new(5);

{
    // Wir leihen uns mutable access, obwohl data selbst nicht 'mut' ist!
    let mut mutable_ref = data.borrow_mut();
    *mutable_ref += 1;
} // Scope Ende -> Borrow zurückgegeben.

println!("Data: {:?}", data.borrow());
```

**Gefahr:** Wenn du zur Runtime gegen die Regeln verstößt (z.B. zwei `borrow_mut()` gleichzeitig), stürzt dein Programm ab (`panic!`).

## Die Kombination: `Rc<RefCell<T>>`

Das ist das ultimative Pattern für komplexe Datenstrukturen (wie Doubly Linked Lists) in Single-Threaded Apps:
- `Rc`: Damit es mehrere Owner gibt.
- `RefCell`: Damit die Owner den Inhalt ändern können.

```rust
type SharedNode = Rc<RefCell<Node>>;
```

---

## Zusammenfassung
1. **`Box<T>`**: Heap Allocation, Single Owner.
2. **`Rc<T>`**: Shared Ownership (Reference Counting), Read-Only.
3. **`RefCell<T>`**: Runtime Borrow Checking, ermöglicht Mutation von "immutable" Daten.
4. **`Arc<T>`**: Wie `Rc`, aber Thread-Safe.
