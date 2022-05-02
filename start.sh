#!/bin/bash

REGION='westeurope' # has always the most and newest features
# Alternative: 'Standard_D8s_v4' // General Purpose vCPUs:8 (Intel® Xeon® Platinum 8272CL) memory: 32GiB
# Standard_D4d_v4
# Standard_D4s_v3
SIZE='Standard_D8s_v4'
GROUPNAME='mob'
USERNAME='mob'
PASSWORD='mob'
MYIP=$(curl ipinfo.io/ip)"/32" # if not given as a parameter it will take your outgoing IP/32

while getopts r:s:g:u:p flag
do
    case "${flag}" in
        r) REGION=${OPTARG};;
        s) SIZE=${OPTARG};;
        g) GROUPNAME=${OPTARG};;
        u) USERNAME=${OPTARG};;
        p) PASSWORD=${OPTARG};;
        i) MYIP=${OPTARG};;
    esac
done
echo "IP: " $MYIP

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
--nsg mobVm-nsg \
--nsg-rule NONE \
--public-ip-sku Standard \
--custom-data cloud-init.yml | jq -r .publicIpAddress)

echo "creating nsg rule..."
az network nsg rule create --name mobVM-ports \
                           --nsg-name mobVm-nsg \
                           --priority 1010 \
                           --resource-group $GROUPNAME \
                           --access allow \
                           --direction Inbound \
                           --protocol "*" \
                           --source-address-prefixes $MYIP \
                           --destination-port-ranges 22 80 443 3000 5938 6568 7070

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
