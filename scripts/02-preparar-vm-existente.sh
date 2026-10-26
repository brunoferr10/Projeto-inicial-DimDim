#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-v2 openjdk-17-jdk maven git curl unzip python3 postgresql-client
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
echo "Saia do SSH e entre de novo antes de usar Docker ou instalar o agente."
echo "Confira também o Azure CLI: az version. Instalação descrita no README."
