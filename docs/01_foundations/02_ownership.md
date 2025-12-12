---
title: "02. Ownership & Borrowing"
---

Dies ist wahrscheinlich das wichtigste Kapitel deiner Rust-Reise. Wenn du das hier verstehst, ist der Rest einfach.
In TypeScript kümmert sich der Garbage Collector (GC) um deinen Speicher. In C/C++ musst du das manuell tun (malloc/free).
Rust wählt den dritten Weg: **Ownership**.

## The Problem: Data Races & Double Free

Warum tut Rust sich das an?
1. **Garbage Collection (JS/Java/Python):** Safe, aber langsam (Stop-the-world pauses). Unpredictable Performance.
2. **Manual (C/C++):** Schnell, aber extrem fehleranfällig (Segfaults, Memory Leaks).
3. **Rust Ownership:** Zero-Cost Abstraction. Der Compiler weiß zur Compile-Zeit genau, wann Speicher freigegeben werden muss.

## Grundregel Nr. 1: Move Semantics

In JS, wenn du ein Objekt zuweist, kopierst du nur die *Referenz*:

```typescript
// TypeScript
let a = { name: "Kian" };
let b = a; // Beide zeigen auf das GLEICHE Objekt im Heap
console.log(a.name); // Funktioniert
```

In Rust ist das Standardverhalten bei komplexen Typen (Heap-allocated, z.B. `String`) ein **MOVE**:

```rust
// Rust
let s1 = String::from("Hello");
let s2 = s1; // MOVE! s1 ist jetzt UNGÜLTIG. Ownership wurde an s2 übergeben.

// println!("{}", s1); // KOMPILIERFEHLER! "value borrowed here after move"
```

Warum? Wenn `s1` und `s2` beide auf denselben Speicher zeigen würden und beide out of scope gehen, würde Rust versuchen, den Speicher ZWEIMAL freizugeben (Double Free Error). Um das zu verhindern, "stirbt" `s1`, sobald `s2` übernimmt.

### Copy Types (Stack Only)

Bei einfachen Werten (Integer, Boolean, Float) passiert das nicht, weil sie auf dem **Stack** leben und billig zu kopieren sind. Sie implementieren den `Copy`-Trait.

```rust
let x = 5;
let y = x; // COPY, nicht move.
println!("{}", x); // Funktioniert!
```

## Grundregel Nr. 2: Borrowing (Referenzen)

Wir wollen ja nicht immer Ownership übertragen, nur um etwas zu lesen. In JS passen wir Objekte "by reference" in Funktionen. In Rust nennt man das **Borrowing**.

```rust
fn main() {
    let s1 = String::from("Hello");
    print_length(&s1); // Wir leihen s1 nur aus (&)
    // s1 lebt noch! Ownership ist bei uns geblieben.
    println!("s1 ist noch da: {}", s1);
}

fn print_length(s: &String) { // Nimmt eine Referenz (&String)
    println!("Länge: {}", s.len());
} // Referenz geht out of scope, aber Speicher wird NICHT gedropped (gehört ja nicht s).
```

### Mutable Borrowing

Du kannst Daten auch veränderbar ausleihen, aber es gibt eine **Goldene Regel**:

:::important[Die Borrow-Checker Regel]
Du kannst entweder:
- Beliebig viele **Immutable References** (`&T`) haben, ODER
- Genau **eine Mutable Reference** (`&mut T`).
 NIEMALS beides gleichzeitig.
:::

Das verhindert **Data Races** zur Compile-Zeit.

```rust
let mut s = String::from("Hallo");

let r1 = &s; 
let r2 = &s; // OK, mehrere Reader.
// let r3 = &mut s; // FEHLER! Kann nicht mutablen Borrow machen, während r1/r2 aktiv sind.

println!("{}, {}", r1, r2);
// Ab hier werden r1 und r2 nicht mehr genutzt -> Scope für den Borrow endet.

let r3 = &mut s; // JETZT ist es okay.
r3.push_str(" Welt");
```

## Slices: Der Blick in den Speicher

Ein Slice ist eine Referenz auf einen *Teil* einer Collection. In JS gibt es `slice()`, das ein *neues Array* kopiert. In Rust ist ein Slice ein **Zero-Copy View**.

```rust
let s = String::from("Hello World");
let hello = &s[0..5]; // Type: &str (String Slice)
let world = &s[6..11];
```

`&str` ist der primitive String-Typ in Rust. Es ist ein "Blick" auf UTF-8 Bytes.
`String` (der Heap-Typ) ist eher wie ein `StringBuilder` oder `Vector<Char>`.

---

## Zusammenfassung für TS-Devs

1. **Zuweisung = Move (bei Heap-Daten):** Die alte Variable ist "tot".
2. **`&` = Read-Only Reference:** Wie `const`-Argumente, aber garantiert.
3. **`&mut` = Exclusive Mutable Reference:** Nur einer darf schreiben (und niemand lesen währenddessen).
4. **Kein GC:** Sobald der "Owner" out of scope geht, wird der Speicher sofort freigegeben (`drop`).
