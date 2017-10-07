. prop/env.prop

groupId=$(
  aws ec2 create-security-group \
      --vpc-id $vpcId \
      --group-name $sgName \
      --description "$sgDescription" \
      --query GroupId \
      --profile $profile \
      --region $region \
      --output text)

aws ec2 create-tags \
        --resources $groupId \
        --tags Key=Name,Value=$sgName \
        --region $region \
        --profile $profile

aws ec2 authorize-security-group-ingress \
        --group-id $groupId \
        --protocol all \
        --source-group $groupId \
        --profile jyang4900

echo "securityGroups=$groupId" > prop/sg.prop
