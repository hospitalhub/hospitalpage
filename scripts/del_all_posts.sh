
#wp post delete $(wp post list --post_status=trash --format=ids)
wp post delete $(wp post list --format=ids)
wp post delete $(wp post list --post_type=page --format=ids)
wp term delete post_tag $(wp term list post_tag --field=id --format=ids)
wp term delete category $(wp term list category --field=id --format=ids)
