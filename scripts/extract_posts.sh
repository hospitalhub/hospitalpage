# wp post list --post_type=page --field=ID > pageid
while read p; do
  TITLE=`wp post get $p --field=post_title`
 # TITLE=${TITLE#post_title*}
 # TITLE=${TITLE:1}
 echo $TITLE
  wp post get $p --field=post_content > "post/$TITLE"
done < pageid

