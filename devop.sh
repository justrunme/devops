#!/bin/bash
set -e

# 🕒 Fix system time (without hwclock dependency)
echo "🕒 Syncing system time..."
sudo timedatectl set-ntp true
sudo timedatectl set-timezone Europe/Berlin

# Proceed with updates
echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing base packages..."
sudo apt install -y \
  git curl wget unzip htop net-tools \
  ca-certificates apt-transport-https software-properties-common \
  python3-pip python3-venv zsh fonts-powerline locales gnupg lsb-release gnupg2 \
  conntrack fzf bat tree ncdu build-essential python3-dev libyaml-dev

# Git global config
if ! git config --global user.name &> /dev/null; then
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
fi

# Ansible
if ! command -v ansible &> /dev/null; then
  echo "🧰 Installing Ansible..."
  sudo apt install -y ansible
else
  echo "✅ Ansible already installed."
fi

# Docker
if ! command -v docker &> /dev/null; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com | sudo bash
  sudo usermod -aG docker $USER
else
  echo "✅ Docker already installed."
fi

# docker-compose (official binary)
if ! command -v docker-compose &> /dev/null; then
  echo "🐙 Installing docker-compose (GitHub release)..."
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.4/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "✅ docker-compose already installed."
fi

# kubectl
if ! command -v kubectl &> /dev/null; then
  echo "☸️ Installing kubectl..."
  curl -LO "https://dl.k8s.io/release/v1.30.1/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
else
  echo "✅ kubectl already installed."
fi

# Helm
if ! command -v helm &> /dev/null; then
  echo "⛵ Installing Helm..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "✅ Helm already installed."
fi

# Minikube
if ! command -v minikube &> /dev/null; then
  echo "☸️ Installing Minikube..."
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
  rm minikube-linux-amd64
else
  echo "✅ Minikube already installed."
fi

# Terraform
if ! command -v terraform &> /dev/null; then
  echo "🧱 Installing Terraform..."
  T_VERSION="1.6.6"
  wget https://releases.hashicorp.com/terraform/${T_VERSION}/terraform_${T_VERSION}_linux_amd64.zip
  unzip terraform_${T_VERSION}_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm terraform_${T_VERSION}_linux_amd64.zip
else
  echo "✅ Terraform already installed."
fi

# terraform-docs
if ! command -v terraform-docs &> /dev/null; then
  echo "📄 Installing terraform-docs..."
  curl -sSLo terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.17.0/terraform-docs-v0.17.0-linux-amd64.tar.gz
  tar -xzf terraform-docs.tar.gz
  sudo mv terraform-docs /usr/local/bin/
  rm terraform-docs.tar.gz
else
  echo "✅ terraform-docs already installed."
fi

# lazygit (via GitHub release)
if ! command -v lazygit &> /dev/null; then
  echo "📥 Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f4)
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm lazygit lazygit.tar.gz
else
  echo "✅ lazygit already installed."
fi

# k9s
if ! command -v k9s &> /dev/null; then
  echo "📥 Installing k9s..."
  curl -LO https://github.com/derailed/k9s/releases/download/v0.32.4/k9s_Linux_amd64.tar.gz
  tar -xzf k9s_Linux_amd64.tar.gz
  sudo mv k9s /usr/local/bin/
  rm k9s_Linux_amd64.tar.gz
else
  echo "✅ k9s already installed."
fi

# AWS CLI
if ! command -v aws &> /dev/null; then
  echo "☁️ Installing AWS CLI v2..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
else
  echo "✅ AWS CLI already installed."
fi

echo "✅ Setup complete. Restart your terminal or run 'exec zsh'."
echo "💡 Run 'p10k configure' to personalize your Powerlevel10k prompt."
