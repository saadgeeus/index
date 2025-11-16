#!/bin/bash
# Automated EC2 startup setup: Docker, Docker Compose (plugin), AWS CLI

# Update packages
apt update -y
apt-get update -y
apt upgrade -y
apt-get upgrade -y

# Install dependencies
apt install -y ca-certificates curl gnupg lsb-release unzip

# Add Docker’s official GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

# Install Docker Engine, CLI, and Docker Compose plugin
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Add ubuntu user to docker group
usermod -aG docker $USER && newgrp docker

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
./aws/install

# Verify installation
docker --version
docker compose version
aws --version

# Log completion
echo "EC2 setup complete on $(date)" > /var/log/startup-setup.log
