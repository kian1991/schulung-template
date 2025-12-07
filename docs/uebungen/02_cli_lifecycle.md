---
title: "Übung: Der Zombie-Container"
---

## Szenario

Du hast einen Service, der ständig abstürzt (wir simulieren das).
Deine Aufgabe: Sorge dafür, dass er **automatisch neu startet**, aber **nicht**, wenn du ihn manuell stoppst.

### Setup (Der instabile Service)

Wir nutzen `alpine`, das sofort crashed (Exit 1).

```bash
docker run -d --name zombie alpine exit 1
```

Der Container ist sofort "Exited". Check mit `docker ps -a`.

### Aufgabe

1. Lösche den alten Zombie.
2. Starte ihn neu mit einer **Restart Policy**, die ihn immer wiederbelebt, wenn er crashed.
3. Beobachte ihn mit `docker ps` (er sollte "Restarting" anzeigen).
4. Stoppe ihn manuell (`docker stop`).
5. Warte kurz. Startet er wieder? (Sollte er nicht!).

<details>
<summary>Lösung</summary>

Wir nutzen `unless-stopped` oder `on-failure`.
`always` würde ihn auch nach einem manuellen Stop (nach Daemon Restart) wiederbeleben, was oft ok ist, aber `on-failure` ist präziser für "Abstürze".

```bash
docker rm zombie

# Option A (Best for crashes)
docker run -d --name zombie --restart on-failure:5 alpine exit 1
# (Versucht es 5 mal)

# Option B (Der Standard)
docker run -d --name zombie --restart unless-stopped alpine sleep 5
# (Hier nutzen wir sleep, weil exit 1 + restart loop sehr schnell ist)
```

Probiere es mit `sleep 10` und `always`:
```bash
docker run -d --name forever --restart always alpine sleep 5
```
Beobachte `docker ps`. Die "Up" Zeit ist immer kurz.
</details>

### Aufgabe 2: Der Speicherfresser (OOM Kill)

Wir simulieren eine App, die zu viel RAM frisst.

1. Starte einen Container mit einem Hard Limit von 4MB Ram: `docker run -d --name memory-test --memory="4m" alpine sleep 3600`
2. Versuche, mehr RAM zu verbrauchen (z.B. durch Erzeugen einer riesigen Variable in der Shell oder installiere Packages).
3. Beobachte, was passiert (`docker inspect` -> `State.OOMKilled`).

### Aufgabe 3: Update on the fly

Du hast vergessen, dem Container `memory-test` (aus Aufgabe 2) eine Restart Policy zu geben.
1. Füge nachträglich eine Restart Policy hinzu, OHNE den Container zu recyceln (löschen/neu erstellen).
2. Tipp: `docker update`.
