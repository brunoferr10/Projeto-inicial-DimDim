#!/usr/bin/env bash
set -euo pipefail
: "${PGHOST:?Execute source scripts/00-configurar-ambiente.sh}"
: "${DB_PASSWORD:?Informe a senha na sessão do terminal}"
export PGPASSWORD="$DB_PASSWORD"
cd "$(dirname "$0")/.."
psql -v ON_ERROR_STOP=1 -f script.sql
psql -v ON_ERROR_STOP=1 -c '\dt'
