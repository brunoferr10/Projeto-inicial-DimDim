#!/usr/bin/env bash
set -euo pipefail
: "${RG:?Informe RG}"
: "${APP_NAME:?Informe APP_NAME}"
cd "$(dirname "$0")/.."
az webapp deploy -g "$RG" -n "$APP_NAME" --src-path target/app.jar --type jar --restart true -o none
curl --retry 20 --retry-delay 10 --retry-all-errors -fsS "https://${APP_NAME}.azurewebsites.net/actuator/health"
echo
curl -fsS "https://${APP_NAME}.azurewebsites.net/api/versao"
