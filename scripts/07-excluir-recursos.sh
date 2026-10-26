#!/usr/bin/env bash
set -euo pipefail
: "${RG:?Informe o resource group a excluir}"
echo "Este comando exclui TODOS os recursos do grupo $RG, inclusive banco e dados."
echo "Execute somente após a correção e depois de preservar o que precisar."
read -r -p "Digite o nome exato do grupo para confirmar: " resposta
[[ "$resposta" == "$RG" ]] || { echo "Cancelado."; exit 1; }
az group delete --name "$RG"
