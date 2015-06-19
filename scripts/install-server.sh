#!/usr/bin/env bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
fi
echo "running install server"

# Install everything
export DEBIAN_FRONTEND=noninteractive
#echo "ubuntu apt get update"
#apt-get update 2>/dev/null 2>&1

function mysql {
  echo "mysql-server mysql-server/root_password password $DB_PASSWORD" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $DB_PASSWORD" | debconf-set-selections 
  apt-get install -y mysql-server 2> /dev/null
  apt-get install -y mysql-client 2> /dev/null
}

function php5 {
  sudo apt-get install -y php5 php5-fpm php5-mysql php5-curl phpunit subversion nodejs git 2>&1
}

function apache {
  echo "installing apache2 php5..."
  sudo apt-get install -y apache2 libapache2-mod-php5 2> /dev/null 2>&1

  # Configure Apache
  WEBROOT="%WEBROOT%"
  CGIROOT=`dirname "$(which php-cgi)"`
  echo "WEBROOT: $WEBROOT"
 # echo "CGIROOT: $CGIROOT"
  sudo echo "<VirtualHost *:80>
        DocumentRoot $WEBROOT
        <Directory />
          Options FollowSymLinks
          AllowOverride All
        </Directory>
        <Directory $WEBROOT >
          Options Indexes FollowSymLinks MultiViews ExecCGI
          AllowOverride All
          Order allow,deny
          Allow from all
        </Directory>
        <IfModule mod_fastcgi.c>
          AddHandler php5-fcgi .php
          Action php5-fcgi /php5-fcgi
          Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
          FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -host 127.0.0.1:9000 -pass-header Authorization
        </IfModule>        
        
        # Configure PHP as CGI
#        ScriptAlias /local-bin $CGIROOT
#        DirectoryIndex index.php index.html
#        AddType application/x-httpd-php5 .php
#        Action application/x-httpd-php5 '/local-bin/php-cgi'
        </VirtualHost>" > /etc/apache2/sites-available/$1

}

function phpmyadmin_at_vagrant {
  echo "make mysql accessible from outside of localhost"
  sed -i.bak s/skip-external-locking/#/g /etc/mysql/my.cnf
  sed -i.bak s/bind-address/#/g /etc/mysql/my.cnf
  mysql -u root -p$DB_PASSWORD -e "grant all privileges on *.* to 'root'@'%' identified by '$DB_PASSWORD'; flush privileges;";
  sudo service mysql restart
  echo "phpmyadmin@vagrant"
  echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
  echo "phpmyadmin phpmyadmin/app-password-confirm password $DB_PASSWORD" | debconf-set-selections
  echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DB_PASSWORD" | debconf-set-selections
  echo "phpmyadmin phpmyadmin/mysql/app-pass password $DB_PASSWORD" | debconf-set-selections
  echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
  apt-get -y install phpmyadmin 
  echo "phpmyadmin installed"
}

#=================================================================
if [ -z "$TRAVIS_PHP_VERSION" ]; then
  echo "non-travis";
  # Configure custom domain
  echo "127.0.0.1 mydomain.local" | tee --append /etc/hosts
  # apache conf
  export DB_USER=root
  export DB_PASSWORD=pass
  mysql
  php5
  apache 000-default.conf
  sudo sed -e "s?%WEBROOT%?/var/www?g" --in-place /etc/apache2/sites-available/000-default.conf
  # non-travis vagrant phpmyadmin
  if [ -d "/home/vagrant" ]; then
    phpmyadmin_at_vagrant
  fi
else
  echo "@travis";
  sudo apt-get update
  sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
  echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
  ~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm
  export DB_USER=root
  export DB_PASSWORD=
  apache default.conf
  sudo sed -e "s?%WEBROOT%?$(pwd)?g" --in-place /etc/apache2/sites-available/default.conf
fi

sudo a2enmod rewrite actions fastcgi alias
sudo service apache2 restart
