#!/usr/bin/env bash
set -euo pipefail
# Execute no Azure Cloud Shell Bash. Cria recursos cobrados na sua assinatura.
RG="${RG:-rg-dimdim-rm563489}"
LOCATION="${LOCATION:-canadacentral}"
VM="${VM:-vm-dimdim}"
ADMIN="${ADMIN:-azureuser}"
: "${SSH_SOURCE_CIDR:?Informe seu IP público com /32 para liberar SSH}"
az group create -n "$RG" -l "$LOCATION" --output none
az vm create -g "$RG" -n "$VM" --image Ubuntu2404 --size Standard_B2s \
 --admin-username "$ADMIN" --generate-ssh-keys --public-ip-sku Standard \
 --nsg-rule NONE --custom-data scripts/cloud-init.yml --output none
NSG=$(az network nsg list -g "$RG" --query '[0].name' -o tsv)
az network nsg rule create -g "$RG" --nsg-name "$NSG" -n SSHRestrito --priority 1000 \
 --source-address-prefixes "$SSH_SOURCE_CIDR" --destination-port-ranges 22 --access Allow --protocol Tcp -o none
az network nsg rule create -g "$RG" --nsg-name "$NSG" -n ApiDemo --priority 1010 \
 --source-address-prefixes Internet --destination-port-ranges 8080 --access Allow --protocol Tcp -o none
az vm show -d -g "$RG" -n "$VM" --query '{IP:publicIps,Usuario:osProfile.adminUsername}' -o table
