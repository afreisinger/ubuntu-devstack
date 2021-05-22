#!/bin/bash
openstack server add floating ip $1 \
$(openstack floating ip list | grep None | cut -f3 -d '|' | tr -d ' ') 
openstack floating ip list