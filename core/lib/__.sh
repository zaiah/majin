#!/bin/bash
_usage() {
   STATUS="${1:-0}"
   echo "Usage: ./$LIBPROGRAM
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
	
	[ -z "$#" ] && printf "Nothing to do" > /dev/stderr && _usage 1
__BULIBSRC__="$(dirname $(readlink -f $0))/lib"

# Hold library names and checksums.
BASHUTIL_LIBS=(
	"tmp_file.sh" # 
)

# Load each library.
for __MY_LIB__ in ${BASHUTIL_LIBS[@]}
do
	source "$__BULIBSRC__/$__MY_LIB__"
done
