#!/usr/bin/env bash
set -euo pipefail
# Azure Cloud Shell Bash ou VM com Azure CLI autenticado. Recursos cobrados.
RG="${RG:-rg-dimdim-rm563489}"
LOCATION="${LOCATION:-canadacentral}"
: "${APP_NAME:?Nome globalmente único do Web App}"
: "${PG_SERVER:?Nome globalmente único do PostgreSQL}"
: "${DB_PASSWORD:?Senha forte do administrador do PostgreSQL}"
DB_ADMIN="${DB_ADMIN:-dimdimadmin}"
az group create -n "$RG" -l "$LOCATION" -o none
az postgres flexible-server create -g "$RG" -n "$PG_SERVER" -l "$LOCATION" \
 --admin-user "$DB_ADMIN" --admin-password "$DB_PASSWORD" --version 16 \
 --tier Burstable --sku-name Standard_B1ms --storage-size 32 \
 --public-access None --yes -o none
az postgres flexible-server db create -g "$RG" -s "$PG_SERVER" -d dimdim -o none
# Regra especial Azure: permite conexões vindas do Azure, inclusive outras assinaturas.
# A autenticação do banco continua obrigatória; não abre 5432 para toda Internet.
az postgres flexible-server firewall-rule create -g "$RG" -n "$PG_SERVER" \
 --rule-name AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0 -o none
az appservice plan create -g "$RG" -n plan-dimdim --is-linux --sku B1 -l "$LOCATION" -o none
az webapp create -g "$RG" -p plan-dimdim -n "$APP_NAME" --runtime 'JAVA:17-java17' -o none
az webapp config appsettings set -g "$RG" -n "$APP_NAME" --settings \
 "DB_URL=jdbc:postgresql://${PG_SERVER}.postgres.database.azure.com:5432/dimdim?sslmode=require" \
 "DB_USER=$DB_ADMIN" "DB_PASSWORD=$DB_PASSWORD" "SERVER_PORT=80" -o none
az webapp update -g "$RG" -n "$APP_NAME" --https-only true -o none
az webapp config set -g "$RG" -n "$APP_NAME" --always-on true -o none
echo "Recursos criados. Antes do deploy, execute script.sql no PostgreSQL conforme GUIA-APPSERVICE.md."
echo "https://${APP_NAME}.azurewebsites.net/api/versao"
