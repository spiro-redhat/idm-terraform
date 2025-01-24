#! /usr/bin/env bash
# create a group for ansible users 
sudo  bash -c 'cat << EOF  >> /etc/hosts
10.0.1.11   rhel7-1.ipa.spidee.net
10.0.1.12   rhel7-2.ipa.spidee.net
10.0.1.13   rhel7-3.ipa.spidee.net
10.0.1.21   rhel8-1.ipa.spidee.net
10.0.1.22   rhel8-2.ipa.spidee.net
10.0.1.23   rhel8-3.ipa.spidee.net
10.0.1.31   rhel9-1.ipa.spidee.net
10.0.1.32   rhel9-2.ipa.spidee.net
10.0.1.33   rhel9-3.ipa.spidee.net
EOF'


export IP=$(ip -br addr show eth0 | awk '{ print $3 }' | sed -e 's/\/24//g')
export HOSTNAME=$(grep $IP /etc/hosts  | awk '{ print $2 }')
sudo hostnamectl hostname ${HOSTNAME} 


mkdir -p /home/ec2-user/.ssh

cat << EOF > /home/ec2-user/.ssh/config
Host *
    User ec2-user 
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking No 
EOF

cat << EOF > /home/ec2-user/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
EOF 
chmod -R 400 /home/ec2-user/.ssh/id_rsa



cat << EOF > /home/ec2-user/day2.sh
#! /usr/bin/env bash

sudo subscription-manager register --username=
sudo subscription-manager config --rhsm.manage_repos=1
sudo subscription-manager repos --list-enabled
EOF

cat << EOF > /home/ec2-user/rhel8-idm.sh
#! /usr/bin/env bash

# to become an ansible host
sudo subscription-manager repos --enable=ansible-2.9-for-rhel-8-x86_64-rpms
sudo yum update -y
sudo yum install -y ansible ansible-freeipa

sudo yum -y module enable idm:DL1
sudo yum -y distro-sync
sudo yum -y module install idm:DL1/dns
EOF


cat << EOF > /home/ec2-user/rhel7-idm.sh
#! /usr/bin/env bash
yum install -y ipa-server ipa-server-dns 
EOF

cat << EOF > /home/ec2-user/rhel9-idm.sh
#! /usr/bin/env bash
dnf install -y ipa-server ipa-server-dns 
# dnf install -y  ipa-server-trust-ad samba-client 
EOF


cat << EOF > /home/ec2-user/inventory
[ipaserver]
rhel8-1.idm.example.com

[ipaserver:vars]
ipaserver_domain=idm.example.com
ipserver_realm=IDM.EXAMPLE.COM
iapserver_setup_dns=yes
ipaserver_autoforwarders=yes
ipaadmin_password=password123
ipadm_password=password123
EOF

sudo chmod 400 /home/ec2-user/.ssh/id_rsa
sudo chmod 700 /home/ec2-user/*.sh
sudo chown -R ec2-user:ec2-user /home/ec2-user/
