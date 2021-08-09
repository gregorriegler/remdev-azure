#!/bin/bash 
echo "deleting group mob..."
az group delete --name mob

echo "recreating group mob..."
az group create --name mob --location germanywestcentral

echo "creating vm mobVm..."
ip=$(az vm create \
--resource-group mob \
--name mobVm \
--size Standard_D4s_v3 \
--image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
--admin-username gregor \
--generate-ssh-keys \
--public-ip-sku Standard \
--custom-data cloud-init.yml | jq -r .publicIpAddress)

#anydesk ports
echo "opening ports for anydesk (443, 6568, 7070)..."
az vm open-port --port 80 --resource-group mob --name mobVm --priority 1050
az vm open-port --port 443 --resource-group mob --name mobVm --priority 1100
az vm open-port --port 6568 --resource-group mob --name mobVm --priority 1300
az vm open-port --port 7070 --resource-group mob --name mobVm --priority 1400
az vm open-port --port 5938 --resource-group mob --name mobVm --priority 1500

az vm user update \
  --resource-group mob \
  --name mobVm \
  --username gregor \
  --password gregor

echo "vm created."
echo "connect via ssh:"
echo "ssh ${ip}"
echo "or via vnc:"
echo "ssh -L 5901:127.0.0.1:5901 -N -f -l gregor ${ip}"
echo "xtigervncviewer -DesktopSize=1920x1080 -RemoteResize=0 :1"
