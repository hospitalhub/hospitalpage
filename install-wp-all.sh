WP=/var/www
wp core install --url=127.0.0.1 --title=x --admin_user=root --admin_email=x@x.w --admin_password=x
wp blog create --url=127.0.0.1
wp core multisite-convert
wp plugin activate --all
wp cap add administrator raport_zakazne
wp rewrite structure '%postname%'
#wp core multisite-convert
cd vendor/amarcinkowski/hospitalplugin/
../../bin/doctrine orm:schema-tool:create
cd $WP
cd wp-content/plugins/punction/
../../../vendor/bin/doctrine orm:schema-tool:create
cd $WP
cd wp-content/plugins/punction/
../../../vendor/bin/doctrine orm:schema-tool:create
