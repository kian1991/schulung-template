---
title: "Übung 12: Private ChatGPT"
---

## Szenario

Du willst vertrauliche Firmendaten in eine KI eingeben. ChatGPT ist verboten.
Baue eine lokale Lösung mit Docker.

### Aufgabe 1: Der Stack

Erstelle eine `docker-compose.yml`.

1.  **Service 1: Ollama**
    -   Image: `ollama/ollama`
    -   Ports: 11434 expose.
    -   Volume: `ollama_data:/root/.ollama` (Modelle sind groß, wir wollen sie nicht verlieren!).
2.  **Service 2: Open WebUI**
    -   Image: `ghcr.io/open-webui/open-webui:main`
    -   Ports: 3000 am Container auf 8080 am Host mappen.
    -   Einstellung: `OLLAMA_BASE_URL=http://ollama:11434` (Warum `http://ollama`? Weil Docker DNS!).

### Aufgabe 2: Starten & Laden

1.  Starte den Stack: [`docker compose up`](https://docs.docker.com/reference/cli/docker/compose/up/) `-d`
2.  Öffne `http://localhost:8080`.
3.  Erstelle einen Admin Account (ist nur lokal).
4.  Geh in die Settings -> Models. Ziehe dir ein kleines Modell wie `llama3:8b` oder `phi3` (Microsofts kleines Modell, geht schnell).

### Aufgabe 3: Chatten

1.  Frag die KI: "Warum sind Container besser als VMs?".
2.  Beobachte deine CPU-Auslastung (`docker stats` oder Activity Monitor).
3.  Optional: Wenn du eine Nvidia GPU hast, reiche sie im Compose File durch (`deploy: resources: reservations: devices: ...`).

<details>
<summary>Lösung (Compose)</summary>

```yaml

services:
  ollama:
    image: ollama/ollama
    volumes:
      - ollama_data:/root/.ollama
    ports:
      - "11434:11434"

  webui:
    image: ghcr.io/open-webui/open-webui:main
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    ports:
      - "8080:8080"
    volumes:
      - webui_data:/app/backend/data
    depends_on:
      - ollama

volumes:
  ollama_data:
  webui_data:
```
</details>
