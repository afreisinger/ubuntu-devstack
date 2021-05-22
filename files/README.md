# Openstack Bugs Description

 
 * ARPING check doesn't work during the installation
            
         Solved with the following patch in lib/neutron-legacy (function _move_neutron_addresses_route)
         Ref: https://bugs.launchpad.net/devstack/+bug/1911459

        - $DEL_OVS_PORT; $IP_DEL; $IP_REPLACE; $IP_UP; $ADD_OVS_PORT; $ADD_DEFAULT_ROUTE; $ARP_CMD
        + $DEL_OVS_PORT; $IP_DEL; $IP_REPLACE; $IP_UP; $ADD_OVS_PORT; $ADD_DEFAULT_ROUTE

* EBTABLES incompatible during the instalation

        ebtables v1.8.4 (nf_tables): table `broute’ is incompatible, use ‘nft’ tool.

        Solved with the following patch in /opt/stack/devstack/tools/worlddump.py

        - _dump_cmd("sudo ebtables -t %s -L" % table)

playbook.yml fixed this bugs.