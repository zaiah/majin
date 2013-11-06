#!/bin/bash -
#------------------------------------------------------
# typecheck() 
# 
# Return on proper types...?
#-----------------------------------------------------#
typecheck() {
	# Is this null?
	if [ -z $1 ]
	then
		printf "null"

	# Is this an integer?
	else
		# Send error nowhere.
		STAT=$(echo $(( $1 )) 2>/dev/null | echo $? )

		# Still should probably catch strings.
		if [ ! $STAT == 0 ]
		then
			printf "string"
		else
			# Is string 
			printf "integer"
		fi
	fi
}
