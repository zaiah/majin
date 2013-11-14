#!/bin/bash -
#-----------------------------------------------------#
# randomize
#
# Returns a string $1 with its characters in random order.
#-----------------------------------------------------#
randomize() {
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
