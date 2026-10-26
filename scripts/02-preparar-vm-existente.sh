#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-v2 openjdk-17-jdk maven git curl unzip
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
echo "Saia do SSH e entre de novo antes de usar Docker ou instalar o agente."
