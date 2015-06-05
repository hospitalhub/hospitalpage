#!/bin/bash
echo "composer@$USER"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo "adding github keys"
ssh-keyscan github.com >> ~/.ssh/known_hosts
echo "composer config install"
composer config -g github-oauth.github.com $1
if [ "$USER" = "vagrant" ]; then
  composer config --global cache-dir /vagrant/cache/composer
  cp resources/.env /home/vagrant/.env
fi
if [ ! -d /var/www ]; then
    mkdir -p /var/www;
fi;
cd /var/www
cp resources/.env /var/www/.env
composer install -o --prefer-dist --no-interaction -v
