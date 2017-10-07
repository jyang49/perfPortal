#!/bin/sh

function usage() {
  echo
  echo "*******************************************************************************************"
  echo "Usage: $0 -n ec2-tag-name -t [master|agent]"
  echo
  echo "!!! before create EC2, edit prop/common.prop file for correct subnet id, profile ... !!!"
  echo "*******************************************************************************************"
  echo

  exit 1
}

while getopts n:t: OPTION
do
  case ${OPTION} in
    n) ec2Name=${OPTARG};;
    t) type=${OPTARG};;
    [?]) usage;;
  esac
done

if [[ "${ec2Name}X" == "X" ]]; then
  usage
fi

if [[ "${type}X" == "X" ]]; then
  usage
fi

if [[ "${type}" != "master" && "${type}" != "agent" ]]; then
  usage
fi

# create EC2

. prop/${type}.prop
. prop/common.prop

# eval sed 's/TAG_NAME/$ec2Name/' userdata.template > tmp/userdata

ec2Id=$(
  aws ec2 run-instances \
    --image-id $imageId \
    --instance-type $instanceType \
    --key-name $keyName \
    --monitoring Enabled=$isEnabled \
    --count $count \
    --user-data file://userdata/$userdata \
    --subnet-id $subnetId \
    --security-group-ids $sgId $sgIdEFS \
    --$publicIp \
    --profile $profile \
    --query Instances[].InstanceId \
    --output text
)

aws ec2 create-tags --resources $ec2Id --tags Key=Name,Value=$ec2Name --profile $profile

echo "EC2 name=$ec2Name"
echo "EC2 Id=$ec2Id"

