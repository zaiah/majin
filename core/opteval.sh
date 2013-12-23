#-----------------------------------------------------#
# opteval
#
# Evaluate options supplied via command-line.
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
opteval() {
	LIBPROGRAM="opteval"
	
	# opteval_usage - Show usage message and die with $STATUS
	opteval_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-d | --die                    Die on receiving no argument where one is  
	                              expected.
	-d | --disregard              Disregard any missing arguments. 
	-f | --flag                   Die if the argument is not a flag. 
	-n | --not-flag               Die if the argument is a flag. 
	-d | --double-dash            Let opteval know when to expect a double-dash 
	-o | --optional               Let opteval know when certain argumetns are 
	                              optional.
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && printf "Nothing to do\n" > /dev/stderr && opteval_usage 1
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -d|--die)
	         DO_DIE=true
	      ;;
	     -s|--disregard)
	         DO_DISREGARD=true
	      ;;
	     -f|--flag)
	         DO_FLAG=true
	      ;;
	     -n|--not-flag)
	         DO_NOT_FLAG=true
	      ;;
	     -b|--double-dash)
	         DO_DOUBLE_DASH=true
	      ;;
	     -o|--optional)
	         DO_OPTIONAL=true
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        opteval_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received.\n" > /dev/stderr;
	      opteval_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done
	
	# die
	[ ! -z $DO_DIE ] && {
	   printf '' > /dev/null
	}
	
	# disregard
	[ ! -z $DO_DISREGARD ] && {
	   printf '' > /dev/null
	}
	
	# flag
	[ ! -z $DO_FLAG ] && {
	   printf '' > /dev/null
	}
	
	# not_flag
	[ ! -z $DO_NOT_FLAG ] && {
	   printf '' > /dev/null
	}
	
	# double_dash
	[ ! -z $DO_DOUBLE_DASH ] && {
	   printf '' > /dev/null
	}
	
	# optional
	[ ! -z $DO_OPTIONAL ] && {
	   printf '' > /dev/null
	}
}
