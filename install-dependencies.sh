#!/bin/bash
cd /var/www
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
composer up -v
cp resources/.env .
