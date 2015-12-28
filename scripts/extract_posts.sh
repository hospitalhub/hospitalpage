while read p; do
  PARENT=`wp post get $p --field=post_parent`
  TITLE=`wp post get $p --field=post_title | tr '\n' ' '`
  if [ $PARENT -gt 0 ]; then
   PARENT_TITLE=`wp post get $PARENT --field=post_title | tr '\n' ' '`
   FILENAME="$PARENT_TITLE $TITLE"
  else
   FILENAME="$TITLE"
  fi
 echo "extracting $FILENAME"
 # TITLE=${TITLE#post_title*}
 # TITLE=${TITLE:1}
 wp post get $p --field=post_content > "post/$FILENAME"
done < pageid
