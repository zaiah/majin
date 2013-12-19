#-----------------------------------------------------#
# manifest_build
#
# Creates bashutil manifests.
#-----------------------------------------------------#
manifest_build() {
	LIBPROGRAM="manifest_build"
	
	# manifest_build_usage - Show usage message and die with $STATUS
	manifest_build_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-b | --build <arg>            desc
	-f | --from <arg>             desc
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && manifest_build_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -b|--build)
	         DO_BUILD=true
	         shift
	         BUILD="$1"
	      ;;
	     -f|--from)
	         DO_FROM=true
	         shift
	         FROM="$1"
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        manifest_build_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received.\n" > /dev/stderr;
	      manifest_build_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done
	
	# build
	[ ! -z $DO_BUILD ] && {
	   printf '' > /dev/null
	}
	
	# from
	[ ! -z $DO_FROM ] && {
	   printf '' > /dev/null
	}
}
