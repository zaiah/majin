#-----------------------------------------------------#
# save
#
# Saves the output of a stream to a variable without the means of a subshell.
#-----------------------------------------------------#
save() {
	local LIBPROGRAM="save"
	local INDEX=
	local VERBOSE=
	
	# save_usage - Show usage message and die with $STATUS
	save_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -tivh ]
	
	-t | --to <arg>               desc
	-i | --index <arg>            desc
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && save_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -t|--to)
	         DO_TO=true
	         shift
	         TO="$1"
	      ;;
	     -i|--index)
	         DO_INDEX=true
	         shift
	         INDEX="$1"
	      ;;
	     -d|--diag|--diagnostic)
	        DO_DIAG=true
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        	save_usage 0
	      ;;
	     --) break;;
	     -*)
	     		printf "Unknown argument received.\n" > /dev/stderr;
	     		save_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done

	# Save the variable.
	[ ! -z $DO_TO ] && [ ! -z $TO ] && {
		[ ! -z $DO_DIAG ] && {
			echo "Value of \$TO before eval run."
			echo $TO
			echo ${!TO}
			echo "============"
		}
	
		# Full test.
		# echo "Entire /dev/stdin:"
		# cat /dev/stdin
		# echo "=================="

		# Should run the eval.
		# MEGA=</dev/stdin
		# MEGA="$(</dev/stdin)"
		# TO="$MEGA"

#		 echo "ur so catty"
		 MEGA=$(printf -- "%s\n" "$(cat /dev/stdin)")
#		 echo "=================="

#		 echo "$TO=\"$MEGA\""
#		 eval '${TO}="'"$MEGA\""

		 # echo "$MEGA"
		# echo "${TO}='$(</dev/stdin)'"
		# eval "${TO}=\"<$(cat /dev/stdin)\""
		#eval "${TO}=\"$MEGA\""

		[ ! -z $DO_DIAG ] && {
			echo "Value of \$TO after eval run:"
			echo "$TO"
			printf "%s\n" "${!TO}"
			echo "============"
		}
	}
}
