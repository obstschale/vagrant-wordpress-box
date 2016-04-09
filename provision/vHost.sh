#!/bin/bash

filename='/srv/config/hosts.list'
wpTemplate='https://github.com/obstschale/wordpress-project-template.git'

## Loop through all sites
#for ((i=0; i < ${#DOMAINS[@]}; i++)); do
while IFS='' read -r line || [[ -n "$line" ]]; do

    ## Current Domain
    DOMAIN=${line}
    set -- "$DOMAIN" 
    IFS=" | "; declare -a DOMAIN=($*)

    # If ${DOMAIN[0]} dir already exists we skip it and continue with next {DOMAIN[0]}
    if [ -d "/var/www/${DOMAIN[0]}" ]; then
        echo "Site ${DOMAIN[0]} exists; skip creation"
        continue
    fi

    echo "Creating directory for ${DOMAIN[0]}..."
    git clone ${wpTemplate} /var/www/${DOMAIN[0]}

    # Initialize git repo again
    sudo rm -rf /var/www/${DOMAIN[0]}/.git
    git init /var/www/${DOMAIN[0]}

    # Install Composer Dependencies
    sudo composer self-update
    cd /var/www/${DOMAIN[0]} && composer install

    # Create local-config.php for Site
    DBNAME=$( echo ${DOMAIN[0]} | sed -e 's/[^a-zA-Z0-9]/_/g')
    sudo cp /var/www/${DOMAIN[0]}/local-config-sample.php /var/www/${DOMAIN[0]}/local-config.php
    sudo sed -i s,database,${DBNAME},g /var/www/${DOMAIN[0]}/local-config.php
    sudo sed -i s,user,root,g /var/www/${DOMAIN[0]}/local-config.php
    sudo sed -i s,password,root,g /var/www/${DOMAIN[0]}/local-config.php

    echo "Creating vhost config for ${DOMAIN[0]}..."
    sudo cp /etc/apache2/sites-available/scotchbox.local.conf /etc/apache2/sites-available/${DOMAIN[0]}.conf

    echo "Updating vhost config for ${DOMAIN[0]}..."
    sudo sed -i s,scotchbox.local,${DOMAIN[0]},g /etc/apache2/sites-available/${DOMAIN[0]}.conf
    sudo sed -i s,/var/www/public,/var/www/${DOMAIN[0]}/public,g /etc/apache2/sites-available/${DOMAIN[0]}.conf

    echo "Enabling ${DOMAIN[0]}. Will probably tell you to restart Apache..."
    sudo a2ensite ${DOMAIN[0]}.conf

done < "$filename"

echo "So let's restart apache..."
sudo service apache2 restart
