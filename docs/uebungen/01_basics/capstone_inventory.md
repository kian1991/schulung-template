---
title: "Lab 1: The Inventory System"
---

Wir bauen ein Lagerverwaltungssystem für einen RPG-Shop.
Ziel: Structs, Enums und `match` nutzen.

## Requirements

1. **Item Types:** Es gibt verschiedene Items: `Potion`, `Weapon`, `Armor`.
    - `Potion` hat einen `Effect` (String).
    - `Weapon` hat `Damage` (number).
    - `Armor` hat `Defense` (number).
    - *Tipp:* Nutze ein Enum `ItemType`!

2. **The Item:** Jedes Item hat:
    - `id`: u32
    - `name`: String
    - `category`: ItemType (das Enum von oben)

3. **Inventory:** Eine Struktur, die eine Liste (`Vec<Item>`) hält.
    - Implementiere `add_item`
    - Implementiere `process_item(id)`: 
        - Wenn es eine Potion ist: "Drinking potion..."
        - Wenn Weapon: "Equipping weapon..."

## Starter Code

```rust
enum ItemType {
    // Vervollständigen...
}

struct Item {
    id: u32,
    name: String,
    // ...
}

struct Inventory {
    items: Vec<Item>
}

impl Inventory {
    fn new() -> Self {
        Inventory { items: Vec::new() }
    }

    fn add_item(&mut self, item: Item) {
        // ...
    }

    fn process_item(&self, id: u32) {
        // Finde das Item (Tipp: self.items.iter().find(...))
        // Nutze match für die Ausgabe
    }
}

fn main() {
    let mut inv = Inventory::new();
    // Items hinzufügen und testen
}
```

## Bonus Challenge

Implementiere eine Methode `total_defense(&self) -> u32`, die die Defense aller Armor-Items aufsummiert. Alle anderen Items geben 0.
