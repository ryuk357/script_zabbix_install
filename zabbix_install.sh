#!/bin/bash

#variables

#begin

echo -e " \033[032m _____   _    ____  ____ _____  __  _           _        _ _   
 |__  /  / \  | __ )| __ )_ _\ \/ / (_)_ __  ___| |_ __ _| | |  
   / /  / _ \ |  _ \|  _ \| | \  /  | | '_ \/ __| __/ _\` | | |  
  / /_ / ___ \| |_) | |_) | | /  \  | | | | \__ \ || (_| | | |_ 
 /____/_/   \_\____/|____/___/_/\_\ |_|_| |_|___/\__\__,_|_|_(_)
                                                               \033[00m "
echo -e "\033[031m____________________________________________ \033[00m"							     
echo -e "\033[031m|##########################################| \033[00m"							     
echo -e "\033[031m|##CE SCRIPT DOIT ETRE EXECUTER AVEC SUDO##| \033[00m"							     
echo -e "\033[031m|##########################################| \033[00m"							     
echo -e "\033[031m____________________________________________ \033[00m"

sleep 3
#install repository
echo -e "\033[032m Install Zabbix repository\033[00m"
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4%2Bubuntu20.04_all.deb

dpkg -i zabbix-release_6.0-4+ubuntu20.04_all.deb

apt update

echo -e "\033[032m Install zabbix server, frontend, agent\033[00m"
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

echo -e "\033[032m Install mysql\033[00m"
apt install -y mysql-server

echo -e "\033[032m Database creation + user zabbix \033[00m"
mysql -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -e "create user zabbix@localhost identified by 'password';"
mysql -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -e "set global log_bin_trust_function_creators = 1;"

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix


echo -e "\033[032m zabbix configuration modification\033[00m"
sed -i 's/# DBPassword=/DBPassword=zabbix/g' /etc/zabbix/zabbix_server.conf
systemctl restart zabbix-server zabbix-agent apache2


echo -e "\033[032m Allow 10050 & 10051\033[00m"
ufw enable 
ufw allow 10050/tcp
ufw allow 10051/tcp
ufw reload


echo -e "\033[032m Installation complete\033[00m"
echo -e "\033[032m Continue configuration -> localhost/zabbix\033[00m"
echo -e "\033[032m User : Admin 	pswd : zabbix\033[00m"
