#-----------------------------------------------------#
# step
#
# Set up a stepping system for shell scripts.
#-----------------------------------------------------#
#-----------------------------------------------------#
# Licensing
# ---------
# Copyright (c) <year> <copyright holders>
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
step() {
	LIBPROGRAM="step"
	
	# step_usage - Show usage message and die with $STATUS
	step_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-s | --start                  desc
	-s | --stop                   desc
	-k | --keystroke              desc
	-s | --set_keystroke <arg>    desc
	-f | --function <arg>         desc
	-e | --execute <arg>          desc
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && step_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -s|--start)
	         DO_START=true
	      ;;
	     -s|--stop)
	         DO_STOP=true
	      ;;
	     -k|--keystroke)
	         DO_KEYSTROKE=true
	      ;;
	     -s|--set-keystroke)
	         DO_SET_KEYSTROKE=true
	         shift
	         SET_KEYSTROKE="$1"
	      ;;
	     -f|--function)
	         DO_FUNCTION=true
	         shift
	         FUNCTION="$1"
	      ;;
	     -e|--execute)
	         DO_EXECUTE=true
	         shift
	         EXECUTE="$1"
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        step_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received.\n" > /dev/stderr;
	      step_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done
	
	# start
	[ ! -z $DO_START ] && {
	   printf '' > /dev/null
	}
	
	# stop
	[ ! -z $DO_STOP ] && {
	   printf '' > /dev/null
	}
	
	# keystroke
	[ ! -z $DO_KEYSTROKE ] && {
	   printf '' > /dev/null
	}
	
	# set_keystroke
	[ ! -z $DO_SET_KEYSTROKE ] && {
	   printf '' > /dev/null
	}
	
	# function
	[ ! -z $DO_FUNCTION ] && {
	   printf '' > /dev/null
	}
	
	# execute
	[ ! -z $DO_EXECUTE ] && {
	   printf '' > /dev/null
	}
}
