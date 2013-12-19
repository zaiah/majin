#-----------------------------------------------------#
# manifest_parse
#
# Parses bashutil's manifest files.
#
# An example manifest looks something like this:
# 
# o:<program option>
# [ a: <argument name> ]
# [ c: <comment> ]
# s: <short description>
# [ d: <long description> ]
# [ f: \n<function> ]
#  
# We parse each one or just a particular one.
#-----------------------------------------------------#
manifest_parse() {
	# Variable.
	LIBPROGRAM="manifest_parse"
	local LINE=
	
	# manifest_parse_usage - Show usage message and die with $STATUS
	manifest_parse_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-f | --from <arg>             Use <arg> as the manifest. 
	-g | --get <arg>              Get a particular 
	-u | --usage                  Create the usage only from manifest. 
	-d | --description            Create the descriptions from manifest.
	-o | --options                Create the options from manifest. 
	-b | --build

	-m | --markdown               Create documentation in markdown format. 
	-h | --html                   Create an html documentation. 
	-t | --troff                  Create something in troff output for a man page. 

	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && manifest_parse_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -f|--from)
	         shift
	         MANIFEST="$1"
			;;
	     -g|--get)
	         DO_GET=true
	         shift
	         GET="$1"
	      ;;
	     -u|--usage)
	         DO_USAGE=true
	      ;;
	     -d|--description)
	         DO_DESCRIPTION=true
	      ;;
	     -o|--options)
	         DO_OPTIONS=true
	      ;;
	     -b|--build)
	         DO_BUILD=true
	      ;;
	     -m|--man)
	         DO_MAN=true
	      ;;
	     -h|--html)
	         DO_HTML=true
	      ;;
	     -t|--troff)
	         DO_TROFF=true
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        manifest_parse_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received.\n" > /dev/stderr;
	      manifest_parse_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done

	# Move through each line and find the range between \nL:0:2 and the next \nL:0:2

	# When processing each line.
	# Mega super bomb ray...	
	case "${LINE:0:2}" in
		# a - argument (name) 
		'a:')   ;;
		# c - comments
		'c:')   ;;
		# s - short description
		's:')   ;;
		# d - long description
		'd:')   ;;
		# f - function
		'f:')   ;;
		*) break  ;;
	esac
	
	# get
	[ ! -z $DO_GET ] && {
	   printf '' > /dev/null
	}
	
	# usage
	[ ! -z $DO_USAGE ] && {
	   printf '' > /dev/null
	}
	
	# description
	[ ! -z $DO_DESCRIPTION ] && {
	   printf '' > /dev/null
	}
	
	# options
	[ ! -z $DO_OPTIONS ] && {
	   printf '' > /dev/null
	}
	
	# man
	[ ! -z $DO_MAN ] && {
	   printf '' > /dev/null
	}
	
	# html
	[ ! -z $DO_HTML ] && {
	   printf '' > /dev/null
	}
	
	# troff
	[ ! -z $DO_TROFF ] && {
	   printf '' > /dev/null
	}
}



