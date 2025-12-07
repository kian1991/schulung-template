---
title: "Übung: Read-Only Breakout"
---

## Szenario

Sicherheit ist wichtig. Wir wollen einen Container starten, der **nirgendwo** schreiben darf (außer in `/tmp`).

### Aufgabe

1. Starte einen `alpine` Container, der ein **Read-Only** Filesystem hat.
2. Versuche, eine Datei in `/root/hack.txt` zu erstellen. Es muss fehlschlagen.
3. Erlaube ihm aber, in `/tmp` zu schreiben (dazu brauchst du ein `tmpfs` oder Volume).

<details>
<summary>Lösung</summary>

```bash
# 1. Starten mit Read-Only
docker run --rm --read-only -it alpine sh

# Test:
touch /root/hack.txt
# -> "Read-only file system" (Erfolg!)

# 2. Mit tmpfs für /tmp
docker run --rm --read-only --tmpfs /tmp -it alpine sh

# Test:
touch /tmp/legal.txt
# -> Funktioniert!
```

dies ist ein sehr mächtiges Sicherheits-Feature für Stateless Apps!
</details>

### Aufgabe 2: Entwaffnet (Drop Capabilities)

Root darf "alles". Wir wollen dem Container die Zähne ziehen.
1. Starte einen Container und versuche, die Systemzeit zu ändern (`date -s "12:00"`). Das *sollte* eh verboten sein (default profile).
2. Versuche `ping google.com`. Das geht (CAP_NET_RAW).
3. Starte den Container neu mit `--cap-drop=ALL`. Geht Ping noch?
4. Füge *nur* `NET_ADMIN` (oder was Ping braucht?) wieder hinzu. Experimentiere.

### Aufgabe 3: Pseudos

Führe `top` (oder `ps aux`) auf deinem **Host** aus (nicht im Container). Suche den Prozess deines Containers (z.B. `sleep 3600`).
1. Welchem User gehört der Prozess auf dem Host? (Wahrscheinlich Root!).
2. Das ist gefährlich. Wenn er ausbricht, ist er Root auf dem Host.
3. Recherchiere: Wie startest du den Container als nicht-root (`user: 1000:1000`)?
4. Prüfe erneut am Host.
