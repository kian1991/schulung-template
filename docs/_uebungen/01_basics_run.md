---
title: "Übung 1: Die ersten Schritte"
---

## Szenario

Willkommen in der Docker Welt! Wir fangen ganz am Anfang an. Dein Ziel ist es, Container zu starten, zu stoppen und aufzuräumen.

### Aufgabe 1: Hello World

1.  Starte den Klassiker: [`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) `hello-world`.
2.  Lies den Output genau durch. Was sagt Docker?
    -   Hat er das Image lokal gefunden?
    -   Was hat er gemacht?
3.  Führe es noch einmal aus. Geht es schneller? Warum?

### Aufgabe 2: Der Webserver (Foreground vs. Background)

1.  Starte einen Nginx Server: `docker run nginx`.
    -   Was passiert? Dein Terminal hängt ("Foreground Mode"). Du siehst Logs.
2.  Beende ihn mit `Ctrl+C`.
3.  Starte ihn im Hintergrund ("Detached Mode"): `docker run -d nginx`.
    -   Du bekommst eine lange ID zurück.
4.  Schau nach, ob er läuft: [`docker ps`](https://docs.docker.com/reference/cli/docker/container/ls/).

### Aufgabe 3: Lifecycle Management

1.  Stoppe den Container von Aufgabe 2. Du brauchst die "CONTAINER ID" oder den Namen (Docker gibt ihm einen lustigen Namen, wenn du keinen angibst).
    -   [`docker stop`](https://docs.docker.com/reference/cli/docker/container/stop/) `<ID>`
2.  Checke `docker ps`. Leer? Gut.
3.  Checke `docker ps -a`. Ah, da sind sie! Der "hello-world" Container (Exited) und der Nginx (Exited).
4.  Räume auf. Lösche alle gestoppten Container.
    -   Einzeln: [`docker rm`](https://docs.docker.com/reference/cli/docker/container/rm/) `<ID>`
    -   Oder der "Hausputz": [`docker system prune`](https://docs.docker.com/reference/cli/docker/system/prune/) (Lies die Warnung!).

### Aufgabe 4: Einen Namen geben

1.  Starte einen neuen Nginx, aber gib ihm den Namen "web-01":
    -   `docker run -d --name web-01 nginx`
2.  Versuche, noch einen mit demselben Namen zu starten. Was passiert?
3.  Lösche den Container "web-01". Musst du ihn erst stoppen? Probiere `docker rm web-01` vs `docker rm -f web-01`.

<details>
<summary>Lösung & Erklärung</summary>

-   `docker run` = `pull` (wenn nicht da) + `create` + `start`.
-   Zweiter Run ist schneller, weil das Image im Cache ist (`docker images`).
-   `docker system prune` ist dein bester Freund, um "Leichen" im Keller (gestoppte Container) loszuwerden.
-   Namen müssen einzigartig sein. `rm -f` (force) killt und löscht in einem Schritt.
</details>
