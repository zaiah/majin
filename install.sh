#!/bin/bash -
#-----------------------------------------------------#
# install
#
# Installs buu and some other stuff.
#
#        _______
#       /     _ \
#      /     / \ \_
#     /     /   \__|
#     |     |
#     |     |
#    /.     .\
#   / .     . \
# |____ | |____|_
#  |\__0/  \__0  |
#  |	          _| 
#  \	 \____/  /
#   \         /
#    \_______/
# 
# 	      |\
#   _____| \___________
#  |                  |
#  |		 Buu...      |
#  |                  |   
#  |__________________|
#
# ---------
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
BINDIR="$(dirname "$(readlink -f $0)")"
SELF="$(readlink -f $0)"

LIB="${BINDIR}/lib/__.sh"
source $LIB

PROGRAM="bu-install"

# usage message
# Show a usage message and die.
usage() {
   STATUS="${1:-0}"
   echo "Usage: ./${PROGRAM}
	[ -  ]

-f | --first-run              Deploy bashutil 
-c | --config <arg>           Use <arg> as the configuration directory.
-i | --install-to <arg>       Installs bashutil to <arg> 
-u | --uninstall              Uninstalls bashutil 
-t | --total-uninstall        Performs a complete uninstall.
-p | --update                 Updates? 
-v|--verbose                  Be verbose in output.
-h|--help                     Show this help and quit.
"
   exit $STATUS
}



# Exit.
[ -z $BASH_ARGV ] && printf "Nothing to do\n" > /dev/stderr && usage 1

# optionss
while [ $# -gt 0 ]
do
   case "$1" in
     -f|--first-run)
         FIRST_RUN=true
      ;;
     -i|--install-to)
         INSTALL=true
			shift
         INSTALL_DIR="$1"
      ;;
     -c|--config)
		  	shift
         DEPLOY_DIR="$1"
      ;;
     -t|--total)
         UNINSTALL_TOTAL=true
      ;;
     -u|--uninstall)
         UNINSTALL=true
      ;;
     -b|--library)
         LIB_GENERATE=true
      ;;
      -v|--verbose)
        VERBOSE=true
      ;;
      -h|--help)
        usage 0
      ;;
      -*)
      printf "Unknown argument received: $1\n";
      exit 1
     ;;
      *) break;;
   esac
shift
done


# Evaluate flags
eval_flags


# Do the first run.
[ ! -z $FIRST_RUN ] && {
	# Create the host directories and all first.
	# echo mkdir $MKDIR_FLAGS ${HOST_DIRS[@]}
	mkdir $MKDIR_FLAGS ${HOST_DIRS[@]}

	# Copy all the licenses
	# echo cp $CP_FLAGS $BINDIR/licenses/* $PROGRAM_DIR/licenses
	cp $CP_FLAGS $BINDIR/licenses/* $PROGRAM_DIR/licenses
}


# Install
[ ! -z $INSTALL ] && {
	# Die if there's no install directory (can be done from installation)
	[ -z "$INSTALL_DIR" ] && {
		printf "No install directory found." > /dev/stderr
	}

	# In use.
	installation --do --to $INSTALL_DIR \
		--these "buildlib,buildlic,buildopts,buildsql,buildunit,maintlib"
}


# Generate the original library.
[ ! -z $LIB_GENERATE ] && {
	# Build the library.
	# wget ...
	# build core
	printf '' > /dev/null
}


# Uninstall.
[ ! -z $UNINSTALL ] && {
  	installation --undo 
}

