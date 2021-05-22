#!/usr/bin/env bash
# Public Network  vboxnet0 (192.168.56.0/24)
VBoxManage hostonlyif create
VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.56.0 --netmask 255.255.255.0

# Private Network vboxnet1 (10.0.0.0/8)
# VBoxManage hostonlyif create
# VBoxManage hostonlyif ipconfig vboxnet1 --ip 10.0.0.254 --netmask 255.0.0.0
