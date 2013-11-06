#!/bin/bash -
#-----------------------------------------------------#
# create_menu
#
# Creates a menu.
#-----------------------------------------------------#
create_menu() {
	# Show a long menu.
	ISO_DIR="$HOME/vm/iso"
	declare -a AVAIL_IMGS=( $(find -L "$ISO_DIR" -iname "*.iso") ) 
	for __PCOUNT in $(seq 0 ${#AVAIL_IMGS[*]})
	do
		if [ $__PCOUNT == ${#AVAIL_IMGS[*]} ]
		then
			break
		fi	
		__AI_INDEX=$(( $__PCOUNT + 1 ))
		printf "\t${__AI_INDEX})${AVAIL_IMGS[${__PCOUNT}]}\n"
	done

	read ANS 
	__AI_USER_SEL=$(( $ANS - 1 ))

	# Should we have any reason to mount this?
	MEDIA="${AVAIL_IMGS[$__AI_USER_SEL]}"
}
