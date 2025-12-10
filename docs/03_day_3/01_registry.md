---
title: "01 Private Registry"
---

## Die Docker Registry

Docker Hub ist nett, aber Firmen wollen ihre Images oft nicht öffentlich teilen.
Und manchmal will man auch volle Kontrolle (oder Air-Gapped Environments).

Die Lösung: Eine eigene Registry. Überraschung: Das ist auch nur ein Container!

### Starten der Registry

```bash
docker run -d \
  -p 5000:5000 \
  --restart=always \
  -v registry_data:/var/lib/registry \
  --name registry \
  registry:3
```
Jetzt läuft eine leere Registry auf `localhost:5000`.

### Images hochladen (Push)

Damit Docker weiß, wohin das Image soll, müssen wir den Namen anpassen (Taggen).
Das Format ist immer: `REGISTRY_URL/IMAGE_NAME:TAG`.

1. **Taggen:**
   ```bash
   # Wir nehmen ein lokales Image und geben ihm den neuen Namen
   docker tag nginx:alpine localhost:5000/my-custom-nginx:v1
   ```
2. **Pushen:**
   ```bash
   docker push localhost:5000/my-custom-nginx:v1
   ```

### Images herunterladen (Pull)

Auf einem anderen Server (oder nachdem du das lokale Image gelöscht hast):
```bash
docker pull localhost:5000/my-custom-nginx:v1
```

---

## Das Problem mit HTTPS (Insecure Registry)

Docker verlangt **zwingend** HTTPS für Registries.
`localhost` ist die einzige Ausnahme.
Wenn du deine Registry auf einem Server (z.B. `192.168.1.50`) betreibst und darauf zugreifen willst, bekommst du einen Fehler:
`http: server gave HTTP response to HTTPS client`

**Lösung 1 (Die Saubere):**
Besorge dir ein TLS Zertifikat (Let's Encrypt) und konfiguriere die Registry damit.

**Lösung 2 (Die Schnelle):**
Erlaube Docker, unsichere Registries zu nutzen.
Editiere `/etc/docker/daemon.json` (Linux) oder in Docker Desktop Settings -> Docker Engine:

```json
{
  "insecure-registries" : ["192.168.1.50:5000"]
}
```
Dann Docker neustarten.
