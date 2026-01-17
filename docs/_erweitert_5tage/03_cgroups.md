---
title: "Lab: cgroups Basics"
sidebar_position: 3
---

# Lab: cgroups (Control Groups)

:::info Nur 5-Tage-Schulung
Dieses Modul ist Teil der 5-Tage-Schulung.
:::

cgroups ermöglichen die Ressourcen-Limitierung von Prozessen.

## cgroups v2 prüfen

```bash
# Prüfen ob cgroups v2 aktiv
mount | grep cgroup2

# cgroup-Hierarchie
ls /sys/fs/cgroup/
```

## Mit systemd begrenzen

### CPU begrenzen

```bash
# Temporär einen Service limitieren
sudo systemctl set-property nginx.service CPUQuota=50%

# In der Unit-Datei:
# [Service]
# CPUQuota=50%
```

### Memory begrenzen

```bash
# Temporär
sudo systemctl set-property nginx.service MemoryMax=512M

# In der Unit-Datei:
# [Service]
# MemoryMax=512M
```

## Eigene cgroup erstellen

```bash
# cgroup erstellen
sudo mkdir /sys/fs/cgroup/test

# CPU-Limit (50%)
echo "50000 100000" | sudo tee /sys/fs/cgroup/test/cpu.max

# Memory-Limit (100MB)
echo $((100*1024*1024)) | sudo tee /sys/fs/cgroup/test/memory.max

# Prozess zuweisen
echo $$ | sudo tee /sys/fs/cgroup/test/cgroup.procs
```

## Status prüfen

```bash
# Ressourcen-Nutzung einer cgroup
cat /sys/fs/cgroup/system.slice/nginx.service/cpu.stat
cat /sys/fs/cgroup/system.slice/nginx.service/memory.current

# Alle systemd slices
systemd-cgls
```

## systemd Slices

```
-.slice (root)
├─user.slice (User-Sessions)
├─system.slice (Services)
└─machine.slice (VMs/Container)
```

```bash
# Slice-Limits setzen
sudo systemctl set-property system.slice CPUQuota=80%
```
