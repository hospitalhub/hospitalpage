#!/usr/bin/env bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
fi
echo "running install server"

export DEBIAN_FRONTEND=noninteractive

function mysql {
  echo "mysql-server mysql-server/root_password password $DB_PASSWORD" | debconf-set-selections
  echo "mysql-server mysql-server/root_password_again password $DB_PASSWORD" | debconf-set-selections 
  apt-get install -y mysql-server 2> /dev/null
  apt-get install -y mysql-client 2> /dev/null
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
  # apache conf
  export DB_USER=root
  export DB_PASSWORD=pass
    sudo "deb http://archive.ubuntu.com/ubuntu trusty multiverse
deb http://archive.ubuntu.com/ubuntu trusty-updates multiverse
deb http://security.ubuntu.com/ubuntu trusty-security multiverse" >> /etc/apt/sources.list
  apt-get update 2>/dev/null 2>&1
  mysql
  echo "installing apache2 php5..."
  apt-get install -y php5 php5-mysql php5-curl phpunit subversion nodejs git 2>/dev/null 2>&1
  apt-get install -y apache2 2> /dev/null 2>&1
  # multiverse (libapache2-mod-php5)
  apt-get install -y libapache2-mod-php5 php5-fpm apache2-mpm-event apache2-mpm-worker
  cp /var/www/resources/vagrant-apache /etc/apache2/sites-available/000-default.conf
  a2dismod php5 mpm_prefork
  a2enmod fastcgi rewrite actions alias mpm_worker
  touch /usr/lib/cgi-bin/php5.fcgi
  chown -R www-data:www-data /usr/lib/cgi-bin
  echo "<IfModule mod_fastcgi.c> 
   AddHandler php5.fcgi .php 
   Action php5.fcgi /php5.fcgi 
   Alias /php5.fcgi /usr/lib/cgi-bin/php5.fcgi 
   FastCgiExternalServer /usr/lib/cgi-bin/php5.fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization -idle-timeout 3600 
   <Directory /usr/lib/cgi-bin>
       Require all granted
   </Directory> 
</IfModule>" > /etc/apache2/conf-available/php5-fpm.conf
  a2enconf php5-fpm
  service apache2 restart && sudo service php5-fpm restart
  # non-travis vagrant phpmyadmin
  if [ -d "/home/vagrant" ]; then
    phpmyadmin_at_vagrant
  fi
  # Configure custom domain
  echo "127.0.0.1 mydomain.local" | tee --append /etc/hosts
else
  echo "@travis";
  sudo apt-get update
  sudo cp ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf.default ~/.phpenv/versions/$(phpenv version-name)/etc/php-fpm.conf
  echo "cgi.fix_pathinfo = 1" >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
  ~/.phpenv/versions/$(phpenv version-name)/sbin/php-fpm
  export DB_USER=root
  export DB_PASSWORD=
  sudo a2enmod rewrite actions fastcgi alias
  sudo service apache2 restart
fi
