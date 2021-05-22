#!/bin/bash
qemu-img convert -c -f qcow2 -O qcow2 -o compat=0.10 $1 $2
