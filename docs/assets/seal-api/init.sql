CREATE TABLE IF NOT EXISTS seals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(100) NOT NULL,
    age INT,
    weight_kg DECIMAL(5,2),
    is_friendly BOOLEAN DEFAULT TRUE
);

INSERT INTO seals (name, species, age, weight_kg, is_friendly) VALUES
('Robby', 'Kalifornischer Seelöwe', 5, 250.5, true),
('Snowball', 'Sattelrobbe', 12, 120.0, false),
('Flappy', 'Walross', 15, 800.0, true),
('Slippy', 'Seeleopard', 4, 300.0, false),
('Barky', 'Seebär', 7, 180.2, true),
('Whiskers', 'Ringelrobbe', 20, 95.5, true),
('Chunky', 'See-Elefant', 9, 2100.0, true),
('Spotty', 'Kegelrobbe', 3, 150.0, true),
('Glider', 'Weddellrobbe', 6, 220.0, true),
('Icy', 'Kappensrobbe', 8, 190.0, false);
