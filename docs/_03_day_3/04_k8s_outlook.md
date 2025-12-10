---
title: "04 Kubernetes Outlook"
---

## Kubernetes

Docker Compose ist super für einen Server.
Was aber, wenn du 100 Server hast? Wenn Server A brennt, sollen die Container automatisch auf Server B wandern?

Willkommen bei **Kubernetes (K8s)**.

### Das Konzept

K8s abstrahiert die gesamte Hardware weg. Du wirfst deine Container (eingepackt in **Pods**) in den Cluster, und K8s entscheidet, wo sie laufen.

- **Pod:** Kleinste Einheit. Ein oder mehrere Container (die sich Storage/Netzwerk teilen).
- **Deployment:** "Ich will immer 3 Replicas meines Pods haben." K8s sorgt dafür (Self-Healing).
- **Service:** Der Loadbalancer vor den Pods.

:::info[Lerne ich das heute?]
Nein. K8s ist ein eigenes 3-Tages-Training. Aber alles, was du über Container, Images und Volumes gelernt hast, ist die Basis für K8s. Ohne Docker Wissen ist K8s unverständlich.
:::
