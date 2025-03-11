#!/bin/bash
set -e

echo "🧰 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing basic utilities..."
sudo apt install -y \
  ansible \
  git \
  curl \
  wget \
  python3-pip \
  unzip \
  htop \
  net-tools \
  apt-transport-https \
  ca-certificates \
  gnupg \
  software-properties-common \
  conntrack

echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker "$USER"

echo "🐙 Installing Docker Compose..."
sudo pip3 install docker-compose

echo "☸️ Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client || echo "✅ kubectl installed."

echo "⛵ Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "☸️ Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "🚀 Starting Minikube (with --driver=none)..."
sudo minikube start --driver=none

echo "🧱 Installing Terraform..."
T_VERSION="1.6.6"
wget https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip
unzip terraform_${T_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${T_VERSION}_linux_amd64.zip
terraform -v

echo "📄 Enabling terraform autocomplete..."
terraform -install-autocomplete

echo "📄 Installing terraform-docs..."
curl -sSLo terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.17.0/terraform-docs-v0.17.0-linux-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
sudo mv terraform-docs /usr/local/bin/
rm terraform-docs.tar.gz

echo "✅ Done! You now have a full DevOps lab installed! 🎉"
echo "🟢 Run 'newgrp docker' or restart your terminal to apply Docker group changes."
