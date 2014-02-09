#!/bin/bash -
#-----------------------------------------------------#
# extract_varnames.sh
#
# Extracts variable names in sh.
#-----------------------------------------------------#
#-----------------------------------------------------#
# Licensing
# ---------
# Copyright (c) 2014 Vokayent, LLC
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
function extract_varnames() {
	# Local variables
	local BINDIR=
	local DECLARE_LIST=
	local DO_CAPITALIZED=
	local DO_NO_LOCALIZE=
	local DO_SNAKE_CASE=
	local DO_UPPER_CASE=
	local EXCLUDE=
	local IN_FILE=
	local OUT_FILE=
	local PROGRAM=
	local SELF=
	local STATUS=
	local VERBOSE=

	# References to $SELF
	PROGRAM="extract_varnames.sh"
	BINDIR="$(dirname "$(readlink -f $0)")"
	SELF="$(readlink -f $0)"

	# usage - Show usage message and die with $STATUS
	usage() {
		STATUS="${1:-0}"
		echo "Usage: ./$PROGRAM
		[ -  ]

	-s | --snake-case             Find all variables defined with snake case.
	-c | --capitalized            Find all variables that have been capitalized. 
	-u | --upper-case             Find all variables that are upper-case. 
	-x | --exclude <arg>          Leave out certain variables. 
	-i | --in <arg>               Define an input file, instead of <stdin> 
	-o | --out <arg>              Define an output file, instead of <stdout> 
	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.

	WARNING:
	--snake-case and --capitalized are untested as of yet and could lead to strange errors.
	"
		exit $STATUS
	}


	# Die if no arguments received.
	[ -z "$BASH_ARGV" ] && printf "Nothing to do\n" > /dev/stderr && usage 1

	# Process options.
	while [ $# -gt 0 ]
	do
		case "$1" in
		-s|--snake-case|--lower-case)
				DO_SNAKE_CASE=true
			;;
		-c|--capitalized)
				DO_CAPITALIZED=true
			;;
		-u|--upper-case)
				DO_UPPER_CASE=true
			;;
		-n|--no-localize)
				DO_NO_LOCALIZE=true
			;;
		-i|--in)
				shift
				IN_FILE="$1"
			;;
		-o|--out)
				shift
				OUT_FILE="$1"
			;;
		-x|--exclude)
				shift
				EXCLUDE="$1"
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


	# Read from IN_FILE or stdin 
	if [ ! -z "$IN_FILE" ] 
	then
		[ ! -f "$IN_FILE" ] && {
			printf "Cannot read $IN_FILE." > /dev/stderr
			exit 1
		}
	else
		IN_FILE="/dev/stdin"
	fi

	# Echo to OUT_FILE or stdout
	OUT_FILE="${OUT_FILE:-/dev/stdout}"

	# Check for case.
	[  -z $DO_SNAKE_CASE ] && [  -z $DO_CAPITALIZED ] && [  -z $DO_UPPER_CASE ] && {
		DO_UPPER_CASE=true	
	}

	# Generate a vanilla `declare` to prevent local override of variables that should stay global.
	DECLARE_LIST=`/bin/sh -c declare | sed "s/[=\[].*//g" | grep -v "'"`

	# Do the extraction.
	# Multiple specified types should bring back respective values on each pass.
	# for ... 
	{
		{
			# Pull all things with a $ in front of them and everything with a = after it
			cat /dev/stdin	| \

			# Replace all spaces with newlines.
			tr ' ' '\n' | \

			# Remove all leading spaces and tabs.
			sed 's/^[ \t]*//g' | {

				# Execute a parsing function based on the type of case used, ridding lines that
				# don't fit the parameters and/or obviously are not variable definitions.
				[ ! -z $DO_CAPITALIZED ] && {
					grep "[A-Z][a-z].*=" | \
					sed "/^[^A-Za-z_]/d" 
				}

				[ ! -z $DO_SNAKE_CASE ] && {
					grep "[a-z].*=" | \
					sed "/^[^a-z_]/d" 
				}

				[ ! -z $DO_UPPER_CASE ] && {
					grep "[A-Z].*=" | \
					sed "/^[^A-Z_]/d" 
				}
			} | \

			# Remove everything after '='
			sed "s/[=\[].*//g" | \

			# Sort each of these and get rid of duplicates.
			sort | uniq | \

			# Do any "map reduction", returning the result.
			grep -xv $(printf "%s\n" $DECLARE_LIST | sed "s/^/ -e /g" | tr -d "\n") 

		} < $IN_FILE

	} > $OUT_FILE

	unset BINDIR
	unset DECLARE_LIST
	unset DO_CAPITALIZED
	unset DO_NO_LOCALIZE
	unset DO_SNAKE_CASE
	unset DO_UPPER_CASE
	unset EXCLUDE
	unset IN_FILE
	unset OUT_FILE
	unset PROGRAM
	unset SELF
	unset STATUS
	unset VERBOSE
}
