#!/bin/bash
if [ -z "$TRAVIS_PHP_VERSION" ]; then
  export WP_ADDR='127.0.0.1:8000';
  export PLATFORM='vagrant (non-travis)'
  cd /var/www
else
  export WP_ADDR='127.0.0.1';
  export PLATFORM='travis-ci'
fi
echo "PLATFORM:$PLATFORM WP_ADDR:$WP_ADDR PWD:$pwd";
sed -i.bak "s/DOMAIN_CURRENT_SITE', WP_ADDR/DOMAIN_CURRENT_SITE', '$WP_ADDR'/g" wp-config.php
wp db create
wp core multisite-install --url=127.0.0.1 --base=127.0.0.1 --title=x --admin_user=root --admin_email=x@x.w --admin_password=pass
wp rewrite structure '%postname%'
wp core language activate pl_PL
wp plugin activate --all
wp theme activate accesspress-parallax-child
wp cap add administrator raport_zakazne
wp cap add administrator raporty_zakazne_zbiorczy
wp cap add administrator edit_pacjents
wp cap add administrator read_pacjenci_wszystkie_oddz
sed -i.bak "s/_SITE', '$WP_ADDR'/_SITE', WP_ADDR/g" wp-config.php
rm wp-config.php.bak
