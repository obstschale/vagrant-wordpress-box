#!/bin/bash

filename='/srv/config/hosts.list'
wpTemplate='https://github.com/obstschale/wordpress-project-template.git'

## Loop through all sites
#for ((i=0; i < ${#DOMAINS[@]}; i++)); do
while IFS='' read -r line || [[ -n "$line" ]]; do

    ## Current Domain
#    DOMAIN=${DOMAINS[$i]}
    DOMAIN=${line}

    # If $DOMAIN dir already exists we skip it and continue with next DOMAIN
    if [ -d "/var/www/$DOMAIN" ]; then
        echo "Site $DOMAIN exists; skip creation"
        continue
    fi

    echo "Creating directory for $DOMAIN..."
    git clone ${wpTemplate} /var/www/$DOMAIN

    # Initialize git repo again
    sudo rm -rf /var/www/$DOMAIN/.git
    git init /var/www/$DOMAIN

    echo "Creating vhost config for $DOMAIN..."
    sudo cp /etc/apache2/sites-available/scotchbox.local.conf /etc/apache2/sites-available/$DOMAIN.conf

    echo "Updating vhost config for $DOMAIN..."
    sudo sed -i s,scotchbox.local,$DOMAIN,g /etc/apache2/sites-available/$DOMAIN.conf
    sudo sed -i s,/var/www/public,/var/www/$DOMAIN/public,g /etc/apache2/sites-available/$DOMAIN.conf

    echo "Enabling $DOMAIN. Will probably tell you to restart Apache..."
    sudo a2ensite $DOMAIN.conf

done < "$filename"

echo "So let's restart apache..."
sudo service apache2 restart
