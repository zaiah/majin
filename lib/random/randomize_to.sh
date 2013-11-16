#!/bin/bash -
#-----------------------------------------------------#
# randomize_to
#
# Returns a string with characters in random order with length $1.
#-----------------------------------------------------#
randomize_to() {
	# ...
	WORD="0123456789abcdefghijklmnopqrstuvwxyz"

	# ...
	LETTERS=( $(echo $1 | \
		tr -s ' ' '_' | \
		sed 's/\(.\)/\1 /g') )

	declare -a NEW_LETTERS
	STRING=""
	RANGE=${#LETTERS[@]}
	C=0	
	for E in ${LETTERS[@]}
	do
		if [ ! -z $NUM ]
		then
			OLDNUM=$NUM
		else
			NUM=$RANDOM
			let "NUM %= $RANGE"
			OLDNUM=-1
		fi

		while [ $NUM -ge $RANGE ] || [ $NUM -eq $OLDNUM ] 
		do
			NUM=$RANDOM
			let "NUM %= $RANGE"
		done
		STRING=${STRING}${LETTERS[$NUM]}
	done

	echo $STRING
}