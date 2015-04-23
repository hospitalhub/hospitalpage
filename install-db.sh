WP=/var/www
sudo cp resources/.env /root/.env
sudo -u vagrant cp resources/.env /home/vagrant/.env
cd $WP/vendor/amarcinkowski/hospitalplugin/
../../bin/doctrine orm:schema-tool:create
cd $WP/wp-content/plugins/punction/
../../../vendor/bin/doctrine orm:schema-tool:create
cd $WP/wp-content/plugins/punction/
../../../vendor/bin/doctrine orm:schema-tool:create
echo "insert into hospital_user values (1,'1','admin');" | sudo -u vagrant wp db cli
echo "INSERT INTO hospital_ward VALUES (1, 'Oddział Specjalny', 'OS', 'OS', 'Ataman Młoda Foka', 'ZZ', 0, '', '', '', '');" | sudo -u vagrant wp db cli
