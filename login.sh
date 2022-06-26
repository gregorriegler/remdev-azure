#!/bin/bash
usage() {                                 
  echo "Usage: $0 [ -u USERNAME <a.b@email.address> [ -p PASSWORD ] ] [ -s SUBSCRIPTION <>]" 1>&2 
}
exit_abnormal() {                         
  usage
  exit 1
}

while getopts s:u:p: flag
do
    case "${flag}" in
        s) SUBSCRIPTION=${OPTARG}
          echo "subscriptionId: "$SUBSCRIPTION
        ;;
        u) USERNAME=${OPTARG}
          echo "username: "$USERNAME # MFA still not supported in az cli
        ;;
        p) PASSWORD=${OPTARG} # MFA still not supported in az cli
        ;;
        :) echo "Error: -${OPTARG} requires an argument." 
          exit_abnormal
        ;;
        *)
          exit_abnormal
        ;;
    esac
done

if [ "$USERNAME" ] && [ ! "$PASSWORD" ] 
then
    echo "if username is given please provide a password."
    usage
    exit 1
fi


if [ "$USERNAME" ] && [ "$PASSWORD" ] 
then
    az login -u "$USERNAME" -p "$PASSWORD" -o none
else
    az login --use-device-code -o none
fi

echo "--------------------------------"
echo "showing available subscriptions:"
az account list -o table
echo

if [ "$SUBSCRIPTION" ]
then
  echo "--------------------------------"
  echo "setting subcscription context to"
  az account set --subscription $SUBSCRIPTION
  az account show -o table
  echo "--------------------------------"
fi
