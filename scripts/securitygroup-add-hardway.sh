#!/bin/bash
openstack security group rule create --proto icmp \
$(openstack security group list | grep -w $(openstack project list | grep -w demo | cut -f2 -d '|' | tr -d ' ') | cut -f2 -d '|' | tr -d ' ')

openstack security group rule create --proto tcp --dst-port 22 \
$(openstack security group list | grep -w $(openstack project list | grep -w demo | cut -f2 -d '|' | tr -d ' ') | cut -f2 -d '|' | tr -d ' ')\



