#!/bin/bash
cd /vagrant
REPO_DIR=page
if [ ! -d "$REPO_DIR" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  repo=${1:$PAGE_REPO}
  if [ -z $repo ]; then
	echo "= set env PAGE_REPO=https://....git"
  else
	rm -rf $REPO_DIR
	git clone $repo
  fi
fi
command -v wp >/dev/null 2>&1 || { echo >&2 "I require wp but it's not installed.  Aborting."; exit 1; }
cd $REPO_DIR
echo "PWD:$PWD"
CATEGORIES=(page post)
# echo "no comments allowed"
wp option set default_comment_status Disallow
# echo "flat media structure"
wp option set uploads_use_yearmonth_folders 0
# iterate over array
shopt -s globstar

function add_img {
	#img_path="${2/$CATEGORY/images\/$CATEGORY}"
	img_path="$2";
	alt="$3";
	if [ -e "$img_path.jpg" ]; then
        # echo "|   pic: $img_path.jpg"
        type="jpg"
	elif [ -e "$img_path.png" ]; then
        # echo "|   pic: $img_path.png"
        type="png"
	else
        type=
	fi
	# if image exists
	if [ -z "$type" ]; then
        echo "WARN  no pic for $img_path"
	else
        wp media import "$img_path"."$type" --post_id="$1" --title="$alt" --caption="To jest obrazek do wpisu pt. $alt" --alt="$alt" --featured_image 
        echo "INFO  import image $img_path.$type"
	fi
}

function tag {
    # add category & tag for non-page type
    if [ "$2" == page* ]; then
        # echo "WARN   no tag for page"
        PAGE=1
    else
	    last_tag="${2##*\/}";
        IFS='/' tags=($2);
		# echo ;
        for tag in "${tags[@]}" ;do
        	if [ "$tag" == post ] || [ "$tag" == page ]; then
        		continue
        	fi
        	removeLeadingNumbers "$tag" sorted_tag
            echo "INFO tag $sorted_tag"
            wp post term add `echo $1` post_tag "$sorted_tag" 1>>log
        done
	#many tags / one category (parent dir)
		if [ ${#tags[@]} -gt 1 ]; then
		    removeLeadingNumbers "${tags[-1]}" category
			echo "category $category"
	        wp post term add `echo $1` category "$category" 1>>log
		fi
    fi
}

function create {
	echo "==== $1 ===="
	directory="${1%\/*}"
	filename="${1#$directory\/}"
	removeLeadingNumbers "$filename" title
	echo "INFO  adding >>$title<< ($directory)"
	# if in folder page then add as a page (path starts with page)
	if [ "$directory" == page* ]; then
		POST_TYPE="--post_type=page"
		echo "INFO  post type: PAGE"
	else
		POST_TYPE=""
	fi
	# id is post ID
	id=`wp post create "$1" --post_title="$title" $POST_TYPE --post_status=publish --porcelain`; 
	add_img "$id" "$1" "$title"
	tag "$id" "$directory"
}

function removeLeadingNumbers {
	local  __resultvar=$2
	number="[0-9]+ "
	if [[ "$1" =~ ^[0-9]*\  ]]; then
		title=`echo ${1} | sed 's/^[0-9 ]\{1,4\}//'`
	else
		title=$1
	fi
    eval $__resultvar="'$title'"
}

function hashFunction {
	local  __resultvar=$2
    hash=`echo -n $1 | md5sum`
    hash=${hash%*  -}
    eval $__resultvar="'$hash'"
}

function categoryHierarchy {
	IFS='/' dirs=($1);
    for dir in "${dirs[@]}" ;do
        if [ "$dir" == post ] || [ "$dir" == page ]; then
            continue
        fi
        removeLeadingNumbers "$dir" dir
        hashFunction "$dir" hash
        echo "INFO  creating tag $dir"
        wp term create category $dir 1>>log 2>>log
        id=`wp term list category --name=$dir --field=id`;
		declare "TERM_ID_$hash=$id"
        # create parent
        if [ -n "$last_dir" ]; then
	        hashFunction "$last_dir" parent_hash
        	parent_category_id_var="TERM_ID_$parent_hash";
	        echo "INFO  hierarchy: $last_dir -> $dir"
			wp term update category `echo ${id}` --parent=`echo ${!parent_category_id_var}` 1>>log 2>>log
        fi
        last_dir=$dir
        id=
    done
    last_dir=
}

for CATEGORY in ${CATEGORIES[@]}; do
	# iterate over files in directories
	 echo "CATEGORY:$CATEGORY"
	find $CATEGORY -type d -printf '%h\0%d\0%p\n'| sort -t '\0' -n | awk -F'\0' '{print $3}' | while read path; do
		echo "PATH:$path"
		categoryHierarchy "$path"
	done
	find $CATEGORY -type f -printf '%h\0%d\0%p\n'| sort -t '\0' -nr | awk -F'\0' '{print $3}' | while read filepath; do
		# echo "INFO  $CATEGORY : $filepath"
		if [[ "$filepath" == *.sh ]] || [[ "$filepath" == *.sql ]]  || [[ "$filepath" == *.jpg ]] || [[ "$filepath" == *.png ]]; then
			echo "WARN  skipping images and scripts $filepath"
		else
			echo ;
			create "$filepath"
		fi
	done
done
echo "================"
echo "Loading settings"
for SCRIPT in settings/*; do
	echo "INFO  runnging script $SCRIPT"
	. $SCRIPT
done

echo "================"
echo "Loading db"
for SCRIPT in sql/*; do
	echo "INFO  loading db $SCRIPT"
	wp db import "$SCRIPT"
done
