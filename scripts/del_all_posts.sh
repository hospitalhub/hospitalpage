
#wp post delete $(wp post list --post_status=trash --format=ids)
wp post delete $(wp post list --format=ids)
wp post delete $(wp post list --post_type=page --format=ids)
