---
title: "Lab: Services verwalten"
sidebar_position: 2
---

# Lab: Services verwalten

:::info Zeitrahmen
**Dauer:** ca. 1,25 Stunden
:::

---

## Aufgabe 1: Service-Status prüfen

1. Zeige den Status von SSH
2. Zeige alle laufenden Services
3. Zeige fehlgeschlagene Services

<details>
<summary>Lösung anzeigen</summary>

```bash
# SSH-Status
systemctl status ssh
# oder sshd je nach System

# Laufende Services
systemctl list-units --type=service --state=running

# Fehlgeschlagen
systemctl --failed
```

</details>

---

## Aufgabe 2: Service steuern

1. Stoppe nginx
2. Starte nginx
3. Restarte nginx
4. Prüfe den Status nach jeder Aktion

<details>
<summary>Lösung anzeigen</summary>

```bash
# nginx installieren falls nötig
sudo apt install nginx

# Stoppen
sudo systemctl stop nginx
systemctl status nginx
# Active: inactive (dead)

# Starten
sudo systemctl start nginx
systemctl status nginx
# Active: active (running)

# Restart
sudo systemctl restart nginx
systemctl status nginx
# Uptime wurde zurückgesetzt
```

</details>

---

## Aufgabe 3: Boot-Verhalten konfigurieren

1. Deaktiviere nginx beim Boot
2. Prüfe den Status
3. Aktiviere wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# Beim Boot deaktivieren
sudo systemctl disable nginx

# Status prüfen
systemctl is-enabled nginx
# disabled

systemctl status nginx
# Loaded: loaded (/lib/systemd/system/nginx.service; disabled; ...)

# Wieder aktivieren
sudo systemctl enable nginx
systemctl is-enabled nginx
# enabled

# Aktivieren UND starten
sudo systemctl enable --now nginx
```

</details>

---

## Aufgabe 4: Logs mit journalctl

1. Zeige Logs von nginx
2. Zeige Logs seit dem letzten Boot
3. Folge den Logs live

<details>
<summary>Lösung anzeigen</summary>

```bash
# nginx-Logs
journalctl -u nginx

# Seit letztem Boot
journalctl -u nginx -b

# Letzte 50 Zeilen
journalctl -u nginx -n 50

# Live folgen
journalctl -u nginx -f
# In anderem Terminal: sudo systemctl restart nginx
# Ctrl+C zum Beenden

# Nur Fehler
journalctl -u nginx -p err
```

</details>

---

## Aufgabe 5: Service maskieren

1. Maskiere einen Service (z.B. cups-browsed)
2. Versuche ihn zu starten
3. Demaskiere wieder

<details>
<summary>Lösung anzeigen</summary>

```bash
# Maskieren
sudo systemctl mask cups-browsed

# Start-Versuch
sudo systemctl start cups-browsed
# Failed to start cups-browsed.service: Unit cups-browsed.service is masked.

# Status
systemctl status cups-browsed
# Loaded: masked (Reason: Unit cups-browsed.service is masked.)

# Demaskieren
sudo systemctl unmask cups-browsed
```

</details>

---

## Aufgabe 6: Boot-Zeit analysieren

1. Analysiere die Boot-Zeit
2. Finde die langsamsten Services
3. Zeige den kritischen Pfad

<details>
<summary>Lösung anzeigen</summary>

```bash
# Gesamte Boot-Zeit
systemd-analyze
# Startup finished in ... kernel + ... userspace = ...

# Langsamste Services
systemd-analyze blame | head -10

# Kritischer Pfad
systemd-analyze critical-chain

# Grafik erstellen (optional)
systemd-analyze plot > ~/boot.svg
# Öffnen mit Browser oder Bildbetrachter
```

</details>

---

## Aufgabe 7: Abhängigkeiten anzeigen

Zeige die Abhängigkeiten von nginx:

<details>
<summary>Lösung anzeigen</summary>

```bash
# Was nginx braucht
systemctl list-dependencies nginx

# Was von nginx abhängt
systemctl list-dependencies nginx --reverse

# Alle Details
systemctl show nginx
```

</details>

---

## Zusammenfassung

Du hast gelernt:
- Services starten, stoppen, neustarten
- Boot-Verhalten mit enable/disable steuern
- Services mit mask/unmask sperren
- Logs mit journalctl analysieren
- Boot-Zeit analysieren

---

Weiter zum [Lab: Eigene Service-Unit](./03_lab_custom_service.md)!
