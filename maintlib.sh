#!/bin/bash -
#-----------------------------------------------------#
# maintlib
#
# Maintains bashutil libraries. 
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
PROGRAM="maintlib"

# References to $SELF
BINDIR="$(dirname "$(readlink -f $0)")"
SELF="$(readlink -f $0)"


# Reference a central library
LIBDIR="${BINDIR}/bulib"
LIB="${BINDIR}/lib/__.sh"
source $LIB
DB="$LIBDIR/libs.db"

# usage() - Show usage message and die with $STATUS
usage() {
   STATUS="${1:-0}"
   printf "Usage: ./${PROGRAM}
	[ -  ]

Maintenance:
-a | --add <arg>              Add a new library. 
-n | --name <arg>             Add a new library with name <arg> (must be
                              used in conjunction with the --add flag)
-r | --remove <arg>           Remove a library. 
-e | --edit <arg>             Edit a library with an available editor.

Classes:
-c | --class <arg>            Use class name <arg> when modifying libraries.
-ac | --add-class <arg>       Add a class. 
-rc | --remove-class <arg>    Remove a class.
-lc | --classes               List classes available. 

Extraction:
-x | --extract <arg>          Extract the function from code.
     --extract-lines  <arg>   Extract range from code.
     --extract-stdin          Extract from /dev/stdin.
-f | --from <arg>             Choose a file to extract library from.
     --convert <arg>          Convert an existing file to a library.
     --to <arg>               Dump file to <arg>

General:
-g | --get <arg>              Add a new library. 
-q | --query                  Query available libraries.
-o | --overwrite              Overwrite a class when a library already exists.
-v | --verbose                Be verbose in output.
-h | --help                   Show this help and quit.
"
   exit $STATUS
}


# Get class names.
get_class_names() {
	dbm --distinct 'class' --from libs
}


# Locate lib name.
locate_lib_name () {
	while [ $# -gt 0 ]
	do
		case "$1" in
			--lib) __L="$1" ;;
			--file) __F="$1" ;;
		esac
		shift
	done

	SL=$(grep --line-number "$1 ()" $FROM | awk -F ':' '{ print $1 }')
}


# Regenerate entire library.
# after adding new names.
# You can ...


# Die if no arguments received.
[ -z "$BASH_ARGV" ] && printf "Nothing to do\n" && usage 1

# Process options.
while [ $# -gt 0 ]
do
   case "$1" in
		# Add
     -a|--add)
         DO_ADD=true
         shift
         ADD="$1"
      ;;

		# Summary
     -s|--summary)
         shift
         SUMMARY="$1"
		;;

		# Name
     -n|--name)
         DO_NAME=true
         shift
         NAME="$1"
      ;;

		# Remove
     -r|--remove)
         DO_REMOVE=true
			DO_FILEMOD=true
         shift
         SELECTION="$1"
      ;;

		# Edit
     -e|--edit)
         DO_EDIT=true
			DO_FILEMOD=true
         shift
         SELECTION="$1"
      ;;

     -x|--extract)
			DO_FROM=true
         shift
         FEXNAME="$1"
      ;;

     --extract-lines)
			DO_FROM=true
         shift
         FROM="$1"	# Different argument.
      ;;

     --extract-stdin)
			DO_FROM=true
         FROM="/dev/stdin"
      ;;

     -f|--from)
         shift
         FROM="$1"
      ;;

		# ... 
     -ac|--add-class)
         shift
			CLASS_TO_ADD="$1"
      ;;

		# ...
     -rc|--remove-class)
         shift
         CLASS="$1"
      ;;

		# Class
     -c|--class)
         shift
         CLASS="$1"
      ;;

		# List classes.
     -ll|--listlib)
         DO_LIST_LIB=true
      ;;

		# List classes.
     -lc|--classes)
         DO_SHOW_CLASSES=true
      ;;

		# Overwrite
     -o|--overwrite)
         DO_OVERWRITE=true
      ;;

		# Query
     -q|--query)
         DO_QUERY=true
      ;;

		# Convert a standalone script to a library.
     --convert)
         DO_CONVERT=true
			shift
			CONVERTEE="$1"
      ;;

		# Grab a library from git repo. 
     -g|--get)
         DO_MERGE=true
      ;;

		# Dump stdout to a particular filename.
     --to)
        	DUMP_TO=true
			shift
			TO="$1"
		;;

		# Lookup
     --lookup)
        	DO_SHOW_LOOKUP=true
		;;

		# Lib
     --lib)
        	DO_SHOW_LIB=true
		;;

		# Verbose
     -v|--verbose)
        VERBOSE=true
      ;;

		# Help
     -h|--help)
        usage 0
      ;;

		# End of flags
     --) break;;

	   # Die on bad arguments.
     -*)
      printf "Unknown argument received: \"$1\".\n";
      usage 1
     ;;

	   # Die on "solid" arguments.... :D 
     *) break;;
   esac
