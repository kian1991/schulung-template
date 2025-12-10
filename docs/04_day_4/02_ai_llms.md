---
title: "02 Local AI & LLMs"
---

## KI ohne Cloud

Mit Docker ist es extrem einfach, mächtige LLMs (Large Language Models) wie Llama 3 oder Mistral lokal laufen zu lassen.

### Ollama

Ollama hat sich als Standard für lokales LLM-Hosting etabliert.

```bash
[`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) -d --name ollama -p 11434:11434 ollama/ollama
```

Jetzt kannst du Modelle ziehen (via `docker exec`):

```bash
[`docker exec`](https://docs.docker.com/reference/cli/docker/container/exec/) -it ollama ollama run llama3
```

### GPU Support

KI auf der CPU ist langsam. Wenn du eine NVIDIA Karte hast, nutze das **NVIDIA Container Toolkit**.

```bash
docker run -d --gpus=all ...
```

Das reicht die Grafikkarte in den Container durch. Keine CUDA-Installation auf dem Host nötig!

### Web UI

Niemand will KI im Terminal nutzen. Wir brauchen ein ChatGPT-Feeling.
**Open WebUI** ist ein beliebtes Frontend, das sich mit Ollama verbindet.

Das perfekte Docker Compose Setup:

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
      - "3000:8080"
    depends_on:
      - ollama

volumes:
  ollama_data:
```

Einfacher geht es nicht. Ein `docker compose up` und du hast dein eigenes, datenschutzfreundliches ChatGPT.
