#!/bin/bash
repo=${1:$PAGE_REPO}
if [ -z $repo ]; then
	echo "set env PAGE_REPO=https://....git"
	exit
fi
git clone $repo
command -v wp >/dev/null 2>&1 || { echo >&2 "I require wp but it's not installed.  Aborting."; exit 1; }
cd page
CATEGORIES=(page post)
# echo "no comments allowed"
wp option set default_comment_status Disallow
# echo "flat media structure"
wp option set uploads_use_yearmonth_folders 0
# iterate over array
shopt -s globstar

function add_img {
        i="${2/$CATEGORY/images\/$CATEGORY}"
        if [ -e "$i.jpg" ]; then
                echo "|   pic: $i.jpg"
                type="jpg"
        elif [ -e "$i.png" ]; then
                echo "|   pic: $i.png"
                type="png"
        else
                type=
        fi
        # if image exists
        if [ -z "$type" ]; then
                echo "|   no pic for $i"
        else
                wp media import "$i"."$type" --post_id="$1" --featured_image
        fi
}

function tag {
        # add category & tag for non-page type
        if [ "$2" == page* ]; then
                echo "|   no tag for page"
        else
                last_tag="${2##*\/}";
                IFS='/' tags=($2);
		echo ;
                for tag in "${tags[@]}" ;do
			echo "tag $tag"
                        wp post term add `echo $1` category $tag
                        wp post term add `echo $1` post_tag $tag
                done
        fi
}

function create {
	echo "
--------------------------------------------------
= $1"
	directory="${1%\/*}"
	title="${1#$directory\/}"
	number="[0-9]+ "
	if [[ "$title" =~ ^[0-9]* ]]; then
		title=`echo ${title} | sed 's/^[0-9 ]\{1,4\}//'`
		echo "num $title"
	fi
	echo "|  adding post $title from $directory"
	# if in folder page then add as a page (path starts with page)
	if [ "$directory" == page* ]; then
		POST_TYPE="--post_type=page"
		echo "| post type: PAGE"
	else
		POST_TYPE=""
	fi
	# x is post ID
	id=`wp post create "$1" --post_title="$title" $POST_TYPE --post_status=publish --porcelain`; 
	echo "| id=$id"
	add_img "$id" "$1"
	tag "$id" "$directory"
}

for CATEGORY in ${CATEGORIES[@]}; do
 # iterate over files in directories
 echo "$CATEGORY"
 find $CATEGORY -type f -printf '%h\0%d\0%p\n'| sort -t '\0' -nr | awk -F'\0' '{print $3}' | while read filepath; do
	echo "$CATEGORY : $filepath"
	create "$filepath"
 done
done
for SCRIPT in settings/*; do
	echo "runnging script $SCRIPT"
	. $SCRIPT
done
