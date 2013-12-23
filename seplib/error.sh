#-----------------------------------------------------#
# error
#
# Prints a nifty error message.
#-----------------------------------------------------#
error() {
	LIBPROGRAM="error"
	
	# error_usage - Show usage message and die with $STATUS
	error_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-l | --log                    desc
	-s | --stderr                 desc
	-t | --to <arg>               desc
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && error_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -l|--log)
	         DO_LOG=true
	      ;;
	     -s|--stderr)
	         DO_STDERR=true
	      ;;
	     -t|--to)
	         DO_TO=true
	         shift
	         TO="$1"
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        error_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received: $1\n" > /dev/stderr;
	      error_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done
	
	# log
	[ ! -z $DO_LOG ] && {
	   printf '' > /dev/null
	}
}
