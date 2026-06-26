#!/bin/bash
#Script Name: SBA_setup.sh
#Script Purpose: to Install, Configure, and validate DNS, firewall, and SSH settings
#Date Created: 24/06/2026 @ 21:54
#Version: 1.3.2
#Author(s): Kaylee Froats


#---SSH (major) SETUP---#
##Subscript Name: SSH_setup
##Subscript Purpose: to Install, Configure, and validate SSH settings
##Date Created: 11/06/2026 @ 20:52
##Version: 1.0.10

#add test user(s) for SSH
useradd foo
useradd alex
echo alex:abc | chpasswd

dnf install openssh-server openssh-server openssh-clients -y

#removes all lines containing settings to be changed
echo "removing old SSH settings..."
grep -v 'PermitRootLogin' /etc/ssh/sshd_config > ./temp_file.txt
grep -v 'PubkeyAuthentication' ./temp_file.txt > /etc/ssh/sshd_config
grep -v 'PermitRootLogin' /etc/ssh/sshd_config > ./temp_file.txt
cat ./temp_file.txt > /etc/ssh/sshd_config

#adds config lines into SSHD config file
echo "configuring new SSH settings..."
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

#adds client public key to server for all users
echo "Adding client public key..."
##USER == alex
mkdir /home/alex/.ssh/
touch /home/alex/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFInH4gkEQwS64BrpJGvpwLWfFRL0eudYeel5AJmNueDH+UAUSjRkeSh4dq0YBT8+rqMSihb9eM52zWacD4LZaPoFda6MwAOpRO5mwZxptjGYt4HQ+a93b7H2MOTXV9cXvZWoa52ShL4DSkEW+D0IoZFMH7Dizs1ORo73OQH+oZkEDsAsHRSKKEJj/T2LHT7ij9R6ITXNjAXu02k3IJT9RCSkguONlK+DMueq5aBeI+KcfGuDBjETpRVfQmuzpi9QkvFSNsYDLhFF9ED7IP9ibnQPbc2SXUqVhp8U8VhaXjc1+V26PGbRovlj3m/OQTP2xdk1IkzTiUF+apCHE8rU+UivY0A3hMtIJpnMZbxRTIdhQUCI1D+8xcVBnNrylvOvopS0PDExZ30ZBTIP+o+4HXLx93IaW1u7Erc9Blqmmm0CLqaFk56EsLbgkKIkdl9mmQy0YoeclY3fUDUh2FRhrSUoYmrerLGzTlLv9iaJehnedEMS9byQmnOqm1DXkj1U= cst8246@froa0019-CLT.algon.lab" >>/home/alex/.ssh/authorized_keys

##USER == foo
mkdir /home/foo/.ssh/
touch /home/foo/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFInH4gkEQwS64BrpJGvpwLWfFRL0eudYeel5AJmNueDH+UAUSjRkeSh4dq0YBT8+rqMSihb9eM52zWacD4LZaPoFda6MwAOpRO5mwZxptjGYt4HQ+a93b7H2MOTXV9cXvZWoa52ShL4DSkEW+D0IoZFMH7Dizs1ORo73OQH+oZkEDsAsHRSKKEJj/T2LHT7ij9R6ITXNjAXu02k3IJT9RCSkguONlK+DMueq5aBeI+KcfGuDBjETpRVfQmuzpi9QkvFSNsYDLhFF9ED7IP9ibnQPbc2SXUqVhp8U8VhaXjc1+V26PGbRovlj3m/OQTP2xdk1IkzTiUF+apCHE8rU+UivY0A3hMtIJpnMZbxRTIdhQUCI1D+8xcVBnNrylvOvopS0PDExZ30ZBTIP+o+4HXLx93IaW1u7Erc9Blqmmm0CLqaFk56EsLbgkKIkdl9mmQy0YoeclY3fUDUh2FRhrSUoYmrerLGzTlLv9iaJehnedEMS9byQmnOqm1DXkj1U= cst8246@froa0019-CLT.algon.lab" >>/home/foo/.ssh/authorized_keys

