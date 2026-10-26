#!/usr/bin/env bash
# Use: source scripts/00-configurar-ambiente.sh
# Não salva nem contém senhas. Ajuste nomes por variáveis antes de source, se necessário.
export RG="${RG:-rg-dimdim-rm563489}"
export LOCATION="${LOCATION:-canadacentral}"
# Os nomes abaixo precisam estar livres globalmente. Altere DIMDIM_SUFFIX se ocupados.
export DIMDIM_SUFFIX="${DIMDIM_SUFFIX:-rm563489cp3}"
export APP_NAME="${APP_NAME:-dimdim-${DIMDIM_SUFFIX}}"
export PG_SERVER="${PG_SERVER:-pg-dimdim-${DIMDIM_SUFFIX}}"
export DB_ADMIN="${DB_ADMIN:-dimdimadmin}"
export BASE_URL="https://${APP_NAME}.azurewebsites.net"
export PGHOST="${PG_SERVER}.postgres.database.azure.com"
export PGUSER="$DB_ADMIN"
export PGDATABASE=dimdim
export PGSSLMODE=require
printf 'Ambiente: RG=%s | APP=%s | PG=%s\n' "$RG" "$APP_NAME" "$PG_SERVER"
