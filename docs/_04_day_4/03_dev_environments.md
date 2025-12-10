---
title: "03 Dev Containers"
---

## "Works on my Machine" ist tot

Stell dir vor, du clonst ein Repo, öffnest es in VS Code, drückst einen Knopf und hast:
- Die richtige Node/Python/Go Version.
- Alle Linter & Formatter.
- Die Datenbank läuft schon.
- Du bist sofort produktiv.

Das sind **Dev Containers**.

### Wie funktioniert es?

Du brauchst eine `.devcontainer/devcontainer.json`.
Aber **schreibe die nicht von Hand!**

Nutze die **Dev Containers Extension** in VS Code. Sie generiert dir die Config basierend auf Templates (Node, Python, Go...).

1. `F1` (Command Palette)
2. `Dev Containers: Add Dev Container Configuration Files...`
3. Template wählen.
4. Fertig.

-> [Hier geht's zur Übung](../uebungen/dev_containers/01_vscode.md)

VS Code (mit der "Dev Containers" Extension) liest das, baut den Container und **verbindet sich hinein**.
Dein Editor läuft lokal, aber dein Terminal, Debugger und Filesystem (via Mount) sind im Container.

### Warum Docker?

Es ist Docker unter der Haube!
- Du kannst ein `Dockerfile` angeben.
- Du kannst sogar eine `docker-compose.yml` angeben (z.B. App + Postgres).

### Vorteile

1.  **Onboarding:** Neuer Mitarbeiter clont Repo -> Fertig in 5 Minuten.
2.  **Konsistenz:** Alle nutzen exakt die gleichen Tools-Versionen.
3.  **Sauberkeit:** Kein `npm install` müllt dein Host-System zu.
