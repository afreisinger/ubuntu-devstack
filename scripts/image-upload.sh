#!/bin/bash
#glance image-create  --min-disk 5 --min-ram 1024 --container-format bare --disk-format qcow2 --name $1 --file $2
#image-upload.sh CentOS7.8-V1.0 /vagrant/qcow.nosync/CentOS7.8-V1.0.qcow2 
openstack image create $1 --min-disk 0 --min-ram 1024 --public --container-format bare --disk-format qcow2 --file $2
