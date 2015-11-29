#!/bin/bash


function files_edit {
# ADDRESSBOOK settings
	cd /var/www
	if [ ! -L 'book' ]; then ln -s vendor/addressbook/addressbook book;fi
	cat resources/cfg.db.php > book/config/cfg.db.php
	sed -i -e "s/?>/\$iplist['*.*.*.*']['role']  = "readonly";\n?>/g" -e "s/\$userlist/\/\//g" book/config/cfg.user.php
	sed -i -e 's/?>/$disp_cols = array("last_first", "all_phones");\n?>/g' book/config/config.php
	sed -i -e "s/<br \/>//g" -e "s/<hr \/>//g" -e "s/style=/x=/g" -e "s/button\"/\" style=\"visibility: hidden; display: none;\"/g"   book/index.php
	echo "" > book/include/footer.inc.php > book/include/header.inc.php > book/include/format.inc.php 
}

files_edit
