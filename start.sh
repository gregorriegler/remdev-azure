#!/bin/bash 
REGION='germanywestcentral'
# Alternative: 'Standard_D8s_v4' // General Purpose vCPUs:8 (Intel® Xeon® Platinum 8272CL) memory: 32GiB
# Standard_D4d_v4
# Standard_D4s_v3
SIZE='Standard_D8s_v4'
GROUPNAME='mob'
USERNAME='mob'
PASSWORD='mob'

while getopts r:s:g:u:p flag
do
    case "${flag}" in
        r) REGION=${OPTARG};;
        s) SIZE=${OPTARG};;
        g) GROUPNAME=${OPTARG};;
        u) USERNAME=${OPTARG};;
        p) PASSWORD=${OPTARG};;
    esac
done

echo "deleting group $GROUPNAME ..."
az group delete --name $GROUPNAME -y

echo "recreating group $GROUPNAME ..."
az group create --name $GROUPNAME --location $REGION

echo "creating vm mobVm ..."
ip=$(az vm create \
--resource-group $GROUPNAME \
--name mobVm \
--size $SIZE \
--image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
--admin-username $USERNAME \
--generate-ssh-keys \
--public-ip-sku Standard \
--custom-data cloud-init.yml | jq -r .publicIpAddress)

echo "opening ports ..."
az vm open-port --port 80   --resource-group $GROUPNAME --name mobVm --priority 1050 > /dev/null
az vm open-port --port 443  --resource-group $GROUPNAME --name mobVm --priority 1060 > /dev/null
az vm open-port --port 3000 --resource-group $GROUPNAME --name mobVm --priority 1070 > /dev/null
az vm open-port --port 5938 --resource-group $GROUPNAME --name mobVm --priority 1080 > /dev/null
az vm open-port --port 6568 --resource-group $GROUPNAME --name mobVm --priority 1090 > /dev/null
az vm open-port --port 7070 --resource-group $GROUPNAME --name mobVm --priority 1100 > /dev/null

az vm user update \
  --resource-group $GROUPNAME \
  --name mobVm \
  --username $USERNAME \
  --password $PASSWORD > /dev/null

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