shift
done


# more...
EDITOR=vi


# Evaluate the flags.
eval_flags


# add
if [ ! -z $DO_ADD ] || [ ! -z $DO_FROM ]
then
	# Set up the table
	TABLE="libs"

	# Class?
	if [ -z "$CLASS" ] 
	then 
#		(		
#			printf "Can't add a library without some sort of "
#			printf "general classification.\n"
#			printf "(Try the --class flag, or use --classes for a " 
#			printf "list of available classes.)\n" 
#		) > /dev/stderr
		CLASS="orphan"
		# Choose the 'orphan' class, can move later... 
		# Maybe (as long as it's well documented) use a flag or directive
		# to make this a strict check or not...
		#
		# Using folders isn't really that hot of an idea...
		# It just becomes confusing to manage...

	# Check that the classname is valid.
	else
		# If it's not within a list, drop it and kill the script.
		CLASS_NAME_ARR="$(get_class_names | tr [A-Z] [a-z])"
		if [[ $(is_element_present_in CLASS_NAME_ARR $CLASS) == 'false' ]]
		then
			printf 'This class does not exist already.'
			printf 'Please use the -ac option to add a record of it.'
		fi
	fi

	# No special characters of the following should be in $NAME
	# They with either generate syntax or SQL errors.
	[[ "$NAME" =~ "/" ]] || \
	[[ "$NAME" =~ "\\" ]] || \
	[[ "$NAME" =~ "(" ]] || \
	[[ "$NAME" =~ ")" ]] || \
	[[ "$NAME" =~ "#" ]] || \
	[[ "$NAME" =~ "!" ]] || \
	[[ "$NAME" =~ "-" ]] \
	&& {
		( 
			printf "Argument supplied to --name cannot contain any "
			printf "of the following special characters:\n"
			printf '[ / \ ( ) # ! - ]' 
		) > /dev/stderr
		exit 1
	}

	# Extract if we did it this way.
	[ ! -z $DO_FROM ] && {
		# Did you ask for anything to extract?
		[ -z "$FEXNAME" ] && {
			( 
				printf "No file selected to extract from.\n" 
				printf "Did you use the any of the extraction options?\n"
			) > /dev/stderr
			exit 1
		}

		# Does the file actually exist?
		# [ -z "$FROM ] && { }
		[ ! -f "$FROM" ] && {
			(
				printf "Error accessing file: $FROM.\n" 
				printf "No such file or directory.\n"
			) > /dev/stderr
			exit 1
		}

		# Set a name.
		[ -z "$NAME" ] && NAME="$FEXNAME"

		# Find the function name within the file.
		# (Example: $PROGRAM -x pear --from mega.sh)
		# 
		# What if there are multiple of the same name?
		# If a conflict like this is found, best to examine
		# both functions as temporary files or let the user know.
		#
		# Find the line number containing our name, if more
		# than one match, handle it properly.
		SLA="$(grep --line-number "$FEXNAME" $FROM | \
			awk -F ':' '{ print $1 }')"

		# Could have many matches.
		[ ! -z "$SLA" ] && SLA=( $SLA )

		# In said line, check to make sure that $FEXNAME 
		# is actually $FEXNAME and not part of something else.
		for POSS_RANGE in ${SLA[@]}
		do
			# Process this one line.
			FEXSRC="$(sed -n ${POSS_RANGE}p ${FROM} 2>/dev/null)"

			# Disregard comment blocks.
			[[ "$FEXSRC" =~ "#" ]] && {
				# Check everything before the first comment.
				FEXSRC="${FEXSRC%%#*}"
			}

			# If matched line doesn't contain (), next match. 
			[[ ! "$FEXSRC" =~ "(" ]] || [[ ! "$FEXSRC" =~ ")" ]] && {
				continue	
			}

			# Remove leading white space and function wraps...
			FEXLINE="$( printf "%s" $FEXSRC | \
				sed "s/^[ \t]*\($FEXNAME\).*/\1/g")" 

			# ... to check if script received an accurate match.
			[[ ! "$FEXLINE" == $FEXNAME ]] && {
				continue	
			}

			# If all checks are good, there's the line range.
			SL=$POSS_RANGE
			break
		done

		# Die if nothing was found.
		[ -z $SL ] && {
			( 
				printf "Couldn't find function \`"
				printf "$FEXNAME\` within file: $FROM\n"
			) > /dev/stderr
			exit 1
		}

		# Define the possible range.
		PFR="$(sed -n ${SL},$(wc -l $FROM | awk '{print $1}')p $FROM)"

		# Can move through each character and see if we run into a '}'
		# Extract function from CLAUSE building to get '}'
		FEXEND=$(search_for --this '}' --in "$PFR")

		# Using for to iterate through file?
		BUFFER="$(printf "%s" "$PFR" | head -c $(( $FEXEND + 1 )))"

		# Save buffer to temporary file.
		tmp_file -n BUFFILE
		if [ -z $DO_ADD ]
		then 
			printf "%s" "$BUFFER" > /dev/stdout
			exit
		else
			printf "%s" "$BUFFER" > $BUFFILE
		fi
	}	


	# Did the user supply any arugments? 
	[ -z "$NAME" ] && [ -z "$ADD" ] && {
		(
			printf "Neither --name or <arg> within --add was supplied.\n"
			printf "Giving up...\n"
		) > /dev/stderr
	}


	# If a name was specified, it takes precendence.
	if [ ! -z "$NAME" ] && [ ! -z "$ADD" ]
	then
		# Have to loop through the different extensions.
		for FN_EXT in .sh .ksh .csh .bash
		do
			# If name contains extension, set FN_HANDLE
			FN_HANDLE="${ADD}${FN_EXT}"
			[[ -f "$FN_HANDLE" ]] && break
			unset FN_HANDLE
		done

		# Set the names.
		__SRCFILE__="${FN_HANDLE:-$ADD}"
		__LIBFILE__="${NAME}.sh"
		__LIBNAME__="$NAME"

	# If just a file was added, the filename is the script name.
	elif [ -z "$NAME" ] && [ ! -z "$ADD" ]
	then
		# Have to loop through the different extensions.
		for FN_EXT in .sh .ksh .csh .bash
		do
			# If name contains extension, set FN_HANDLE
			FN_HANDLE="${ADD}${FN_EXT}"
			[[ -f "$FN_HANDLE" ]] && break
			unset FN_HANDLE
		done

		# Set names again.
		__SRCFILE__="${FN_HANDLE:-$ADD}"
		__LIBFILE__="$(basename ${ADD%%.sh}).sh"
		__LIBNAME__="$(basename ${ADD%%.sh})"

	# If name and nothing else, we're extracting.
	elif [ ! -z "$NAME" ] && [ -f "$BUFFILE" ]
	then
		# Set names again.
		__SRCFILE__="$BUFFILE"
		__LIBFILE__="${NAME}.sh"
		__LIBNAME__="$NAME"
	fi

	# Debugging info...
