#!/bin/bash 

REGION='germanywestcentral'
# Alternative: 'Standard_D8s_v4' // General Purpose vCPUs:8 (Intel® Xeon® Platinum 8272CL) memory: 32GiB
# Standard_D4d_v4
# Standard_D4s_v3
SIZE='Standard_D4d_v3'
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
az vm open-port --port 80   --resource-group mob --name mobVm --priority 1050 > /dev/null
az vm open-port --port 443  --resource-group mob --name mobVm --priority 1060 > /dev/null
az vm open-port --port 3000 --resource-group mob --name mobVm --priority 1070 > /dev/null
az vm open-port --port 5938 --resource-group mob --name mobVm --priority 1080 > /dev/null
az vm open-port --port 6568 --resource-group mob --name mobVm --priority 1090 > /dev/null
az vm open-port --port 7070 --resource-group mob --name mobVm --priority 1100 > /dev/null

az vm user update \
  --resource-group mob \
  --name mobVm \
  --username $USERNAME \
  --password $PASSWORD

echo "vm created."
echo "connect via ssh:"
echo "ssh ${USERNAME}@${ip}"

# wait for cloud-init to be finished
echo "please wait before connecting via X2Go."
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' -m 2 $ip:3000)" != "200" ]]; do 
    sleep 2;
    echo -ne "."
done

echo " done."
echo "${ip} ready to connect via X2Go."
