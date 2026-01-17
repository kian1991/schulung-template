---
title: "GIS (Geodaten)"
---

# GIS: Geodaten in MySQL

Früher brauchte man PostGIS oder ElasticSearch für Geodaten. Heute kann MySQL das nativ und sehr effizient.

## 1. Datentypen

MySQL bietet spezielle Datentypen für geometrische Formen, die dem OGC (Open Geospatial Consortium) Standard folgen.

*   `POINT`: Ein einzelner Punkt (z.B. Standort eines Users).
*   `LINESTRING`: Eine Route oder Straße.
*   `POLYGON`: Eine Fläche (z.B. Liefergebiet, Stadtgrenze).
*   `GEOMETRY`: Kann jeden der obigen Typen speichern.

## 2. Das Koordinatensystem (SRID)

Die Erde ist keine Scheibe (meistens).
*   **SRID 0 (Default):** Eine unendliche flache Ebene. Distanzen sind einfach Pythagoras. Gut für CAD-Pläne oder Pixel-Koordinaten.
*   **SRID 4326 (WGS 84):** Das GPS-System. Längengrad und Breitengrad auf einer Kugel (Ellipsoid).

:::important[Wichtig]
Wenn du GPS-Daten speicherst, nutze **immer** SRID 4326. Sonst sind deine Distanzberechnungen falsch!
:::

## 3. Praxis-Beispiel: Die Pizza-Suche

Wir speichern Restaurants und suchen alles im Umkreis von 5km.

### Tabelle anlegen
```sql
CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    -- POINT(Longitude Latitude) !
    location POINT NOT NULL SRID 4326,
    SPATIAL INDEX(location) -- Der Turbo für die Suche
);
```

### Daten einfügen
Achtung: Die Reihenfolge ist `POINT(Längengrad Breitengrad)` (X Y). In Google Maps ist es oft andersrum!

```sql
INSERT INTO restaurants (name, location) 
VALUES 
    ('Döner King', ST_GeomFromText('POINT(13.4000 52.5200)', 4326)),
    ('Sushi Bar', ST_GeomFromText('POINT(13.4050 52.5200)', 4326));
```

### Umkreissuche (Radius)
Wir nutzen `ST_Distance_Sphere`, um die Distanz in Metern auf der Erdkugel zu berechnen.

```sql
-- Finde alles im Umkreis von 1000 Metern um den Alexanderplatz
SELECT name, 
       ST_Distance_Sphere(location, ST_GeomFromText('POINT(13.41 52.52)', 4326)) as dist_m
FROM restaurants
WHERE ST_Distance_Sphere(location, ST_GeomFromText('POINT(13.41 52.52)', 4326)) < 1000;
```

:::note[ST]
ST steht für Spatial. Spatial ist ein Synonym für Geometrische Operationen. GIS steht üblicherweise für Geographic Information System. Seit MySQL 8.0 gibt es Spatial Operationen.
:::

## 4. Polygon-Suche (Liefergebiet)

Liegt ein Punkt in einem bestimmten Bereich?

```sql
SELECT name 
FROM restaurants 
WHERE ST_Within(location, ST_GeomFromText('POLYGON((...))', 4326));
```

## 5. Theorie & Vergleich

### Wann reicht MySQL GIS?
Für **99% aller Web-Anwendungen** ist MySQL 8.0 völlig ausreichend.
*   **Use Cases:** Store Locator, Umkreissuche, "Liefern wir zu dir?" (Point in Polygon), einfache Routen-Distanz.
*   **Vorteil:** Du brauchst keinen separaten GIS-Server. Du hast ACID-Transaktionen, Backups und Replikation zusammen mit deinen relationalen Daten.

### Wann brauchst du PostGIS?
PostgreSQL mit der PostGIS-Extension ist der Gold-Standard im GIS-Bereich. Ein Wechsel lohnt sich, wenn:
*   Du **Rasterdaten** (Satellitenbilder, Höhenmodelle) verarbeiten musst.
*   Du komplexe **Topologie-Prüfungen** brauchst (z.B. Netzwerkanalysen für Stromleitungen).
*   Du Koordinatensysteme (Projektionen) direkt in der DB transformieren musst (`ST_Transform`).

### Und MariaDB?
MariaDB unterstützt ebenfalls GIS (OGC Standard), aber es gibt technische Unterschiede:
*   **Engine:** MySQL nutzt die **Boost.Geometry** Library. Seit Version 8.0 ist die Implementierung extrem strikt:
    *   **SRID-Matching:** Operationen zwischen unterschiedlichen SRIDs werfen Fehler.
    *   **Achsen-Reihenfolge:** MySQL 8.0 hält sich strikt an den EPSG-Standard (bei SRID 4326 ist das *Latitude, Longitude*). MariaDB und ältere MySQL-Versionen sind da oft laxer (X, Y).
*   **Kompatibilität:** Grundlegende Funktionen (`ST_Contains`, `ST_Within`) funktionieren meist identisch. Bei komplexen Berechnungen auf der Erdkugel (Ellipsoid) ist MySQL 8.0 oft genauer, da es standardmäßig geodätische Berechnungen auf dem Ellipsoid durchführt, während MariaDB historisch eher planare Annäherungen nutzte (wobei neuere Versionen aufholen).

### Quellen
*   [Geography Support in MySQL 8.0](https://dev.mysql.com/blog-archive/geography-in-mysql-8-0/) - Erklärung zur Ellipsoid-Unterstützung (SRID 4326).
*   [Boost.Geometry Library](https://www.boost.org/doc/libs/release/libs/geometry/doc/html/index.html) - Die Engine unter der Haube von MySQL 8.0.

