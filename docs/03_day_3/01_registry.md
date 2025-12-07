---
title: "01 Private Registry"
---

## Eigene Registry betreiben

Docker Hub ist nett, aber Firmen wollen oft ihre Images nicht öffentlich teilen.
Lösung: Die offizielle Docker Registry (selbst ein Container!).

```bash
docker run -d -p 5000:5000 --name registry registry:2
```

Jetzt Images taggen und pushen:

```bash
# 1. Taggen für localhost:5000
docker tag my-web-app:v1 localhost:5000/my-web-app:v1

# 2. Push it!
docker push localhost:5000/my-web-app:v1
```

:::warning[Insecure Registry]
Ohne TLS (HTTPS) meckert Docker, wenn du von einem *anderen* Host pushen willst. Du musst die Registry entweder mit Certs absichern oder als "insecure-registry" in der `daemon.json` eintragen.
:::
