#!/bin/bash 

REGION='germanywestcentral'
SIZE='Standard_D4s_v3' # Alternative: 'Standard_D8s_v4' // General Purpose vCPUs:8 (Intel® Xeon® Platinum 8272CL) memory: 32GiB
USERNAME='mob'
PASSWORD=${1:-mob}

echo "deleting group mob ..."
az group delete --name mob

echo "recreating group mob ..."
az group create --name mob --location $REGION

echo "creating vm mobVm ..."
ip=$(az vm create \
--resource-group mob \
--name mobVm \
--size $SIZE \
--image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
--admin-username $USERNAME \
--generate-ssh-keys \
--public-ip-sku Standard \
--custom-data cloud-init.yml | jq -r .publicIpAddress)

echo "opening ports ..."
az vm open-port --port 80,443,6568,7070,5938 --resource-group mob --name mobVm --priority 1050

az vm user update \
  --resource-group mob \
  --name mobVm \
  --username $USERNAME \
  --password $PASSWORD

echo "vm created."
echo "connect via ssh:"
echo "ssh mob@${ip}"
