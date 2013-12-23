#!/bin/bash -
#-----------------------------------------------------#
# buildlic
#
# Build and maintain licenses. 
#-----------------------------------------------------#
#-----------------------------------------------------#
# Licensing
# ---------
# 
# Copyright (c) 2013 Vokayent
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#-----------------------------------------------------#
PROGRAM="buildlic"

# References to $SELF
BINDIR="$(dirname "$(readlink -f $0)")"
SELF="$(readlink -f $0)"

# usage - Show usage message and die with $STATUS
usage() {
   STATUS="${1:-0}"
   echo "Usage: ./$PROGRAM
	[ -  ]

-a | --add <arg>              desc
-r | --remove <arg>           desc
-a | --alias <arg>            desc
-e | --edit <arg>             desc
-d | --default <arg>          desc
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
     -a|--add)
         DO_ADD=true
         shift
         ADD="$1"
      ;;
     -r|--remove)
         DO_REMOVE=true
         shift
         REMOVE="$1"
      ;;
     -a|--alias)
         DO_ALIAS=true
         shift
         ALIAS="$1"
      ;;
     -e|--edit)
         DO_EDIT=true
         shift
         EDIT="$1"
      ;;
     -d|--default)
         DO_DEFAULT=true
         shift
         DEFAULT="$1"
      ;;
     -v|--verbose)
        VERBOSE=true
      ;;
     -h|--help)
        usage 0
      ;;
     --) break;;
     -*)
      printf "Unknown argument received: $1\n" > /dev/stderr;
      usage 1
     ;;
     *) break;;
   esac
shift
done

# add
[ ! -z $DO_ADD ] && {
   printf '' > /dev/null
}


# remove
[ ! -z $DO_REMOVE ] && {
   printf '' > /dev/null
}


# alias
[ ! -z $DO_ALIAS ] && {
   printf '' > /dev/null
}


# edit
[ ! -z $DO_EDIT ] && {
   printf '' > /dev/null
}


# default
[ ! -z $DO_DEFAULT ] && {
   printf '' > /dev/null
}
