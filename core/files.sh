#-----------------------------------------------------#
# dfc
#
# Does some quick checks for common file descriptors.
#-----------------------------------------------------#
dfc() {
	LIBPROGRAM="dfc"
	# Static variables
	STDERR=
	STDOUT=
	STDIN=
	
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
	-i | --integer                Return the integer pertaining to the above
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
	     -s|--stdin)
	         DO_STDIN=true
	      ;;
	     -i|--integer)
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
	      printf "Unknown argument received.\n" > /dev/stderr;
	      dfc_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done
	
	# list
	[ ! -z $DO_LIST ] && {
	   printf '' > /dev/null
	}
	
	# stderr
	[ ! -z $DO_STDERR ] && {
	   printf '' > /dev/null
	}
	
	# stdout
	[ ! -z $DO_STDOUT ] && {
	   printf '' > /dev/null
	}
	
	# stdin
	[ ! -z $DO_STDIN ] && {
	   printf '' > /dev/null
	}
	
	# integer
	[ ! -z $DO_INTEGER ] && {
	   printf '' > /dev/null
	}
}
