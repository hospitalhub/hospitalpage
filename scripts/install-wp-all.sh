#!/bin/bash
cd /var/www
export MULTISITE=false
wp db create
wp core install --url=127.0.0.1 --title=x --admin_user=root --admin_email=x@x.w --admin_password=pass
wp core language activate pl_PL
wp plugin activate --all
wp theme activate responsive-child
wp cap add administrator raport_zakazne
wp cap add administrator raporty_zakazne_zbiorczy
wp cap add administrator edit_pacjents
wp cap add administrator read_pacjenci_wszystkie_oddz
wp rewrite structure '%postname%'
export MULTISITE=true
#wp core multisite-convert
wp blog create --url=127.0.0.1
wp rewrite structure '%postname%'
