### WP-CLI
#curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#chmod +x wp-cli.phar
#sudo mv wp-cli.phar /usr/local/bin/wp
composer create-project wp-cli/wp-cli ~/wp-cli --no-dev
export PATH=$PATH:$HOME/wp-cli/bin/
mkdir ~/.wp-cli

if [ -z "$TRAVIS_PHP_VERSION" ]; then
  export WP_ADDR='127.0.0.1:8000';
  export PLATFORM='vagrant (non-travis)'
else
  export WP_ADDR='127.0.0.1';
  export PLATFORM='travis-ci'
fi
echo "path: /var/www/wp
url: $WP_ADDR" > ~/.wp-cli/config.yml
#tests scaffolding
#wp --path="wp/" scaffold plugin-tests punction

