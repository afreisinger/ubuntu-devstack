# Openstack Bootstrap

Fully automated provisioning of a virtual machine for openstack  development using **VirtualBox**, **Vagrant** , **DevStack** and **Ansible**.

## Contents

This package is using [ubuntu/focal64](https://app.vagrantup.com/ubuntu/boxes/focal64) as its Vagrant base box. The provisioned virtual machine will have the following git clone repository:

* [openstack/devstack](https://github.com/openstack/devstack.git) 

## Add software

The following additional software are installed

* git
* curl
* lsb-release
* cowsay
* net-tools
* arping
* network-manager
* john

## Requirements

* A Linux-, MacOS- or Windows machine
* Oracle VirtualBox >= 6.1.12
* Vagrant >= 2.2.9


## Optional dependencies (recommended)

* `vagrant-hostmanager` plug-in to easily access the virtual machine using domain names.
* `vagrant-vbguest` plug-in to keep VirtualBox guest additions up to date.
* `vagrant-disksize` plug-in the size you want for your disk in your vagrantfile.
* `vagrant-timezone` plug-in set the timezone automatically.


## Setup

Only a few steps are necessary to get your virtual machine up and running:

1. Download and install **VirtualBox** and **Vagrant**.

2. Clone this repository

3. Run ./provision/virtualbox-environment.sh

4. Edit the provisioning configuration located at `configuration.yml` and modify it to your needs.
    - If you want to use automatic update of the VirtualBox guest additions make sure to set `vbguest_auto_update` to `true`.

5. Edit the openstack configuration located at `local.conf` and modify it to your needs.

6. Run `vagrant up` to boot and provision the virtual machine. If you have installed the `vagrant-hostmanager` plug-in vagrant will ask you for your password to escalate privileges to modify the `/etc/hosts` file.

## How do I get onto the box?

### Ubuntu

After the box has been successfully booted up you can access through SSH just enter `vagrant ssh` and you are good to go or `ssh vagrant@localhost -p 2222 -i .vagrant/machines/openstack/virtualbox/private_key` where openstack is the hostname.

If you can't access the virtual machine through its default IP address and/or hostname chances are you have modified these information in the provisioning configuration.



### DevStack

[DevStack](https://github.com/openstack/devstack.git) is a set of scripts and utilities to quickly deploy an OpenStack cloud from git source trees.

* To quickly build dev OpenStack environments in a clean Ubuntu or Fedora environment

IMPORTANT: Be sure to carefully read stack.sh and any other scripts you execute before you run them, as they install software and will alter your networking configuration. We strongly recommend that you run stack.sh in a clean and disposable vm when you are first getting started.


1. After the box has been successfully booted up you can access through SSH just enter `vagrant ssh`

2. Define the password to access openstack
```hcl
stack@openstack:~/devstack$ vi local.conf 
[[local|localrc]]
ADMIN_PASSWORD=secret
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD

HOST_IP=10.0.1.15
FLOATING_RANGE=10.0.1.0/24
Q_FLOATING_ALLOCATION_POOL=start=10.0.1.79,end=10.0.1.99
PUBLIC_NETWORK_GATEWAY=10.0.1.254
FLAT_INTERFACE=enp0s8
PUBLIC_INTERFACE=enp0s8

# Open vSwitch provider networking configuration
Q_USE_PROVIDERNET_FOR_PUBLIC=True
OVS_PHYSICAL_BRIDGE=br-ex
PUBLIC_BRIDGE=br-ex
OVS_BRIDGE_MAPPINGS=public:br-ex
```

3. Login with sudo su - stack and change directory to ~/devstack
```hcl
$ sudo su - stack
stack@devstack:~$ pwd
/opt/stack
stack@openstack:~$ cd devstack
stack@openstack:~/devstack$ ./stack.sh 
```
4. Please grab a cup of hot coffee

5. If the installation has been successful, the following message will appear
```hcl
This is your host IP address: 10.0.1.15
This is your host IPv6 address: ::1
Horizon is now available at http://10.0.1.15/dashboard
Keystone is serving at http://10.0.1.15/identity/
The default users are: admin and demo
The password: secret

Services are running under systemd unit files.
For more information see: 
https://docs.openstack.org/devstack/latest/systemd.html

DevStack Version: victoria
Change: e3e80633806242f0ae5a22fe5b9cb3e145789d28 Merge "Cleanup VM instances during unstack" 2020-07-02 11:27:25 +0000
OS Version: Ubuntu 20.04 focal
```

If you have installed the `vagrant-hostmanager` plug-in you can alternatively access the instance through its hostname https://openstack/dashboard


More information about DevStack can be found at [DevStack](https://github.com/openstack/devstack.git) 

## Debugging the Failure installation

Devstack installation may fail, due to the following reasons.

* Failure related to third party software/services/dependent libraries
* openstack software error(untested patches),
* Wrong configuration and credentials in the openstack services etc.
* Dependent Services are not running/misconfigured(such as mysql,rabbitmq etc)
* Uncleaned Installation (Previous devstack was not cleaned properly)
The log file is present in /opt/stack/log/stack.log file. First we need to check the log file to understand the reason for failure, and correct it.

Most of the times,simply restart the installation will work.

Restart the installation using below commands.

```hcl
stack@openstack:~/devstack$ 
./unstack.sh
./stack.sh
```

You may get in to the situation, that you want to cleanly uninstall the devstack with no foot prints.

```hcl
stack@openstack:~/devstack$ 
./unstack.sh
./clean.sh
cd .. && rm -rf devstack
rm -rf /opt/stack
```

## How to use Use

We can use the openstack via Web UI(Horizon) or Openstack CLI.

By default demo project is created with "demo" user. The default admistrative username is admin. we have specified the password in local.conf file. In my example, it is "secret".

Horizon
1. Access with UI http://10.0.1.15

CLI

To access via openstack CLI, openrc script needs to be executed first with the project name and username as a parameter.
```hcl
stack@openstack:~/devstack$ 

# source openrc [username] [projectname]
source openrc admin demo
```
Now client is ready to use, execute some sample operations as below,

```hcl
stack@openstack:~/devstack$ openstack flavor list
+----+-----------+-------+------+-----------+-------+-----------+
| ID | Name      |   RAM | Disk | Ephemeral | VCPUs | Is Public |
+----+-----------+-------+------+-----------+-------+-----------+
| 1  | m1.tiny   |   512 |    1 |         0 |     1 | True      |
| 2  | m1.small  |  2048 |   20 |         0 |     1 | True      |
| 3  | m1.medium |  4096 |   40 |         0 |     2 | True      |
| 4  | m1.large  |  8192 |   80 |         0 |     4 | True      |
| 42 | m1.nano   |    64 |    0 |         0 |     1 | True      |
| 5  | m1.xlarge | 16384 |  160 |         0 |     8 | True      |
| 84 | m1.micro  |   128 |    0 |         0 |     1 | True      |
+----+-----------+-------+------+-----------+-------+-----------+
```
or to create an instance
```hcl
stack@openstack:~/devstack$ ./scripts/server-create.sh
```


## Credits

* Thanks to my wife allowing me to use some of my family time for package development.
