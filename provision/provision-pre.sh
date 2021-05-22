#!/usr/bin/env bash

COLOR_BROWN="\033[0;33m"
COLOR_GREEN="\033[1;32m"
COLOR_NONE="\033[0m"

set -e

echo -e "${t3bs_hostname}"

echo -e " "
echo -e " "
echo -ne "${COLOR_BROWN}                  \`....\`\`\n"
echo -ne "${COLOR_BROWN}      .-:+oos\`   \`syyyyyyys+-\n"
echo -ne "${COLOR_BROWN}   :+syyyyyys    \`yyyyyyyyyyy\`\n"
echo -ne "${COLOR_BROWN}  +yyyyyyyyyy-    +yyyyyyyyys\n"
echo -ne "${COLOR_BROWN}  oyyyyyyyyyyo    \`syyyyyyyy:${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}  :yyyyyyyyyyy/    .syyyyyy+${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}  \`syyyyyyyyyyy:    \`oyyyy+${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}   -yyyyyyyyyyyy:     -++:${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}    /yyyyyyyyyyyy+\`${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}     +yyyyyyyyyyyys:\`${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}      +yyyyyyyyyyyyyy+\`${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}       :syyyyyyyyyys:${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}        .oyyyyyyys/\`${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}          -oyyyo/\`${COLOR_NONE}\n"
echo -ne "${COLOR_BROWN}            \`\`\`${COLOR_NONE}\n"
echo -e " "
echo -e " "
echo -e "============================================================="
echo -e " Now bootstrapping "
echo -e "============================================================="
echo -e " "
echo -e " Please grab a cup of hot coffee while I'm doing the heavy"
echo -e " lifting for you. Your virtual machine will be up in no time."
echo -e " "
echo -e " "


setup_root_login() {
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    systemctl restart ssh
    echo "root:rootroot" | chpasswd
}

setup_welcome_msg() {
    sed -i '/Welcome to/d' /home/vagrant/.bashrc
    echo -e "\necho \"Welcome to $(lsb_release -ds) $(lsb_release -cs)\" | cowsay -s \n" >> /home/vagrant/.bashrc
    
}

user_exists() { 
    id $1 > /dev/null 2>&1 
}

setup_useradd() {
    if [ `id -u $1 2>/dev/null || echo -1` -ge 0 ]; then  # use the function, save the code
        echo 'User '$1' found'
    else
        echo 'Add user '$1 >&2  # error messages should go to stderr
        useradd -s /bin/bash -d /opt/$1 -m $1
        echo "$1 ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$1
        
    fi
}

install_docker() {
    step "===== Installing docker ====="
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    if [ $? -ne 0 ]; then
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    fi
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo gpasswd -a $USER docker
    sudo chmod 777 /var/run/docker.sock
    # Add vagrant to docker group
    sudo groupadd docker
    sudo gpasswd -a vagrant docker
    # Setup docker daemon host
    # Read more about docker daemon https://docs.docker.com/engine/reference/commandline/dockerd/
    sed -i 's/ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/192.168.121.210/g' /lib/systemd/system/docker.service
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

install_openssh() {
    step "===== Installing openssh ====="
    sudo apt update
    sudo apt -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo apt install -y openssh-server
    sudo systemctl enable ssh
}

install_disk_util() {
        
    echo "> Installing required tools for file system management"
    
if  [ -n "$(command -v yum)" ]; then
    echo ">> Detected yum-based Linux"
    sudo yum makecache
    sudo yum install -y util-linux lvm2 e2fsprogs
fi    

if [ -n "$(command -v apt-get)" ]; then
    echo ">> Detected apt-based Linux"
    sudo apt update
    sudo apt -y install fdisk lvm2 e2fsprogs
fi
}


main() {
    setup_welcome_msg
    #install_disk_util
    #ensure_netplan_apply
    #resolve_dns
    #install_openssh
    #setup_root_login
    #install_docker
    #user_exists stack    #move to playbook.yml
    #setup_useradd stack  #move to playbook.yml
}
main