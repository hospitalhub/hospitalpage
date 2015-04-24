#!/bin/bash
cd /var/www
cp resources/.env .
wp db create
wp core install --url=127.0.0.1 --title=x --admin_user=root --admin_email=x@x.w --admin_password=x
wp plugin activate --all
wp cap add administrator raport_zakazne
wp cap add administrator raporty_zakazne_zbiorczy
wp cap add administrator edit_pacjents
wp cap add administrator read_pacjenci_wszystkie_oddz
wp rewrite structure '%postname%'
wp core multisite-convert
wp blog create --url=127.0.0.1
