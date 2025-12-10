---
title: "Übung 13: Dev Containers"
---

## Szenario

Du steigst in ein neues Projekt ein. Früher: "Installier Node, installier Prettier, konfigurier ESLint...".
Heute: "Öffne das Repo in Container."

### Aufgabe 1: Der Wizard

Wir wollen eine Entwicklungsumgebung für **Node.js & TypeScript** erstellen.

1.  Erstelle einen leeren Ordner `my-dev-project` und öffne ihn in VS Code.
2.  Drücke `F1` (oder `Cmd+Shift+P`).
3.  Suche nach: `Dev Containers: Add Dev Container Configuration Files...`.
4.  Wähle im Wizard:
    -   **Template:** `Node.js & TypeScript` (suche danach).
    -   **Version:** `22` (Bookworm).
    -   **Features:** Suche nach "Prettier" und wähle `ghcr.io/devcontainers-community/npm-features/prettier:1`.
5.  Bestätige.

### Aufgabe 2: Reopen in Container

VS Code fragt dich jetzt (unten rechts): "Folder contains a Dev Container configuration file. Reopen in Container?".
Klicke **Reopen in Container**.

(Falls nicht: `F1` -> `Dev Containers: Reopen in Container`).

### Aufgabe 3: Der Check

Wenn VS Code fertig geladen hat (sieh unten links das grüne Icon):
1.  Öffne das Terminal (in VS Code).
2.  Tippe `node -v`. Es sollte Version 22.x sein (selbst wenn du lokal gar kein Node hast!).
3.  Tippe `ls -la`. Du bist im Container!

### Lösung (Erwartete .devcontainer/devcontainer.json)

Der Wizard sollte etwa folgende Datei erstellt haben:

```jsonc
{
	"name": "Node.js & TypeScript",
	// Or use a Dockerfile or Docker Compose file. More info: https://containers.dev/guide/dockerfile
	"image": "mcr.microsoft.com/devcontainers/typescript-node:1-22-bookworm",
	"features": {
		"ghcr.io/devcontainers-community/npm-features/prettier:1": {}
	}

	// Features to add to the dev container. More info: https://containers.dev/features.
	// "features": {},

	// Use 'forwardPorts' to make a list of ports inside the container available locally.
	// "forwardPorts": [],

	// Use 'postCreateCommand' to run commands after the container is created.
	// "postCreateCommand": "yarn install",

	// Configure tool-specific properties.
	// "customizations": {},

	// Uncomment to connect as root instead. More info: https://aka.ms/dev-containers-non-root.
	// "remoteUser": "root"
}
```
