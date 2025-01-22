#! /usr/bin/env bash
# create a group for ansible users 
sudo  bash -c 'cat << EOF  >> /etc/hosts
10.0.1.11   rhel8-1.ipa.spidee.net
10.0.1.12   rhel8-2.ipa.spidee.net
10.0.1.13   rhel8-3.ipa.spidee.net
10.0.1.21   rhel9-1.ipa.spidee.net
10.0.1.22   rhel9-2.ipa.spidee.net
10.0.1.23   rhel9-3.ipa.spidee.net
EOF'
export IP=$(ip -br addr show eth0 | awk '{ print $3 }' | sed -e 's/\/24//g')
export HOSTNAME=$(grep $IP /etc/hosts  | awk '{ print $2 }')
sudo hostnamectl hostname ${HOSTNAME} 


mkdir -p /home/ec2-user/.ssh

cat << EOF > /home/ec2-user/.ssh/config
Host *
    User ec2-user 
    IdentityFile ~/.ssh/id_rsa
    StrictHostChecking No 
EOF 

cat << EOF > /home/ec2-user/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
EOF' 
chmod -R 400 /home/ec2-user/.ssh/id_rsa

