
extract_real_match () {
	# Set a name.
	[ -z "$NAME" ] && NAME="$FEXNAME"

	# Find the function name within the file.
	# (Example: $PROGRAM -x pear --from mega.sh)
	# 
	# What if there are multiple of the same name?
	# If a conflict like this is found, best to examine
	# both functions as temporary files or let the user know.
	#
	# Find the line number containing our name, if more
	# than one match, handle it properly.
	SLA="$(grep --line-number "$FEXNAME" $FROM | \
		awk -F ':' '{ print $1 }')"

	# Could have many matches.
	[ ! -z "$SLA" ] && SLA=( $SLA )

	# In said line, check to make sure that $FEXNAME 
	# is actually $FEXNAME and not part of something else.
	for POSS_RANGE in ${SLA[@]}
	do
		# Process this one line.
		FEXSRC="$(sed -n ${POSS_RANGE}p ${FROM} 2>/dev/null)"

		# Disregard comment blocks.
		[[ "$FEXSRC" =~ "#" ]] && {
			# Check everything before the first comment.
			FEXSRC="${FEXSRC%%#*}"
		}

		# If matched line doesn't contain (), next match. 
		[[ ! "$FEXSRC" =~ "(" ]] || [[ ! "$FEXSRC" =~ ")" ]] && {
			continue	
		}

		# Remove leading white space and function wraps...
		FEXLINE="$( printf "%s" $FEXSRC | \
			sed "s/^[ \t]*\($FEXNAME\).*/\1/g")" 

		# ... to check if script received an accurate match.
		[[ ! "$FEXLINE" == $FEXNAME ]] && {
			continue	
		}

		# If all checks are good, there's the line range.
		SL=$POSS_RANGE
		break
	done
}
