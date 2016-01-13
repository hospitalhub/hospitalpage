#!/bin/bash
PATH=$PATH:/home/ubuntu
if [ -n "$DOCKER" ]; then
  export IP='172.17.0.2';
  export PLATFORM='docker'
elif [ -n "$TRAVIS_PHP_VERSION" ]; then
  export IP='127.0.0.1';
  export PLATFORM='travis-ci'
elif [ "$HOME" == "/home/vagrant" ]; then
  export IP='127.0.0.1';
  export PORT=":8000";
  export PLATFORM='vagrant (shell provider)'
  cd /var/www
else
  export IP='46.238.114.180';
  export PLATFORM='production'
fi
export WP_ADDR="$IP$PORT"
echo "PLATFORM:$PLATFORM WP_ADDR:$WP_ADDR PWD:$pwd";
sed -i.bak "s/DOMAIN_CURRENT_SITE', WP_ADDR/DOMAIN_CURRENT_SITE', '$WP_ADDR'/g" wp-config.php
wp db create
wp core multisite-install --url=$IP --base=$IP --title=x --admin_user=root --admin_email=x@x.w --admin_password=pass
echo "POST CREATE $IP"
wp rewrite structure '%postname%'
wp core language activate pl_PL
wp plugin activate --all
wp theme activate accesspress-parallax-child
wp cap add administrator raport_zakazne
wp cap add administrator raporty_zakazne_zbiorczy
wp cap add administrator edit_pacjents
wp cap add administrator read_pacjenci_wszystkie_oddz
#wp --require=example.php example hello Newman
sed -i.bak "s/_SITE', '$WP_ADDR'/_SITE', WP_ADDR/g" wp-config.php
rm wp-config.php.bak
wp option set blog_upload_space 65536
