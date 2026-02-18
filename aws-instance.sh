#!/bin/bash

set -e

echo "==== System update ===="
sudo apt update -y
sudo apt upgrade -y

echo "==== Required packages ===="
sudo apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  unzip \
  software-properties-common

echo "==== Docker install ===="
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "==== Docker Compose plugin install ===="
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "==== docker-compose legacy command enable ===="
sudo ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

echo "==== Add current user to docker group ===="
sudo usermod -aG docker $USER && newgrp docker

echo "==== Azure CLI install ===="
# Microsoft ka official debian install script
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

echo "==== AWS CLI v2 install ===="
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "==== MySQL Client install ===="
# MySQL server nahi, sirf client install ho raha hai commands ke liye
sudo apt install -y mysql-client

echo "==== Versions check ===="
docker --version
docker compose version
docker-compose --version
az --version | head -n 1
aws --version
mysql --version

echo "==== Setup complete ===="
echo "=========================================================="
echo "IMPORTANT: Logout & login dobara karein taake Docker group settings apply hon."
echo "Ab aap 'az login' aur 'mysql -h host -u user -p' commands use kar sakte hain."
echo "=========================================================="
