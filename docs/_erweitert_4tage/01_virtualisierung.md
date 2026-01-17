---
title: Virtualisierung (Theorie)
sidebar_position: 1
---

# Virtualisierung - Überblick

:::info Nur 4-Tage-Schulung
Dieses Modul ist Teil der 4-Tage-Schulung.
:::

## Was ist Virtualisierung?

Virtualisierung ermöglicht es, mehrere virtuelle Maschinen (VMs) auf einer physischen Hardware zu betreiben.

```
┌─────────────────────────────────────────────────┐
│                 VMs (Gäste)                      │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐         │
│  │  VM 1   │  │  VM 2   │  │  VM 3   │         │
│  │ Ubuntu  │  │ CentOS  │  │ Windows │         │
│  └─────────┘  └─────────┘  └─────────┘         │
├─────────────────────────────────────────────────┤
│              Hypervisor                          │
│         (KVM, VMware, Hyper-V)                   │
├─────────────────────────────────────────────────┤
│           Host-Betriebssystem                    │
├─────────────────────────────────────────────────┤
│              Hardware                            │
└─────────────────────────────────────────────────┘
```

## Hypervisor-Typen

### Typ 1: Bare-Metal

Läuft direkt auf der Hardware:
- **VMware ESXi**
- **Microsoft Hyper-V**
- **KVM** (in Linux-Kernel integriert)

### Typ 2: Hosted

Läuft auf einem Host-Betriebssystem:
- **VirtualBox**
- **VMware Workstation**
- **Parallels**

## KVM/QEMU unter Linux

Linux hat mit **KVM** (Kernel-based Virtual Machine) einen eingebauten Hypervisor:

```bash
# KVM-Unterstützung prüfen
egrep -c '(vmx|svm)' /proc/cpuinfo
# > 0 = KVM wird unterstützt

# KVM installieren
sudo apt install qemu-kvm libvirt-daemon-system virt-manager

# Benutzer zur Gruppe hinzufügen
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER

# Status prüfen
sudo systemctl status libvirtd
```

### libvirt

**libvirt** ist eine Abstraktionsschicht für verschiedene Virtualisierungstechnologien:

```bash
# VMs auflisten
virsh list --all

# VM starten
virsh start vm-name

# VM stoppen
virsh shutdown vm-name

# Verbinden (Konsole)
virsh console vm-name
```

### virt-manager

Grafische Oberfläche für KVM/libvirt:

```bash
virt-manager
```

## VMs vs. Container

| Aspekt | VMs | Container |
|--------|-----|-----------|
| Isolation | Komplett | Prozess-Level |
| Overhead | Hoch (eigenes OS) | Niedrig |
| Startzeit | Minuten | Sekunden |
| Ressourcen | GB pro VM | MB pro Container |
| Portabilität | Images groß | Images klein |

## Wann was nutzen?

**VMs:**
- Verschiedene Betriebssysteme
- Vollständige Isolation
- Legacy-Anwendungen

**Container:**
- Gleiche Anwendung mehrfach
- Schnelles Deployment
- Microservices

---

Weiter zu [Container mit Docker](./02_docker.md)!
