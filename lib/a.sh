#!/bin/bash -

# Regen doc.
while read line
do
	# Save this b/c it's our folder name for different lib functions.
	if [[ ${line:0:1} == '#' ]] 
	then
		DIRNAME="$(echo $line | sed 's/# //' | tr [A-Z] [a-z] )"
		[ ! -d "$DIRNAME" ] && mkdir -p $DIRNAME
		continue

	# Move through blanks.
	elif [[ -z "${line}" ]]
	then
		continue	

	# You have hit gold...
	else
		FNAME="$(echo $line | awk -F ':' '{print $1}' )"
		FDESC="$(echo $line | awk -F ': ' '{print $2}' )"

		# If the file doesn't exist, create it.
		./buildopts --name $FNAME --summary "$FDESC" > ${DIRNAME}/${FNAME}.sh

		# If so, modify whatever's there already.
		# Make sure that your columnns are wrapping correctly.
	fi
done < gen.manifest
