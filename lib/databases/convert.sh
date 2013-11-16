#!/bin/bash -
#-----------------------------------------------------#
# convert
#
# Prepares records to be placed into a SQLite 3 database.
#-----------------------------------------------------#
convert() {
	# Is this null?
	if [ -z $1 ]
	then
		printf "''"

	# Is this an integer?
	else
		# Send error nowhere.
		STAT=$(echo $(( $1 )) 2>/dev/null | echo $? )

		# Still should probably catch strings.
		if [ ! $STAT == 0 ]
		then
			printf "'$1'"
		else
			# Is string 
			printf $1 
		fi
	fi
}