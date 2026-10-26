#!/usr/bin/env bash
set -euo pipefail
: "${BASE_URL:?Execute source scripts/00-configurar-ambiente.sh}"
curl -fsS "$BASE_URL/actuator/health"; echo
curl -fsS "$BASE_URL/api/versao"; echo
curl -fsS "$BASE_URL/api/clientes"; echo
curl -fsS "$BASE_URL/api/pedidos"; echo
