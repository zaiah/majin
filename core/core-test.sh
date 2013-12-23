#!/bin/bash -
#-----------------------------------------------------#
# core-test
#
# Test the core functions that can be included in every script.
#-----------------------------------------------------#
PROGRAM="core-test"

# References to $SELF
BINDIR="$(dirname "$(readlink -f $0)")"
SELF="$(readlink -f $0)"

# Libraries.
source lib/__.sh

# usage - Show usage message and die with $STATUS
usage() {
   STATUS="${1:-0}"
   echo "Usage: ./$PROGRAM
	[ -aotdeh ]

-a | --all                    Run all the tests.
-o | --options                Test options. 
-t | --traps                  Test traps.
-d | --default-files          Test default files.
-e | --errors                 Test error printing. 
-v | --verbose                Be verbose in output.
-h | --help                   Show this help and quit.
"
   exit $STATUS
}


# stat - Checks the results of a pipe. 
#
# expect
# - = /dev/stdin
# 
# Check if any args are flags.
stat() {
	local CMP=
	[[ $2 == '-' ]] && CMP=$(< /dev/stdin)
	[ $CMP == $1 ] && printf "%s\n" "Test succeeded!" || \
		printf "%s\n" "Test failed." 

	# Test can look to currently run line or be supplied with a name.
}

# Die if no arguments received.
[ -z "$BASH_ARGV" ] && printf "Nothing to do\n" > /dev/stderr && usage 1

# Process options.
while [ $# -gt 0 ]
do
   case "$1" in
     -a|--all)
         DO_OPTIONS=true
         DO_TRAPS=true
         DO_ERRORS=true
         DO_DEFAULTS=true
      ;;
     -o|--options)
         DO_OPTIONS=true
      ;;
     -t|--traps)
         DO_TRAPS=true
      ;;
     -d|--defaults)
         DO_DEFAULTS=true
      ;;
     -e|--errors)
         DO_ERRORS=true
      ;;
     -v|--verbose)
        VERBOSE=true
      ;;
     -h|--help)
        usage 0
      ;;
     --) break;;
     -*)
      printf "Unknown argument received.\n" > /dev/stderr;
      usage 1
     ;;
     *) break;;
   esac
shift
done

# options
if [ ! -z $DO_OPTIONS ]
then
	source opteval.sh

fi

# traps
if [ ! -z $DO_TRAPS ]
then
	source traps.sh
   printf '' > /dev/null
fi

# defaults
if [ ! -z $DO_DEFAULTS ]
then
	source files.sh
   printf '' > /dev/null
fi

# errors
if [ ! -z $DO_ERRORS ]
then
	source error.sh

	# Create a sink.
	tmp_file -n ERRLOG

	# Log a message.
	error -m "Error occurred here." 2>$ERRLOG

	# Log a message to file.
	error -m "Error occurred here." --log $ERRLOG

	# Get line count.  stat $1 $2
	# stat checks that an output is what its supposed to be.
	# $1 = $2 is good.  else is not...
	cat $ERRLOG | wc -l | stat 2 -
	tmp_file -l 

   printf '' > /dev/null
fi
