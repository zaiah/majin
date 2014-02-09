# Stop and return block til character (using wc -b)
#------------------------------------------------------
# search_for() 
# 
# Search for a string of text ($1) within a script
# file, paying attention to syntax rules.
#
# With BASH there are a ton of stupid rules to keep
# in mind.
# comments (#) for one
# } b/c it can be a var
#-----------------------------------------------------#
search_for() {
	# Harvest...
	while [ $# -gt 0 ]
	do
		case "$1" in
			-i|--in)
				shift
				__BLOCK__="$1"
			;;
			-c|--char|--this)
				shift
				__FIND__="${1:0:1}"
			;;
			-s|--string)
				shift
				__CHAR__="$1"
			;;
		esac
		shift
	done

	# Probably ought to check if getting the block works...
#	printf "%s" "$__BLOCK__"

	# Escape any funny characters. 
	__BLOCK__="$(printf "%s" "$__BLOCK__")"

	# Define a new line here.
NEWLINE="
"

	# Iterate through string supplied via $__BLOCK__
	for __CHAR__ in `seq 0 ${#__BLOCK__}`
	do
		# Get the next character if match was !
		# If not move on.
		CHAR_1="${__BLOCK__:$__CHAR__:1}"

		# Newlines typically mean the end of comments.
		if [[ $CHAR_1 == $NEWLINE ]] 
		then 
			IN_COMM=false 
			IN_VAR=false
			continue 
		fi

		
		# If it's in a var, need to skip.
		if [[ $CHAR_1 == '$' ]] && \
			[[ ${__BLOCK__:$(( $__CHAR__ + 1 )):1} == '{' ]]
		then 
			IN_VAR=true && continue
		fi

		[[ "$CHAR_1" == '{' ]] && [ "$IN_VAR" == true ] && continue

		[[ $CHAR_1 == '}' ]] && [ "$IN_VAR" == true ] && {
			IN_VAR=false
			continue
		}	

		# If it's in a comment, need to skip.
		if [[ $CHAR_1 == '#' ]] 
		then
			[ ! -z $IN_VAR ] && IN_COMM=true && continue
		fi

		# If it's a string we need to skip.
		if [[ ${CHAR_1} == "'" ]] || [[ ${CHAR_1} == '"' ]]
		then
			if [ -z $IN_STR ] 
			then
				IN_STR=true 
			
			elif [ $IN_STR == false ] 
			then 
				IN_STR=true 

			elif [ $IN_STR == true ] 
			then 
				IN_STR=false
			fi
			continue	
		fi

		# If you find it, great!
		if [[ $CHAR_1 == $__FIND__ ]] 
		then
	#		printf ${__BLOCK__:$(( $__CHAR__ - 10  )):10} > /dev/stderr
	#		printf s $IN_STR > /dev/stderr
	#		printf c $IN_COMM > /dev/stderr
			if [ "$IN_STR" == true ] || [ "$IN_COMM" == true ] 
			then 
				continue 
#				printf $__FIND__
			fi
			printf $__CHAR__
			break
		fi
	done

#			printf "Found '$__FIND__' at $__CHAR__"
	exit
}
