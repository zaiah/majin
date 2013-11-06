#!/bin/bash -
#-----------------------------------------------------#
# create_menu
#
# Creates a menu.
#-----------------------------------------------------#
create_menu() {
	# Generate a short menu of ISO files.
	# This will be coming from the databse
	# disk_img table
	printf "Please select the image you like to use for your new node:\n\n"
	declare -a avail_imgs=($(find -L "$ISO_DIR" -iname "*.iso")) 

	# Show a long menu.
	for pcount in $(seq 0 ${#avail_imgs[*]})
	do
		if [ $pcount == ${#avail_imgs[*]} ]
		then
			break
		fi	
		index=$(( $pcount + 1 ))
		printf "\t${index})${avail_imgs[${pcount}]}\n"
	done

	read ans
	n=$(( $ans - 1 ))

	# Should we have any reason to mount this?
	iso=${avail_imgs[$n]}
}
