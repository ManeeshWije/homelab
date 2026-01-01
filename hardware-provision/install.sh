#!/bin/bash

if ! command -v k3sup &> /dev/null; then
    echo "k3sup not found. Installing..."
    curl -sLS https://get.k3sup.dev | sh
    sudo install k3sup /usr/local/bin/
fi

read -rp "Is this the first node in the cluster? (yes/no): " FIRST_NODE

if [[ "$FIRST_NODE" == "yes" ]]; then
    read -rp "Enter the IP address of this node: " IP
    read -rp "Enter the TLS SAN (e.g., domain or additional IP): " TLS_SAN
    read -rp "Enter the username for SSH access: " USERNAME

    ssh-copy-id "$USERNAME@$IP"

    k3sup install \
      --ip "$IP" \
      --tls-san "$TLS_SAN" \
      --cluster \
      --k3s-channel latest \
      --k3s-extra-args "--disable servicelb --disable traefik" \
      --ssh-key "$HOME/.ssh/id_ed25519" \
      --user "$USERNAME" \
      --local-path "$HOME/.kube/config" \
      --merge \

    if [[ -z "${GITHUB_TOKEN}" ]]; then
      read -rp "GitHub PAT: " GITHUB_TOKEN
      export GITHUB_TOKEN
    fi

    helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
      --namespace flux-system \
      --create-namespace

    kubectl apply -f flux-instance.yaml 

    if [[ -z "${KEY_FP}" ]]; then
      read -rp "GPG Key Fingerprint: " KEY_FP
    fi

    gpg --export-secret-keys --armor "${KEY_FP}" | \
      kubectl create secret generic sops-gpg \
      --namespace=flux-system \
      --from-file=sops.asc=/dev/stdin
else
    echo "BEFORE YOU ADD NODES, ENSURE KUBE-VIP IS SETUP FIRST"
    read -rp "Enter the IP address of this node: " IP
    read -rp "Enter the server IP address: " SERVER_IP
    read -rp "Enter the username for SSH access: " USERNAME
    
    k3sup join \
      --ip "$IP" \
      --server-ip "$SERVER_IP" \
      --server \
      --k3s-channel latest \
      --user "$USERNAME"
fi

