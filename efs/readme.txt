-----------------------
steps
-----------------------


-----------------------
prerequisite
-----------------------

* VPC
* subnet
* security group
  - create a special security group for efs
  - associate this security group to EFS and EC2, so EC2 can access EFS

-----------------------
create file system
-----------------------

* command
  - sudo aws efs create-file-system --creation-token ******
    ~ token needs to be a different string than in previous created file system
    ~ if previous file system is deleted, can reuse the token
    ~ need to capture the file system id to create mount target

-----------------------
create mount target
-----------------------

* command
  - sudo aws efs create-mount-target --file-system-id *** --subnet-id *** --security-groups *** 
