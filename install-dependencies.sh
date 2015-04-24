#!/bin/bash
COMPOSER_CACHE_DIR=/dev/null
cd /var/www
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
sudo -u vagrant composer config -g github-oauth.github.com $1
sudo -u vagrant composer up -o --prefer-dist --no-interaction -vv --no-dev
