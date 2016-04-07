#!/bin/bash

filename='/srv/config/hosts.list'

# http://stackoverflow.com/questions/10929453/bash-scripting-read-file-line-by-line
while IFS='' read -r line || [[ -n "$line" ]]; do
    DBNAME=$( echo ${line} | sed -e 's/[\.;:?! ]/_/g')
    echo "Create DB if does not exist already: $DBNAME"
    sudo mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS $DBNAME;"
done < "$filename"