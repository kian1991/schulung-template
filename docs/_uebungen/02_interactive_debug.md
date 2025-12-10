---
title: "Übung 2: Interaktiv & Debugging"
---

## Szenario

Container sind keine Blackboxen. Du kannst hineinschauen, Logs lesen und sogar "einbrechen" (exec).

### Aufgabe 1: Der Interactive Mode

1.  Starte einen Ubuntu Container und öffne sofort eine Shell darin:
    -   `docker run -it ubuntu bash`
    -   Was bedeutet `-it`? (Interactive + TTY)
2.  Du bist jetztroot im Container.
    -   Erstelle eine Datei: `echo "Hello" > /secret.txt`
    -   Verlasse den Container mit `exit`.
3.  Starte wieder `docker run -it ubuntu bash`.
    -   Ist `/secret.txt` noch da? Warum nicht? (Immutability!).

### Aufgabe 2: Logs lesen

1.  Starte wieder unseren Nginx im Hintergrund: `docker run -d --name web-debug nginx`.
2.  Lass dir die Logs anzeigen: [`docker logs`](https://docs.docker.com/reference/cli/docker/container/logs/) `web-debug`.
3.  "Folge" den Logs live: `docker logs -f web-debug`.
    -   Öffne ein zweites Terminal (oder Tab) und stoppe/starte den Container dort, oder mache einfach nichts, Nginx logs sind ruhig ohne Traffic.
    -   Breche das Folgen mit `Ctrl+C` ab (der Container läuft weiter!).

### Aufgabe 3: Exec - Der Einbruch

Der Container `web-debug` läuft im Hintergrund. Du willst aber mal kurz reinschauen und prüfen, ob die `nginx.conf` da ist.

1.  Starte eine Shell *in dem laufenden Container*:
    -   [`docker exec`](https://docs.docker.com/reference/cli/docker/container/exec/) `-it web-debug bash`
2.  Schau dich um: `ls -l /etc/nginx/`.
3.  Geh wieder raus: `exit`.
4.  Läuft der Container noch? (`docker ps`). Ja! `exec` startet nur einen *zusätzlichen* Prozess.

### Aufgabe 4: Inspect

Wir brauchen die IP-Adresse des Containers.

1.  Nutze [`docker inspect`](https://docs.docker.com/reference/cli/docker/container/inspect/) `web-debug`. Das ist viel JSON!
2.  Finde die "IPAddress".
3.  Pro-Tipp: Filtere mit `grep` oder dem Go-Template Format:
    -   `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web-debug`

<details>
<summary>Lösung & Erklärung</summary>

-   `-it` ist essentiell für Shells. Ohne das beendet sich `bash` sofort, weil kein Input-Kanal da ist.
-   Ein neuer `run` Befehl startet immer eine FRISCHE Instanz vom Image. Daten im "Container Layer" sind flüchtig (mehr dazu später bei Volumes).
-   `exec` ist super zum Debuggen.
-   `inspect` verrät dir ALLES über den Container (Interne IPs, Pfade, Environment Variables).
</details>