##USER == root
mkdir /root/.ssh/
touch /root/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFInH4gkEQwS64BrpJGvpwLWfFRL0eudYeel5AJmNueDH+UAUSjRkeSh4dq0YBT8+rqMSihb9eM52zWacD4LZaPoFda6MwAOpRO5mwZxptjGYt4HQ+a93b7H2MOTXV9cXvZWoa52ShL4DSkEW+D0IoZFMH7Dizs1ORo73OQH+oZkEDsAsHRSKKEJj/T2LHT7ij9R6ITXNjAXu02k3IJT9RCSkguONlK+DMueq5aBeI+KcfGuDBjETpRVfQmuzpi9QkvFSNsYDLhFF9ED7IP9ibnQPbc2SXUqVhp8U8VhaXjc1+V26PGbRovlj3m/OQTP2xdk1IkzTiUF+apCHE8rU+UivY0A3hMtIJpnMZbxRTIdhQUCI1D+8xcVBnNrylvOvopS0PDExZ30ZBTIP+o+4HXLx93IaW1u7Erc9Blqmmm0CLqaFk56EsLbgkKIkdl9mmQy0YoeclY3fUDUh2FRhrSUoYmrerLGzTlLv9iaJehnedEMS9byQmnOqm1DXkj1U= cst8246@froa0019-CLT.algon.lab" >>/root/.ssh/authorized_keys

echo "SSH configuration complete!"


#---FIREWALL (Minor) SETUP---#
##Subscript Name: firewall_setup
##Subscript Purpose: allows ip traffic to/from port 49876 on client network
##Date Created: 25/06/2026 @ 00:44
##Version: 1.0.4

#stops firewalld so iptables doesn't conflict with it
systemctl stop firewalld
systemctl disable firewalld

#stops SELINUX from conflicting with iptables
grep -v 'SELINUX=enforcing' /etc/selinux/config > ./temp_file.txt
grep -v 'SELINUX=disabled' ./temp_file.txt > /etc/selinux/config
echo "SELINUX=disabled" >> /etc/selinux/config

iptables -F

#allowing traffic on CLIENT network
iptables -A INPUT -s 172.16.31.0/24 -p tcp --dport 55566 -j ACCEPT

#disallowing traffic on SERVER network
iptables -A INPUT -p tcp --dport 55566 -j REJECT

iptables -L


#---DNS (Minor) SETUP---#
##Subscript Name: DNS_setup
##Subscript Purpose: builds and configures server as DNS master for algon.lab domain
##Date Created: 25/06/2026 @ 01:24
##Version: 1.0.6


#Install DNS Utilities
dnf install bind bind-utils -y

#Configure DNS
sed -i 's/listen-on port 53 { 127.0.0.1; };/listen-on port 53 { 127.0.0.1; 172.16.30.50; };/g' /etc/named.conf
sed -i 's/allow-query     { localhost; };/allow-query     { localhost; 172.16.0.0\/16; };/g' /etc/named.conf
grep -v 'nameserver' /etc/resolv.conf > ./temp_file.txt
cat ./temp_file.txt > /etc/resolv.conf
echo 'nameserver 172.16.30.50' >> /etc/resolv.conf

#Creating FWD Lookup Zone
touch /etc/named/fwd.algon.lab

echo ';FWD Lookup Zone for froa0019-SRV.algon.lab' > /etc/named/fwd.algon.lab
echo ';serial number uses format of revision number + creation date' >> /etc/named/fwd.algon.lab
echo '$TTL 86400 ;24 hours' >> /etc/named/fwd.algon.lab
echo '@ IN SOA ns1.algon.lab. root.algon.lab. (' >> /etc/named/fwd.algon.lab
echo '003120626 ; Serial breakdown: revision (3), day (2), month (2), year (2).' >> /etc/named/fwd.algon.lab
echo '28800 ; Refresh (8h)' >> /etc/named/fwd.algon.lab
echo '14400 ; Retry (4h)' >> /etc/named/fwd.algon.lab
echo '604800 ; Expiry (1w)' >> /etc/named/fwd.algon.lab
echo '10800 ; Minimum TTL (3h)' >> /etc/named/fwd.algon.lab
echo ')' >> /etc/named/fwd.algon.lab
echo '; Name Server' >> /etc/named/fwd.algon.lab
echo '@ IN NS ns1.algon.lab.' >> /etc/named/fwd.algon.lab
echo '; A Record Definitions' >> /etc/named/fwd.algon.lab
echo 'ns1 IN A 172.16.30.50' >> /etc/named/fwd.algon.lab
echo '; Canonical Name/Alias' >> /etc/named/fwd.algon.lab
echo 'dns IN CNAME ns1.algon.lab.' >> /etc/named/fwd.algon.lab

#add FWD Lookup Zone to named.conf
cat <<EOF >> /etc/named.conf
zone "algon.lab" IN {
        type master;
        file "/etc/named/fwd.algon.lab";
};
EOF

systemctl restart named.service

echo "waiting for services to load"
sleep 20
#---VERIFICATION---#
iptables -L --line-numbers
dig ns1.algon.lab
cat /etc/named.conf
