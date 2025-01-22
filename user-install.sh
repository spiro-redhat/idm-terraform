#! /usr/bin/env bash
# create a group for ansible users 
sudo  bash -c 'cat << EOF  >> /etc/hosts
10.0.1.11   rhel8-1.idm.example.com
10.0.1.12   rhel8-2.idm.example.com
10.0.1.13   rhel8-3.idm.example.com
10.0.1.21   rhel9-1.idm.example.com
10.0.1.22   rhel9-2.idm.example.com
10.0.1.23   rhel9-3.idm.example.com
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

cat << EOF > day2.sh
#! /usr/bin/env bash 

sudo subscription-manager register --username=
sudo subscription-manager config --rhsm.manage_repos=1
# to become an ansible host 
sudo subscription-manager repos --enable=ansible-2.8-for-rhel-8-x86_64-rpms 
sudo dnf update -y
sudo dnf install -y ansible ansible-freeipa 
sudo subscription-manager repos --list-enabled
EOF

cat << EOF > inventory
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
