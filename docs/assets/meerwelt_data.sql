-- Tabelle erstellen
CREATE TABLE IF NOT EXISTS ocean_articles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    FULLTEXT(title, content)
);

-- Daten einfügen
INSERT INTO ocean_articles (title, content) VALUES
('Der Blauwal', 'Der Blauwal (Balaenoptera musculus) ist das größte bekannte Tier der Erdgeschichte. Er kann bis zu 33 Meter lang werden und 200 Tonnen wiegen. Seine Zunge wiegt so viel wie ein Elefant. Er ernährt sich fast ausschließlich von Krill.'),
('Korallenriffe', 'Korallenriffe sind komplexe Ökosysteme unter Wasser, die von riffbildenden Steinkorallen gebildet werden. Sie werden oft als "Regenwälder der Meere" bezeichnet, da sie eine enorme Artenvielfalt beherbergen. Das Great Barrier Reef ist das größte Riffsystem der Erde.'),
('Der Große Weiße Hai', 'Der Weiße Hai (Carcharodon carcharias) ist der größte Raubfisch der Welt. Er ist bekannt für seinen ausgeprägten Geruchssinn und seine Rolle als Spitzenprädator in den Ozeanen. Entgegen der landläufigen Meinung jagt er Menschen nicht gezielt.'),
('Tiefsee-Anglerfisch', 'In der absoluten Dunkelheit der Tiefsee lebt der Anglerfisch. Weibchen besitzen eine biolumineszente "Angel" am Kopf, um Beute anzulocken. Männchen sind oft winzig und verschmelzen parasitär mit dem Weibchen.'),
('Ozeanströmungen', 'Meeresströmungen wie der Golfstrom transportieren gewaltige Mengen Wasser und Wärme um den Globus. Sie beeinflussen das Weltklima maßgeblich. Der Golfstrom sorgt beispielsweise für das milde Klima in Europa.'),
('Plastikverschmutzung', 'Millionen Tonnen Plastikmüll landen jährlich in den Ozeanen. Mikroplastik wurde bereits in den tiefsten Meeresgräben und im arktischen Eis gefunden. Es bedroht Meeresbewohner, die es mit Nahrung verwechseln.'),
('Die Intelligenz der Oktopusse', 'Kraken und Oktopusse gelten als die intelligentesten Wirbellosen. Sie können Werkzeuge nutzen, Gläser öffnen und komplexe Probleme lösen. Sie besitzen drei Herzen und blaues Blut.'),
('Biolumineszenz', 'Viele Meeresbewohner, besonders in der Tiefsee, können eigenes Licht erzeugen. Dies dient der Kommunikation, der Tarnung (Gegenbeleuchtung) oder dem Anlocken von Beute. Bekannte Beispiele sind Leuchtquallen und Laternenfische.'),
('Hydrothermale Quellen', 'Schwarze Raucher sind hydrothermale Quellen am Meeresboden. Hier tritt heißes, mineralreiches Wasser aus. Sie bilden die Lebensgrundlage für spezialisierte Ökosysteme, die ohne Sonnenlicht existieren (Chemosynthese).'),
('Der Marianengraben', 'Der Marianengraben ist die tiefste Stelle der Weltmeere, mit einer Tiefe von etwa 11.000 Metern. Der Druck dort unten ist mehr als 1000-mal höher als an der Oberfläche. Nur wenige spezialisierte Lebewesen können dort überleben.'),
('Seegraswiesen', 'Seegraswiesen sind wichtige Kohlenstoffspeicher (Blue Carbon) und bieten Lebensraum für viele Jungfische. Sie stabilisieren den Meeresboden und verbessern die Wasserqualität.'),
('Wale und Echoortung', 'Zahnwale wie Delfine und Pottwale nutzen Echoortung (Sonar), um sich zu orientieren und Beute zu finden. Sie senden Klicklaute aus und interpretieren das Echo, um ein "Hörbild" ihrer Umgebung zu erstellen.'),
('Gezeiten (Ebbe und Flut)', 'Die Gezeiten werden hauptsächlich durch die Anziehungskraft des Mondes und der Sonne verursacht. Der Tidenhub variiert weltweit stark, von wenigen Zentimetern bis zu über 10 Metern in der Bay of Fundy.'),
('El Niño', 'El Niño ist ein Klimaphänomen im pazifischen Ozean, bei dem sich das Oberflächenwasser ungewöhnlich stark erwärmt. Dies hat weltweite Auswirkungen auf Wetter, Fischerei und Landwirtschaft.'),
('Mangrovenwälder', 'Mangroven sind salztolerante Bäume, die in den Gezeitenzonen tropischer Küsten wachsen. Ihre Wurzeln bieten Schutz für Fische und Krebstiere und schützen die Küste vor Erosion und Sturmfluten.');
