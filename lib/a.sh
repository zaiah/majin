#!/bin/bash -

BUILD_OPTS="../buildopts"
MAIN_MANIFEST="gen.manifest"
LOOKUP_MANIFEST="lookup.manifest"
PRG_MANIFEST="progress.manifest" # Hopefully will help track progress...

# This file is going to blow away some things.
[ -f "$LOOKUP_MANIFEST" ] && rm $LOOKUP_MANIFEST
[ -f "$PRG_MANIFEST" ] && rm $PRG_MANIFEST

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
		FILE_REF="$DIRNAME/$FNAME.sh"

		# If the file doesn't exist, create it.
		if [ ! -f "$FILE_REF" ] 
		then
			$BUILD_OPTS --name $FNAME --summary "$FDESC" > "$FILE_REF"
			
		# If it does, just modify it. 
		# (The description that is...)
		else
			# Message
			[ ! -z $VERBOSE ] && echo "Recreating $FILE_REF"

			# Iterate through file finding last line with '#'.
			FO=
			COUNTER=1
			LIM=$(wc -l $FILE_REF | awk '{print $1}')
			while read char
			do
				if [[ ! ${char:0:1} == '#' ]]
				then 
					FO=$COUNTER 
					break
				fi
				COUNTER=$(( $COUNTER + 1 ))
			done < "$FILE_REF"
			unset COUNTER

			# Regenerate.
			if [ ! -z $FO ]
			then
				BUFFER=$(sed -n ${FO},${LIM}p < "$FILE_REF")
				$BUILD_OPTS --name $FNAME --summary "$FDESC" > "$FILE_REF"
				printf "$BUFFER" >> $FILE_REF
		#		echo $BUFFER >> "$FILE_REF"

			# Generate again with new documentation.
			else
				$BUILD_OPTS --name $FNAME --summary "$FDESC" > "$FILE_REF"
			fi
		fi

		# Also create a lookup table easily grepped with sed.
		printf "${FNAME}:${DIRNAME}/${FNAME}.sh\n" >> $LOOKUP_MANIFEST

		# If so, modify whatever's there already.
		# Make sure that your columnns are wrapping correctly.

		# This is debugging mostly...
		printf "${FNAME}:${DIRNAME}/${FNAME}.sh\n" >> $PRG_MANIFEST
	fi
done < gen.manifest
