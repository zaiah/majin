#-----------------------------------------------------#
# dfc
#
# Does some quick checks for common file descriptors.
#-----------------------------------------------------#
fd() {
	# Static variables
	STDERR="/dev/stderr"
	STDOUT="/dev/stdout"
	STDIN="/dev/stdin"

	# Program name.
	local LIBPROGRAM="dfc"
	
	# dfc_usage - Show usage message and die with $STATUS
	dfc_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-l | --list                   Return a list of valid file descriptors. 
	-e | --stderr                 Return the first valid file descriptor 
                                 for standard error.
	-o | --stdout                 Return the first valid file descriptor 
                                 for standard output. 
	-i | --stdin                  Return the first valid file descriptor
                                 for standard input. 
	-g | --integer                Return the integer pertaining to the above
                                 options. 
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && dfc_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -l|--list)
	         DO_LIST=true
	      ;;
	     -e|--stderr)
	         DO_STDERR=true
	      ;;
	     -o|--stdout)
	         DO_STDOUT=true
	      ;;
	     -i|--stdin)
	         DO_STDIN=true
	      ;;
	     -g|--integer)
	         DO_INTEGER=true
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        dfc_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received: $1\n" > /dev/stderr;
	      dfc_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done
	
	# list
	[ ! -z $DO_LIST ] && {
	  	[ -f $STDERR ] && STDERR="/dev/stderr" || STDERR="/proc/self/fd/2" 
	  	[ -f $STDOUT ] && STDOUT="/dev/stdout" || STDOUT="/proc/self/fd/1" 
	  	[ -f $STDIN ] && STDIN="/dev/stdin" || STDIN="/proc/self/fd/0" 

		if [ ! -z $DO_INTEGER ]
		then
			printf "%s\n" "Standard Output: 1"
			printf "%s\n" "Standard Input: 0"
			printf "%s\n" "Standard Error: 2"
		else	
			printf "%s\n" "Standard Output: $STDOUT"
			printf "%s\n" "Standard Input: $STDIN"
			printf "%s\n" "Standard Error: $STDERR"
		fi
	}
	
	# stderr
	[ ! -z $DO_STDERR ] && {
		[ -f $STDERR ] && {
			[ ! -z $DO_INTEGER ] && printf "%d" 2 || printf "%s" "$FNAME" 
		}
	}
	
	# stdout
	[ ! -z $DO_STDOUT ] && {
		[ -f $STDERR ] && {
			[ ! -z $DO_INTEGER ] && printf "%d" 2 || printf "%s" "$FNAME" 
		}
	}
	
	# stdin
	[ ! -z $DO_STDIN ] && {
		[ -f $STDERR ] && {
			[ ! -z $DO_INTEGER ] && printf "%d" 2 || printf "%s" "$FNAME" 
		}
	}
	
}
