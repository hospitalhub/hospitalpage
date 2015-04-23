WP=/var/www
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
