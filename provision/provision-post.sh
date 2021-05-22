#!/usr/bin/env bash

COLOR_BROWN="\033[0;33m"
COLOR_GREEN="\033[1;32m"
COLOR_NONE="\033[0m"

[ "${t3bs_use_tls}" = "true" ] && PROTO="https" || PROTO="http"
set -e

# Some instructions
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
echo -e "==================================================================================================="
echo -e " Bootstrapping has been finished."
echo -e "==================================================================================================="
echo -e " "
echo -e " If you have the vagrant-hostmanager plugin installed or if you have already updated your hosts"
echo -e " file located at /etc/hosts, you can now visit your freshly bootstrapped project at the"
echo -e " following locations:"
echo -e " "
echo -e " Frontend: ${PROTO}://${t3bs_ip}"
echo -e " "

if [ "${t3bs_use_tls}" = true ]; then
  echo -e " --------------------------------------------------------------------------------------------------"
  echo -e " "
  echo -e " This site uses TLS encryption with self-signed certificates. In order to avoid SSL certificate"
  echo -e " warnings please make sure that you have imported the CA certificate provided with this package"
  echo -e " into your browser. The file is located at /provision/ssl/certs/ca.crt.pem"
  echo -e " "
fi


setup_userchown() {
  sudo chown -R stack /opt/stack/devstack
  sudo chmod 770 /opt/stack/devstack
  usermod -a -G sudo stack
}

#main() {
  #setup_userchown
#}

#main

#In order to solve this, install cryptography version 3.3.2
#pip install cryptography==3.3.2

