#!/usr/bin/env bash
set -euo pipefail
: "${PGHOST:?Execute source scripts/00-configurar-ambiente.sh}"
: "${PGPASSWORD:?Exporte PGPASSWORD na sessão atual}"
psql -v ON_ERROR_STOP=1 -f "$(dirname "$0")/../docs/consultas-evidencia.sql"
