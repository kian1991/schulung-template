---
title: "Übung 11: Dein eigener MCP Server"
---

## Szenario

Wir bauen einen minimalen MCP Server, der uns die aktuelle Uhrzeit in verschiedenen Zeitzonen gibt.
Ziel: Diesen Server in Docker laufen lassen und via Stdio ansprechen.

### Aufgabe 1: Das Skript (Theorie)

`docs/assets/time-mcp/server.py` würde so aussehen (musst du nicht schreiben, nur verstehen):

```python
# Pseudo-Code
import sys
# Liest von Stdin (JSON-RPC Request)
# Berechnet Zeit
# Schreibt auf Stdout (JSON-RPC Response)
```

### Aufgabe 2: Dockerfile schreiben

Erstelle ein Dockerfile für einen Python-basierten MCP Server.

1.  Base: `python:slim`
2.  Workdir: `/app`
3.  Dependencies: `pip install mcp` (hypothetisch, oder was das Framework braucht)
4.  Copy Script.
5.  **Wichtig:** `ENTRYPOINT ["python", "server.py"]`

### Aufgabe 3: Der Testlauf

Da wir keinen MCP Client (wie Claude Desktop) griffbereit haben, simulieren wir ihn.

1.  Baue das Image: [`docker build`](https://docs.docker.com/reference/cli/docker/image/build/) `-t time-mcp .`
2.  Starte es interaktiv: [`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) `-i time-mcp`
3.  Tippe (oder kopiere) einen validen JSON-RPC Request hinein (wenn du das Format kennst).
4.  Alternativ: Prüfe nur, ob es startet und nicht crasht.

### Aufgabe 4: Integration (Gedankenexperiment)

Wie würdest du das in Claude Desktop einbinden?
Config File `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "time": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "time-mcp"]
    }
  }
}
```

Warum ist das genial? Du musstest auf deinem Host kein Python installieren!
