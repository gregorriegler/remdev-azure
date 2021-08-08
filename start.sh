#!/bin/bash 

az group delete --name mob

az group create --name mob --location germanywestcentral

# responds with "publicIpAddress": "51.116.184.244",
ip = $(az vm create \
--resource-group mob \
--name mobVm \
--size Standard_D4s_v3 \
--image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
--admin-username gregor \
--generate-ssh-keys \
--custom-data cloud-init.yml | jq .publicIpAddress)

#anydesk ports
az vm open-port --port 443 --resource-group mob --name mobVm --priority 1100
az vm open-port --port 6568 --resource-group mob --name mobVm --priority 1300
az vm open-port --port 7070 --resource-group mob --name mobVm --priority 1400

az vm user update \
  --resource-group mob \
  --name mobVm \
  --username gregor \
  --password gregor

echo "vm created."
echo "ip: $ip"
