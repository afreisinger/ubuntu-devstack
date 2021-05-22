#!/bin/bash

# Keep track of the DevStack directory
TOP_DIR=$(pwd | grep -Po '(.*)(?=((/.*?){1})$)')

# Import common functions
source $TOP_DIR/functions

# Use openrc + stackrc + localrc for settings
source $TOP_DIR/stackrc

# Destination path for installation ``DEST``
DEST=${DEST:-/opt/stack}

help()
{
   # Display Help
   echo
   echo "Add tcp/22 and icmp to default security group."
   echo
   echo "Syntax: securitygroup-add.sh [-h] [project-name]"
   echo
   echo "Options:"
   echo "-h     Print this Help."
   echo
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         help
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         echo "securitygroup-add.sh -h for more details"
         exit;;
   esac
done

if is_service_enabled nova; then
# Update security default group
# -----------------------------
# Add tcp/22 and icmp to default security group

    if [ "$1" == "" ]; then
        help
    else
        
        project="$1"
        echo
        echo "Project name: $project"
        project_id=$(openstack project list -f value -c ID -c Name | grep -w $project | cut -f1 -d ' ')
        echo "Project_id : $project_id"
        if [ ! -z "$project_id" ]; then
                security_group_id=$(openstack security group list -f value -c ID -c Project | grep -w $project_id | cut -f1 -d ' ')
                openstack security group rule create $security_group_id --protocol tcp --dst-port 22
                openstack security group rule create $security_group_id --protocol icmp
            else
                echo
                echo "Project name not found"
                echo
                echo "Project list available"
                echo
                openstack project list -f value -c Name -c ID
                echo
                echo "--help"
                help
        fi
    fi
fi
