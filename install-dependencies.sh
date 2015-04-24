#!/bin/bash
COMPOSER_CACHE_DIR=/dev/null
echo "composer@$USER"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
ssh-keyscan github.com >> ~/.ssh/known_hosts
composer config -g github-oauth.github.com $1
cd $APP_DIR
composer install -o --prefer-dist --no-interaction -vv --no-dev
