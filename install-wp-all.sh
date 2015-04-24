cp $APP_DIR/resources/.env .
wp db create
wp core install --url=127.0.0.1 --title=x --admin_user=root --admin_email=x@x.w --admin_password=x
wp plugin activate --all
wp cap add administrator raport_zakazne
wp rewrite structure '%postname%'
#wp core multisite-convert
#wp blog create --url=127.0.0.1
