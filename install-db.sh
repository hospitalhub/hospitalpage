WP=/var/www
cd $WP
cp resources/.env ~/.env
cd vendor/amarcinkowski/hospitalplugin/
../../bin/doctrine orm:schema-tool:create
cd $WP
cd wp-content/plugins/punction/
../../../vendor/bin/doctrine orm:schema-tool:create
cd $WP
cd wp-content/plugins/punction/
../../../vendor/bin/doctrine orm:schema-tool:create
echo "insert into hospital_user values (1,'1','admin');" | wp db cli
echo "INSERT INTO `hospital`.`hospital_ward` (`id`, `name`, `infomedica`, `komorkaOrg`, `kierownik`, `typOddzialu`, `pododdzial`, `adres`, `kondygnacja`, `odcinek`, `opis`) VALUES ('1', 'Oddział Specjalny', 'OS', 'OS', 'Ataman Młoda Foka', 'ZZ', '0', '', '', '', '');" | wp db cli
