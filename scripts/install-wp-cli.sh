### WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
mkdir ~/.wp-cli
echo "path: /var/www/wp
url: 127.0.0.1:8000" > ~/.wp-cli/config.yml
#tests scaffolding
#wp --path="wp/" scaffold plugin-tests punction
