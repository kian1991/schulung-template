---
title: "Übung: Size Matters"
---

## Szenario

Du sollst ein Go-Programm deployen. Dein Image ist 800MB groß. Dein Chef ist sauer.
Ziel: < 20MB.

### Das "Fette" Dockerfile

```dockerfile
FROM golang:1.21
WORKDIR /app
COPY main.go .
RUN go build -o myapp main.go
CMD ["./myapp"]
```

(Annahme: `main.go` druckt nur "Hallo").

### Aufgabe

1. Schreibe ein `Dockerfile` mit **Multi-Stage Build**.
2. Nutze `golang:1.21` als Builder.
3. Nutze `alpine` (oder `scratch` für Profis) als Runner.
4. Kopiere nur das Binary.

<details>
<summary>Lösung</summary>

```dockerfile
# Stage 1: Der Bauarbeiter
FROM golang:1.21 AS builder
WORKDIR /app
COPY main.go .
# CGO_ENABLED=0 für statisches Binary (wichtig für scratch/alpine)
RUN CGO_ENABLED=0 go build -o myapp main.go

# Stage 2: Das Produkt
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/myapp .
CMD ["./myapp"]
```

Vergleich:
`docker images` checken.
Golang Image: ~800MB.
Alpine Image: ~15MB.
</details>

### Aufgabe 2: Dev vs. Prod (Target)

Du willst im selben Dockerfile eine "Dev"-Umgebung (mit Go Tools, Debugger) und eine "Prod"-Umgebung (minimal).

1. Ergänze das Dockerfile um eine Stage `dev`, die VOR dem finalen Build steht.
2. Nutze das Argument `--target` beim Build, um nur die Dev-Stage zu bauen.
`docker build --target dev -t myapp:dev .`

### Aufgabe 3: From Scratch

Alpine ist klein (5MB). Aber nichts ist kleiner als Nichts.
1. Ändere die letzte Stage zu `FROM scratch`.
2. Baue das Image. Es sollte < 2MB sein.
3. Funktioniert es? (Hinweis: Zertifikate/Timezones fehlen evtl., aber für "Hello World" reicht es).
