-- 1. Tabelle erstellen
CREATE TABLE charging_stations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    location POINT NOT NULL SRID 4326,
    SPATIAL INDEX(location)
);

-- 2. Daten einfügen
-- WICHTIG: ST_GeomFromText('POINT(LONG LAT)', 4326)
INSERT INTO charging_stations (name, location) VALUES
('Alexanderplatz', ST_GeomFromText('POINT(13.413215 52.521918)', 4326)),
('Brandenburger Tor', ST_GeomFromText('POINT(13.377704 52.516275)', 4326)),
('Hauptbahnhof', ST_GeomFromText('POINT(13.369402 52.525084)', 4326)),
('Potsdamer Platz', ST_GeomFromText('POINT(13.376198 52.509669)', 4326));

-- 3. Distanz berechnen (Alex <-> Brandenburger Tor)
-- Wir holen die Koordinaten direkt aus der Tabelle oder hardcoden sie zum Testen
SELECT ST_Distance_Sphere(
    (SELECT location FROM charging_stations WHERE name = 'Alexanderplatz'),
    (SELECT location FROM charging_stations WHERE name = 'Brandenburger Tor')
) as distance_meters;

-- 4. Umkreissuche (Checkpoint Charlie)
-- Checkpoint Charlie: 13.390391, 52.507443
SELECT name, 
       ST_Distance_Sphere(location, ST_GeomFromText('POINT(13.390391 52.507443)', 4326)) as distance
FROM charging_stations
WHERE ST_Distance_Sphere(location, ST_GeomFromText('POINT(13.390391 52.507443)', 4326)) <= 2000
ORDER BY distance ASC;

-- 5. Bonus: Polygon (Tiergarten grob)
SELECT name 
FROM charging_stations 
WHERE ST_Within(location, ST_GeomFromText('POLYGON((13.33 52.51, 13.38 52.51, 13.38 52.52, 13.33 52.52, 13.33 52.51))', 4326));

-- 6. Bonus: GeoJSON
SELECT name, ST_AsGeoJSON(location) as geojson 
FROM charging_stations;
