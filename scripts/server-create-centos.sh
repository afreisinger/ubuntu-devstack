#!/bin/bash
openstack server create --flavor ds1G \
--image $(openstack image list | grep centos | cut -f3  -d '|') \
--nic net-id=$(openstack network list | grep private | cut -f2 -d '|' | tr -d ' ') \
--security-group $(openstack security group list | grep -w $(openstack project list | grep -w demo | cut -f2 -d '|' | tr -d ' ') | cut -f2 -d '|' | tr -d ' ') \
--key-name afreisinger \
$1
openstack floating ip create public

openstack server add floating ip $1 \
$(openstack floating ip list | grep None | cut -f3 -d '|' | tr -d ' ') 

openstack floating ip list