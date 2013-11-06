#!/bin/bash -

BUILD_OPTS="../buildopts"
MAIN_MANIFEST="gen.manifest"
LOOKUP_MANIFEST="lookup.manifest"
PRG_MANIFEST="progress.manifest" # Hopefully will help track progress...

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
		if [ ! -f "$DIRNAME/$FNAME.sh" ] 
		then
			$BUILD_OPTS --name $FNAME --summary "$FDESC" > ${DIRNAME}/${FNAME}.sh

		# If it does, just modify it. 
		# (The description that is...)
		else
			# sed ....
			echo '...'
		fi

		# Also create a lookup table easily grepped with sed.
		printf "${FNAME}:${DIRNAME}/${FNAME}.sh\n" > $LOOKUP_MANIFEST

		# If so, modify whatever's there already.
		# Make sure that your columnns are wrapping correctly.
		printf "${FNAME}:${DIRNAME}/${FNAME}.sh\n" > $PRG_MANIFEST
	fi
done < gen.manifest
