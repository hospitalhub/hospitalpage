#!/bin/bash
mkdir /home/vagrant/.composer
sudo cp /vagrant/auth.json /home/vagrant/.composer/
sudo chown -R vagrant: /home/vagrant/.composer
cd /var/www
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
composer up --prefer-dist --no-interaction -v
