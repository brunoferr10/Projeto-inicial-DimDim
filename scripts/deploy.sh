#!/usr/bin/env bash
set -euo pipefail
: "${DB_PASSWORD:?Configure DB_PASSWORD como variável secreta}"
: "${IMAGE_TAG:?Configure IMAGE_TAG com o ID do Build}"
[[ "$IMAGE_TAG" =~ ^[a-zA-Z0-9_.-]+$ ]] || { echo "Tag inválida"; exit 1; }
cd "$(dirname "$0")/.."
# Um nome fixo preserva o volume entre releases e pastas diferentes do agente.
export COMPOSE_PROJECT_NAME=dimdim
docker compose config --quiet
docker compose build app
docker compose up -d --wait --wait-timeout 180
for n in {1..60}; do
 if curl -fsS http://localhost:8080/actuator/health > /dev/null; then
  curl -fsS http://localhost:8080/api/versao; echo; exit 0
 fi
 sleep 3
done
echo "Aplicação não ficou saudável. Consulte os logs na VM." >&2
exit 1
