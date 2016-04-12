#!/bin/bash

function message() {
	echo -e "\033[0;32m$1\033[0m"
}

read -p "Enter Domain to delete: " DOMAIN

if [[ ! ${DOMAIN} ]]; then
	exit
fi

message "==> delete: webroot for: ${DOMAIN}"
vagrant ssh -c "sudo rm -rf /var/www/${DOMAIN}"
message "==> delete: apache2 configs for: ${DOMAIN}"
vagrant ssh -c "sudo rm -rf /etc/apache2/sites-available/${DOMAIN}.conf /etc/apache2/sites-enabled/${DOMAIN}.conf"

message "==> delete: MySQL DB for: ${DOMAIN}"
DBNAME=$( echo ${DOMAIN[0]} | sed -e 's/[^a-zA-Z0-9]/_/g')
vagrant ssh -c "echo 'DROP DATABASE ${DBNAME};' | mysql -u root -proot"

message "==> delete: Domain from hosts.list"
vagrant ssh -c "grep -v ${DOMAIN} /srv/config/hosts.list > /srv/config/new.list && sudo rm /srv/config/hosts.list && mv /srv/config/new.list /srv/config/hosts.list"

message "==> Reload Vagrant Machine"
vagrant reload