#	echo ==========================
#	echo Absolute path: $__SRCFILE__
#	echo Final Name: $__LIBNAME__
#	echo
#	echo Either of the following but
#	echo name will override filename.
#	echo ==========================
#	echo Name of extraction: $FEXNAME
#	echo File to put in lib: $__LIBFILE__

	# Check if it exists or overwrite it.
	IN_DB="$(dbm -s 'id' -w "name=$NAME" 2>/dev/null)"
	[ ! -z "$IN_DB" ] && [ -z $DO_OVERWRITE ] && {
		( 
			printf "This library is already in your bashutil toolkit.\n"
			printf "If you would like to update this library, use the "
			printf "%s\n" "--overwrite flag to wipe the original."
		) > /dev/stderr
		exit 1
	}

	# Check if there are multiple ID's.
	# There should not be.
	# This is useful from minishell.
	MULT=( $(printf "%s\n" $IN_DB) )
	[ ${#MULT[@]} -gt 1 ] && {
		(
			printf "Multiple rows found with the same name.\n"
			printf "Can't move any further.\n"
		) > /dev/stderr
		exit 1
	}
			
	# Copying with the correct name if I've asked for one.
	[ -f "$__SRCFILE__" ] && {
		cp $CP_FLAGS $__SRCFILE__ $SRCLIB/$__LIBFILE__
	}

	# Populate records.	
	LOCATION="$__LIBFILE__"
	NAME="$__LIBNAME__"
	CLASS="$CLASS"
	CHECKSUM="$(md5sum "$SRCLIB/$__LIBFILE__" | awk '{print $1}')"
	DESCRIPTION="$SUMMARY"
	DATE_CREATED="$(date +%s)"
	DATE_LAST_MODIFIED="$(date +%s)"

	# Add to database.
	if [ ! -z $DO_OVERWRITE ] 
	then
		dbm \
			--set "location=$LOCATION" \
			--set "date_last_modified=$DATE_LAST_MODIFIED" \
			--set "description=$SUMMARY" \
			--where "id=$IN_DB" --echo

		#dbm --select-all --echo
	else
		#printf '' > /dev/null
		dbm --insert-from-mem
	fi
fi



# File mod
if [ ! -z $DO_FILEMOD ]
then
	# Set up the table
	TABLE="libs"

	# remove
	if [ ! -z $DO_REMOVE ]
	then
		# Retrieve file from database.
		__SRCFILE__="$(dbm --select 'file' --where "name=$SELECTION")"

		# Does it exist at all?
		if [ ! -z "$__SRCFILE__" ] && [ -f "$__SRCFILE__" ]
		then 
			# Remove the file.
			rm $RM_FLAGS "$__SRCFILE__"

			# Drop it from the database.
			dbm --remove --where "name=$SELECTION"
		else
			(
				printf "No library entry by the name $SELECTION found." 
			) > /dev/stderr
			exit 1
		fi	
	fi

	# edit
	if [ ! -z $DO_EDIT ]
	then
		# Open a window allowing one to edit the class.
		$EDITOR "$__SRCFILE__"
	fi

	# At the end of each of these, sed should drop all the lines...
fi


# List lib.
if [ ! -z $DO_LIST_LIB ]
then
	ls $LIBDIR/*
fi


# class
if [ ! -z $DO_ADD_CLASS ]
then
	# Choose a class.
	CLASS_NAME_ARR="$(get_class_names | tr [A-Z] [a-z])"
	[[ $(is_element_present_in CLASS_NAME_ARR "$CLASS_TO_ADD") == 'true' ]] && {
		printf 'This class already exists.' > /dev/stderr
		exit 1
	}

	# Add to lib 
	printf "\n# $CLASS_TO_ADD\n" >> $LIB_MANIFEST

	# 
	# dbm --insert-into-mem
fi


# Class removal
if [ ! -z $DO_REMOVE_CLASS ]
then
	# dbm --remove --where class="$CLASS"
	printf '' > /dev/null
fi


# classes
if [ ! -z $DO_SHOW_CLASSES ]
then
	# List all the available classes.
  	# grep '#' $LIB_MANIFEST | sed 's/# //'
	get_class_names
fi


# Directly edit either the lookup or library files.
[ ! -z $DO_SHOW_LOOKUP ] && $EDITOR $LOOKUP_MANIFEST
[ ! -z $DO_SHOW_LIB ] && $EDITOR $LIB_MANIFEST

[ ! -z $DO_QUERY ] && printf "Not done..."
[ ! -z $DO_MERGE ] && printf "Not done..."


# Conversion
[ ! -z $DO_CONVERT ] && {
	# Check that a parameter actually arrived.
	[ -z "$CONVERTEE" ] && {
		printf "No filename supplied to --convert.\n" > /dev/stderr
		exit 1
	}

	# Check that a file actually arrived.
	[ ! -f "$CONVERTEE" ] && {
		printf "Filename $CONVERTEE does not exist.\n" > /dev/stderr
		exit 1
	}

	# Encapsulate with the function name and braces.
	SCRIPT_NAME=${NAME:-${CONVERTEE%%.sh}}

	# Get the first line number past the comments.
	# (If you have no comments, how does this work?)
	CONTENT_START=`grep --line-number -v '#' $CONVERTEE | head -n 1 | awk -F ':' '{ print $1 }'`
	CONTENT_END=`wc -l $CONVERTEE | awk '{ print $1 }'`

	# Extract the variable names first.
	VAR_LIST=`extract_varnames -i $CONVERTEE`

	# Create a temporary file.
	tmp_file -n NEW_FUNCTION
	{ 
		# Start with comments if there are any. 
		if [ ! -z $CONTENT_START ]
		then
			if [ $CONTENT_START -eq 2 ]
			then
				sed -n 1p $CONVERTEE
			else
				sed -n 1,$(( ${CONTENT_START} - 1 ))p $CONVERTEE
			fi
		fi

		# Print the function name.
		printf "\n%s\n" "function $SCRIPT_NAME () {" 

		# Make all variables local.
		printf "\t# Local variables\n"
		printf "\tlocal %s=\n" $VAR_LIST

		# Copy the rest of the script.
		if [ ! -z $CONTENT_START ]
		then
			sed -n ${CONTENT_START},${CONTENT_END}p $CONVERTEE | sed 's/^/\t/' 
		else
			cat $CONVERTEE $NEW_FUNCTION
		fi	

		# Unset the local variables for no conflict with others.
		printf "\n\t# Unset variables\n"
		printf "\tunset %s\n" $VAR_LIST

		# Close the function.
		printf "}\n"
	} > $NEW_FUNCTION	

	# Replace any instances of BASH_ARGV
	sed -i 's/BASH_ARGV/#/g' $NEW_FUNCTION 

	# Replace any usage messages with a localized name.
	sed -i "s/usage/${SCRIPT_NAME}_usage/g" $NEW_FUNCTION 

	# Dump to stdout or to file.
	[ ! -z $DUMP_TO ] && {
		[ -z "$TO" ] && {
			printf "No filename specified for the --to option." > /dev/stderr
			exit 1
		}
		FILENAME=$TO
	}

	# Return the dump.
	cp $NEW_FUNCTION $FILENAME
}

# Clean up any temporary files still laying around.
tmp_file -w
