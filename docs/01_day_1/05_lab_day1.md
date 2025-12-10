---
title: "05 Lab: Day 1 Challenge"
---

## Szenario: Das vernetzte Duo

Dein Job ist es, eine Redis-Datenbank und einen Client bereitzustellen, die miteinander sprechen.
Die Anforderungen deines Teamleiters:
1. Die Datenbank muss in einem **isolierten Netzwerk** laufen.
2. Wir wollen von einem **anderen Container** darauf zugreifen können.
3. Der Redis Port (6379) soll **nicht** nach außen (Host) offen sein.

## Step-by-Step Guide

### 1. Netzwerk erstellen

Erstelle ein Bridge-Netzwerk namens `kian-net`.

<details>
<summary>Lösung</summary>

```bash
docker network create kian-net
```
</details>

### 2. Redis starten

Starte einen Redis Container mit folgenden Eigenschaften:
- Name: `my-redis`
- Netzwerk: `kian-net`
- Detached Mode.

<details>
<summary>Lösung</summary>

```bash
docker run -d \
  --name my-redis \
  --network kian-net \
  redis:alpine
```
</details>

### 3. Daten schreiben

Wir nutzen jetzt einen zweiten Container als "Client". Wir gehen nicht *in* den Redis Container, sondern starten einen neuen `redis:alpine` Container interaktiv, verbinden ihn ins gleiche Netz und nutzen das Tool `redis-cli`, um `my-redis` anzusprechen.

Führe folgenden Befehl im Client-Container aus:
`redis-cli -h my-redis set besucher 1`

<details>
<summary>Lösung (Starten des Clients)</summary>

```bash
docker run -it --rm \
  --network kian-net \
  redis:alpine sh

# Drinnen dann:
# redis-cli -h my-redis set besucher 1
# Output: OK
# exit
```
</details>

### 4. Der Cliffhanger

Lösche den `my-redis` Container (simulierter Absturz).
Starte ihn neu.
Prüfe mit dem Client, ob der Key `besucher` noch da ist.

Spoiler: **Nein**. 😱

:::warning[Daten weg?]
Container sind vergänglich (ephemeral). Wenn sie entfernt werden, verschwinden ihre Daten. Wie wir das lösen (Volumes), ist das erste Thema von Tag 2!
:::

## Aufräumen

Lösche Container und Netzwerk.

```bash
docker rm -f my-redis
docker network rm kian-net
```
