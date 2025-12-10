---
title: "Übung 3: Die Außenwelt - Ports, Env & Volumes"
---

## Szenario

Ein isolierter Container ist sicher, aber nutzlos. Wir müssen ihn mit der Außenwelt verbinden.

### Aufgabe 1: Ports Mapping

Der Nginx lauscht IM Container auf Port 80. Aber dein Laptop (Host) weiß davon nichts.

1.  Starte Nginx und mappe ihn auf Port 8080 am Host:
    -   `docker run -d -p 8080:80 --name web-port nginx`
2.  Öffne deinen Browser auf `http://localhost:8080`. "Welcome to nginx!".
3.  Was passiert, wenn du `-p 80:80` versuchst? (Wahrscheinlich Konflikt oder Permission Error auf Mac/Linux ohne Root).
4.  Lösche den Container (`rm -f web-port`).

### Aufgabe 2: Environment Variables

Viele Apps konfigurieren sich über ENV-Vars. Wir nutzen `alpine`, um das zu testen.

1.  Starte einen Container, der eine Variable ausgibt:
    -   `docker run alpine sh -c 'echo $MEINE_VAR'` -> Leer.
2.  Jetzt mit Variable:
    -   `docker run -e MEINE_VAR="Hallo Welt" alpine sh -c 'echo $MEINE_VAR'`
3.  Praxisbeispiel MySQL (nur kurz antesten, dauert zum downloaden evtl.):
    -   `docker run -d -e MYSQL_ROOT_PASSWORD=secret --name db mysql:8`
    -   Ohne das Password würde der Container sofort crashen (siehe `docker logs db`).
    -   Stoppe und lösche die DB wieder, um Ressourcen zu sparen.

### Aufgabe 3: Bind Mounts (Der "Magische Ordner")

Wir wollen unsere eigene HTML-Seite im Nginx sehen.

1.  Erstelle lokal einen Ordner `webseite` und darin eine `index.html`:
    -   `mkdir webseite`
    -   `echo "<h1>Meine Docker Seite</h1>" > webseite/index.html`
2.  Starte Nginx und "mounte" diesen Ordner an die Stelle, wo Nginx seine Daten erwartet (`/usr/share/nginx/html`).
    -   `docker run -d -p 8080:80 -v $(pwd)/webseite:/usr/share/nginx/html --name mein-web nginx`
    -   `$(pwd)` ist wichtig, Docker braucht absolute Pfade!
3.  Check `http://localhost:8080`. Siehst du deinen Text?
4.  **Live Edit**: Ändere die `index.html` lokal auf deinem Laptop.
    -   Lade die Seite im Browser neu. Die Änderung ist sofort da! Das ist der Standard-Workflow für Web-Entwicklung mit Docker.

<details>
<summary>Lösung & Erklärung</summary>

-   `-p Host:Container`. Der Host-Port ist frei wählbar, der Container-Port ist durch die App festgelegt.
-   `-e KEY=VALUE`. Wichtig für Passwörter, URLs, Debug-Flags.
-   `-v HostPfad:ContainerPfad`. Bind Mounts spiegeln einen Ordner rein. Änderungen sind sofort auf beiden Seiten sichtbar.
</details>
