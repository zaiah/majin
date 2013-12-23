#!/bin/bash -
#-----------------------------------------------------#
# __
#
# Recompiles this library.
#-----------------------------------------------------#

# usage - Show usage message and die with $STATUS
usage() {
   STATUS="${1:-0}"
   echo "Usage: ./$PROGRAM
	[ -  ]

-r | --recompile              desc
-w | --with <arg>             desc
-w | --without <arg>          desc
-v | --version                desc
-s | --single-file            desc
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
     -r|--recompile)
         DO_RECOMPILE=true
      ;;
     -w|--with)
         DO_WITH=true
         shift
         WITH="$1"
      ;;
     -w|--without)
         DO_WITHOUT=true
         shift
         WITHOUT="$1"
      ;;
     -v|--version)
         DO_VERSION=true
      ;;
     -s|--single-file)
         DO_SINGLE_FILE=true
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

# recompile
[ ! -z $DO_RECOMPILE ] && {
   printf '' > /dev/null
}

# with
[ ! -z $DO_WITH ] && {
   printf '' > /dev/null
}

# without
[ ! -z $DO_WITHOUT ] && {
   printf '' > /dev/null
}

# version
[ ! -z $DO_VERSION ] && {
   printf '' > /dev/null
}

# single_file
[ ! -z $DO_SINGLE_FILE ] && {
   printf '' > /dev/null
}
