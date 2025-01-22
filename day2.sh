#! /usr/bin/env bash 

sudo subscription-manager register --username=
sudo subscription-manager config --rhsm.manage_repos=1
# to become an ansible host 
sudo subscription-manager repos --enable=ansible-2.8-for-rhel-8-x86_64-rpms 
sudo dnf update -y
sudo dnf install -y ansible ansible-freeipa 
sudo subscription-manager repos --list-enabled

cat >> EOF > inventory
[ipaserver]
rhel8-1.ipa.spidee.net

[ipaserver:vars]
ipaserver_domain=ipa.spidee.net
ipserver_realm=IPA.SPIDEE.NET
iapserver_setup_dns=yes
ipaserver_autoforwarders=yes
ipaadmin_password=password123
ipadm_password=password123
EOF

