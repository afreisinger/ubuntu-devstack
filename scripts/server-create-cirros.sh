#!/bin/bash
openstack server create --flavor m1.tiny \
--image $(openstack image list | grep cirros | cut -f3  -d '|') \
--nic net-id=$(openstack network list | grep private | cut -f2 -d '|' | tr -d ' ') \
--security-group $(openstack security group list | grep -w $(openstack project list | grep -w demo | cut -f2 -d '|' | tr -d ' ') | cut -f2 -d '|' | tr -d ' ') \
$1