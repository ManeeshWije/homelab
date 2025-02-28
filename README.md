# Kubernetes Homelab

> This homelab is heavily inspired by https://github.com/WolfeCub/home-ops

### Hardware

- Raspberry Pi 5 with PoE+NVME hat (master and worker node)
- **Coming Soon**:
    -   Pi 5 with SATA hat to act as a simple NAS
        - OpenMediaVault
        - Rsync for mirroring
        - Syncthing
    -   More Pi's to act as worker nodes

### Software

- [K3s](https://k3s.io/) is the lightweight kubernetes distribution
- [Flux](https://fluxcd.io/) implements GitOps by continuously syncing the cluster state with the repository
- [Longhorn](https://longhorn.io/) for storage across nodes
- [kube-vip](https://kube-vip.io/) provides VIP and load balancing capabilities
- [Traefik](https://traefik.io/traefik/) acts as both a reverse proxy and a LoadBalancer for handling ingress traffic
- [cert-manager](https://cert-manager.io/) automatically provisions SSL certificates from Let’s Encrypt for secure service access
- [SOPS](https://github.com/mozilla/sops) manages and encrypts cluster secrets
