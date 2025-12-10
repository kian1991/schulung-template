---
title: "01 Private Registry"
---

## Eigene Registry betreiben

Docker Hub ist nett, aber Firmen wollen oft ihre Images nicht öffentlich teilen.
Lösung: Die offizielle Docker Registry (selbst ein Container!).

```bash
[`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) -d -p 5000:5000 --name registry registry:latest
```

Jetzt Images taggen und pushen:

```bash
# 1. Taggen für localhost:5000
[`docker tag`](https://docs.docker.com/reference/cli/docker/image/tag/) my-web-app:latest localhost:5000/my-web-app:latest

# 2. Push it!
[`docker push`](https://docs.docker.com/reference/cli/docker/image/push/) localhost:5000/my-web-app:latest
```

:::warning[Insecure Registry]
Ohne TLS (HTTPS) meckert Docker, wenn du von einem *anderen* Host pushen willst. Du musst die Registry entweder mit Certs absichern oder als "insecure-registry" in der `daemon.json` eintragen.
:::
