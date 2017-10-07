#!/bin/sh

BASEDIR=`pwd`/`dirname $0`
#BASEDIR=$(dirname $0)

. $BASEDIR/prop/env.prop
. $BASEDIR/prop/sg.prop

function actionList() {
  echo
  echo "***************************************"
  echo "choose an action"
  echo "  file system id: $fileSystemId"
  echo "***************************************"
  echo
  echo " l: list file systems"
  echo "cf: create file system"
  echo "sf: set file system"
  echo "cm: create mount target"
  echo "ce: create environment"
  echo " d: deploy"
  echo "st: status"
  echo "tm: terminate environment"
  echo " q: exit"
  echo
}

function title() {
  echo
  echo "--------------------------"
  echo $1
  echo "--------------------------"
  echo
}

function listFileSystem() {
  title "list file systems"

  aws efs describe-file-systems \
      --query 'FileSystems[].[FileSystemId,Name,LifeCycleState]' \
      --output text \
      --region $region \
      --profile $profile
}

function setFileSystem() {
  title "set file systems"

  echo "file system listing"
  aws efs describe-file-systems \
      --query 'FileSystems[].[FileSystemId,Name,LifeCycleState]' \
      --output text \
      --region $region \
      --profile $profile
  echo

  printf "Enter file system id: "
  read fileSystemId
}

function createFileSystem() {
  title "create file system"

  fileSystemId=$(
  aws efs create-file-system \
      --creation-token $token \
      --query 'FileSystemId' 
      --region $region \
      --profile $profile \
      --output text
  )
  aws efs create-tags --file-system-id $fileSystemId --tags Key=Name,Value="$tagValue"
}

function createMountTarget() {
  title "create mount target"

  aws efs create-mount-target \
      --file-system-id $fileSystemId \
      --subnet-id $subnetId \
      --security-groups $securityGroups \
      --region $region \
      --region $region \
      --profile $profile
}

clear

while true
do

  actionList
  printf "Enter your menu choice: "

  read yourch
  echo

  case $yourch in
    l) listFileSystem
       ;;
    cf) createFileSystem
       ;;
    sf) setFileSystem
       ;;
    cm) createMountTarget 
       ;;
    q) exit
       ;;
  esac
done
