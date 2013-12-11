# push_option_alpha() - Chooses distinct letters for options.
# If an option letter is taken, use something else within the string first.
# SLOW AS HELL!!!
declare -a OPTION_ALPHA 
push_option_alpha() {
	# Create array.
	if [ ${#OPTION_ALPHA[@]} -eq 0 ]
	then 
		#echo Not filled: ${#OPTION_ALPHA[@]}
		OPTION_ALPHA[0]="h"
		OPTION_ALPHA[1]="v"
	fi

	#echo Modified: ${#OPTION_ALPHA[@]}
	#echo $(is_element_present_in "OPTION_ALPHA" $1)

	# Push to it.
	if [ ! -z "$1" ] 
	then
		# ...
		if [ $(is_element_present_in "OPTION_ALPHA" $1) == false ]
		then
			OPTION_ALPHA[${#OPTION_ALPHA[@]}]="$1"

		# Choose a new letter.
		else
			for n in `seq 0 $(( ${#OPT_NAME} - 1 ))`
			do
				OPT_ALP_LETTER=${OPT_NAME:${n}:1}

				# Break on hyphens.
				if [[ $OPT_ALP_LETTER == '-' ]]
				then
					continue

				# Keep moving.
				elif [ $(is_element_present_in "OPTION_ALPHA" $OPT_ALP_LETTER) == false ]
				then
					OPTION_ALPHA[${#OPTION_ALPHA[@]}]=${OPT_ALP_LETTER}
					OPT_ALP_SET=true
					break
				fi
			done

			# Oh no!  What if we still couldn't find a letter?
			# (We've reached the end of the food chain...)
			# There is a better  way to do this... ( LETTERS=$( echo [a-z] ) )
			declare -a OA_LETTERS
			OA_LETTERS=(a b c d e f g h i j k l m n o p q r s t u v w x y z 1 2 3 4 5 6 7 8 9)	
			for OAL in ${OA_LETTERS[@]}
			do
				if [ $(is_element_present_in "OPTION_ALPHA" $OAL) == false ]
				then
					OPTION_ALPHA[${#OPTION_ALPHA[@]}]=${OAL}
					OPT_ALP_SET=true
					break
				fi	
			done	
		fi
	fi
#	printf ${OPTION_ALPHA[$(( ${#OPTION_ALPHA[@]} - 1 ))]}
}


# get_last_alpha() - Still unsure as to why I need this...
get_last_alpha () {
	printf ${OPTION_ALPHA[$(( ${#OPTION_ALPHA[@]} - 1 ))]}
}

