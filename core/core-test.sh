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


# Die if no arguments received.
[ -z "$BASH_ARGV" ] && printf "Nothing to do\n" > /dev/stderr && usage 1

# Process options.
while [ $# -gt 0 ]
do
   case "$1" in
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
   printf '' > /dev/null
fi

# traps
if [ ! -z $DO_TRAPS ]
then
   printf '' > /dev/null
fi

# defaults
if [ ! -z $DO_DEFAULTS ]
then
   printf '' > /dev/null
fi

# errors
if [ ! -z $DO_ERRORS ]
then
   printf '' > /dev/null
fi
