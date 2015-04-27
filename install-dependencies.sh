#!/bin/bash
echo "composer@$USER"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo "adding github keys"
ssh-keyscan github.com >> ~/.ssh/known_hosts
echo "composer config install"
composer config -g github-oauth.github.com $1
cd /var/www
composer install -o --prefer-dist --no-interaction -vv
