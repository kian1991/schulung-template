---
title: "Übung 07: GIS (Geodaten)"
---

# Übung 07: GIS (Geodaten)

## Szenario
Wir bauen eine einfache "Store Locator" Datenbank für eine Kette von E-Scooter Ladestationen.

## Aufgaben

### 1. Tabelle erstellen
Erstelle eine Tabelle `charging_stations` mit:
*   `id` (INT, PK, AI)
*   `name` (VARCHAR)
*   `location` (POINT, SRID 4326, NOT NULL)
*   Einem `SPATIAL INDEX` auf `location`.

### 2. Daten einfügen
Füge folgende Stationen ein (Achtung: Reihenfolge Longitude/Latitude beachten!):
*   "Alexanderplatz": 13.413215, 52.521918
*   "Brandenburger Tor": 13.377704, 52.516275
*   "Hauptbahnhof": 13.369402, 52.525084
*   "Potsdamer Platz": 13.376198, 52.509669

### 3. Distanz berechnen
Berechne die Distanz (in Metern) vom "Alexanderplatz" zum "Brandenburger Tor". Nutze `ST_Distance_Sphere`.

### 4. Umkreissuche
Finde alle Stationen im Umkreis von 2000 Metern um den "Checkpoint Charlie" (13.390391, 52.507443).
Gib Name und Distanz aus, sortiert nach Distanz.

### 5. Bonus: Polygon
Definiere ein Polygon für den "Tiergarten" (grob) und finde alle Stationen, die *innerhalb* dieses Polygons liegen.
*   Tipp: `ST_Within`
*   Polygon Punkte (grob):
    *   13.33, 52.51
    *   13.38, 52.51
    *   13.38, 52.52
    *   13.33, 52.52
    *   13.33, 52.51 (Polygon muss geschlossen sein!)

### 6. Bonus: GeoJSON
Gib die `location` aller Stationen als GeoJSON zurück (`ST_AsGeoJSON`).
