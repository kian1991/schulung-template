---
title: "03. Docker & Deployment"
---

Einer der größten Vorteile von Rust: Du deployest **ein Binary**.
Keine `node_modules`, keine `package.json`, keine Runtime auf dem Server.

## The Release Profile

```bash
cargo build --release
```

Das dauert länger, aber der Compiler optimiert aggressiv.
Das Binary liegt in `target/release/my-app`.

## Multi-Stage Builds

Wir wollen nicht den Compiler (1GB+) im Production Image haben. Wir nutzen **Multi-Stage Builds**.

```dockerfile
# Stage 1: Builder
# Wir nehmen ein Image mit Rust und Cargo
FROM rust:1.80 as builder
WORKDIR /app
COPY . .
# Baue das Binary
RUN cargo build --release

# Stage 2: Runtime
# Wir nehmen ein Debian-Slim Image (klein, aber mit libc)
FROM debian:bookworm-slim
WORKDIR /app
# Kopiere NUR das Binary aus Stage 1
COPY --from=builder /app/target/release/my-app .

# Port exposen
EXPOSE 3000
CMD ["./my-app"]
```

## Distroless (Next Level)

Wenn wir keine Shell, kein apt, kein gar nichts brauchen (Security!), nehmen wir **Distroless** (von Google).

Dafür muss unser Binary aber **statisch gelinkt** sein (kein `libc` dependency).
In Rust nutzen wir dafür oft `musl`.

```bash
rustup target add x86_64-unknown-linux-musl
cargo build --release --target x86_64-unknown-linux-musl
```

Und das Dockerfile:

```dockerfile
FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/my-app /
CMD ["/my-app"]
```

Ergebnis: Ein Image, das **< 20 MB** groß ist und nur deinen Code enthält. Keine Angriffsfläche im OS.

## Docker Ignore

Vergiss nicht `.dockerignore`!

```
target/
.git/
Dockerfile
```

---

## Zusammenfassung
1. **`--release`** für Production Builds.
2. **Multi-Stage** Dockerfiles trennen Build-Environment von Runtime.
3. **Distroless** Images sind extrem klein und sicher.
4. **Musl** erlaubt statisches Linken (Zero Dependencies).
