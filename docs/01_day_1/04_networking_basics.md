---
title: "04 Networking Basics"
---

## Die Default Bridge

Wenn du `docker run` ohne Netzwerk-Option ausführst, landet der Container im Standard `bridge` Netzwerk.

```bash
docker network ls
```

Warum ist das schlecht?
1. **Kein DNS Scaling:** Container müssen sich über IP-Adressen ansprechen (die ändern sich ständig!).
2. **Isolation:** Jeder Container im Standard-Netz kann jeden "sehen".

## User Defined Networks

Wir erstellen eigene Netzwerke für unsere Apps.

```bash
docker network create my-app-net
```

Jetzt starten wir zwei Container in diesem Netzwerk:

```bash
# 1. Datenbank starten
docker run -d --name my-db --network my-app-net mongo

# 2. App starten (wir simulieren das mit einem kleinen Alpine Image)
docker run -it --rm --network my-app-net alpine sh
```

Magie passiert jetzt im Alpine Container:

```bash
ping my-db
```

Es funktioniert! Docker hat einen internen DNS Server, der den Containernamen `my-db` zur korrekten internen IP auflöst.

### Port Mapping vs. Internal Network

Wichtige Unterscheidung:
- **Port Mapping (`-p 8080:80`)**: Öffnet die Tür vom *Host* zum Container. Für Zugriff von außen (Browser).
- **Internal Network (`--network`)**: Kommunikation *zwischen* Containern. Die Ports müssen hierfür *nicht* nach außen gemappt werden! Die DB muss ihren Port 27017 intern offen haben, aber wir brauchen kein `-p 27017:27017` am Host, wenn nur die App darauf zugreifen soll.

:::danger[Security]
Mappe Datenbank-Ports (wie 3306, 5432, 27017) niemals mit `-p` auf `0.0.0.0` (Standard), wenn du es nicht musst. Hacker scannen das Internet danach. Besser: nur in `localhost` (`-p 127.0.0.1:3306:3306`) oder gar nicht mappen und nur internes Netzwerk nutzen.
:::

## /etc/hosts

Docker manipuliert die `/etc/hosts` im Container für uns. Schau mal rein:

```bash
cat /etc/hosts
```

Du siehst die eigene Container ID, die auf die lokale IP mappt. Das macht Docker automatisch.
