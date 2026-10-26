#!/usr/bin/env bash
set -euo pipefail
docker exec "$(docker ps -q --filter label=com.docker.compose.project=dimdim --filter label=com.docker.compose.service=db)" \
 psql -U dimdim -d dimdim -c 'SELECT * FROM clientes ORDER BY id;' -c 'SELECT * FROM pedidos ORDER BY id;'
