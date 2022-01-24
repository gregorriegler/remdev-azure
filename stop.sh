#!/bin/bash 
GROUPNAME=${1:-mob}

echo "Deleting group $GROUPNAME..."
az group delete --name $GROUPNAME
