usage() {                                 
  echo "Usage: $0 [ -u USERNAME ] [ -p PASSWORD ] [ -s SUBSCRIPTION ]" 1>&2 
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
          echo "username: "$USERNAME
        ;;
        p) PASSWORD=${OPTARG}
        ;;
        :) echo "Error: -${OPTARG} requires an argument."
          exit_abnormal
        ;;
        *)
          exit_abnormal
        ;;
    esac
done

az login --use-device-code
az account set --subscription $SUBSCRIPTION

