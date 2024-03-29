#!/bin/bash -
#-----------------------------------------------------#
# buildlib
#
# Builds a portable library for shell script programs.
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
BINDIR="$(dirname "$(readlink -f $0)")"
SELF="$(readlink -f $0)"
LIB="${BINDIR}/lib/__.sh"
source $LIB
PROGRAM="buildlib"

# usage() - Show usage message and die with $STATUS
usage() {
   STATUS="${1:-0}"
   echo "Usage: ./${PROGRAM}
	[ -  ]

Library Compile Actions:
-k | --link-at <arg>          Link what is chosen at a certain directory.
-kw| --link-with <arg>        Link with the <arg> compiled in.
-w | --with <arg>             Build library with functions listed in <arg> 
-x | --without <arg>          Build library with functions listed in <arg> 
-z | --all-libs               Build library with functions listed in <arg> 
-n | --name <arg>             Give the library and its elements a consistent 
                              name.
-q | --namespace <arg>        Build library functions with a different 
                              naming convention.
-c | --comments               Include comments in library. (default includes comments :) )
-l | --list                   List all available functions. 
-? | --describe <arg>         Describe function <arg>.
--specify-with                Use a menu to choose library list.

Library Runtime Actions:
-e | --executables <arg>      Convert names in <arg> to variables that alias
                              programs located in your \$PATH
-s | --static <arg>           Convert names in <arg> to variables pointing to 
                              immutable values. 
-ff| --functions-for <list> Generate some skelelon functions.
                            ( echo '...' is default )
-d | --depcheck               Generate code to run a dependency check.
-s | --standard_dirs <arg>    Convert names in <arg> to variables that 
                              reference your program's common directories.
-u | --security               Generate code to secure a shell script.
-a | --set-all <arg>          Set all flags that do not require an argument.
                              <arg> refers to library name.

General Options:
-v | --verbose                Be verbose in output.
-h | --help                   Show this help and quit.
"
   exit $STATUS
}


# Die if no arguments received.
[ -z "$BASH_ARGV" ] && printf "Nothing to do\n" && usage 1


# Still to do, add --regen for rebuilding libraries.
# add --update to initial_install (to rebuild tables and add any new directories that may be part of script.)
# documenting individual libraries ( --libusage )

# Process options.
declare -a DO_BUILD
while [ $# -gt 0 ]
do
   case "$1" in
		# ...
	  -a|--set-all)
			SET_ALL=true
			DO_COMMENTS=true
         DO_DB=true
         DO_INITIAL_RUN=true
         DO_INITIAL_INSTALL=true
         DO_SECURITY=true
			shift
			LIBNAME="$1"
		;;

	  -kw|--link-with)
		  shift
		  LINK_WITH="$1"
		;;

	  -k|--link-at)
		  DO_LINKING=true
		  shift
		  LINK_AT="$1"
		;;

	  -c|--comments)
			DO_COMMENTS=true
		;;

     -w|--with)
         DO_WITH=true
         shift
         WITH="$1"
      ;;

     -x|--without)
         shift
         WITHOUT="$1"
      ;;

     -z|--all)
         DO_INC_ALL=true
      ;;

     -l|--list)
         DO_LIST=true
         shift
         LIST="$1"
      ;;

     -n|--name)
         shift
         LIBNAME="$1"
      ;;

     -q|--namespace)
         DO_NAMESPACE=true
         shift
         NAMESPACE="$1"
      ;;

     --specify-with)
         DO_WITH=true
         DO_SPECIFY_WITH=true
      ;;

     -e|--executables)
         DO_EXECUTABLES=true
         shift
         EXECUTABLES="$1"
      ;;

     -s|--static)
         DO_STATIC=true
         shift
         STATIC="$1"
      ;;

     -d|--depcheck)
         DO_DEPCHECK=true
      ;;

     -t|--standard-dirs)
         DO_STANDARD_DIRS=true
         shift
         STANDARD_DIRS="$1"
      ;;

     -b|--db)
         DO_DB=true
      ;;

	  -yy|--initial-install)
			DO_INITIAL_INSTALL=true
			shift
			INITIAL_INSTALL_DIR="$1"
		;; 

	  -y|--initial-install-dir)
			shift
			INITIAL_INSTALL_DIR="$1"
		;;

     -i|--initial-run)
         DO_INITIAL_RUN=true
      ;;

		-ff|--functions-for)
			DO_FUNCTIONS=true
			shift
			FUNCTION_LIST="$1"
		;;

     -s|--security)
         DO_SECURITY=true
      ;;

     --describe)
         DO_DESCRIBE=true
         shift
         DESCRIBE="$1"
      ;;

		# Library build functions.
     --from-class)
         DO_BUILD[${#DO_BUILD[@]}]="databases"
         DO_BUILD[${#DO_BUILD[@]}]="arguments"
         DO_BUILD[${#DO_BUILD[@]}]="random"
         DO_BUILD[${#DO_BUILD[@]}]="strings"
         DO_BUILD[${#DO_BUILD[@]}]="integers"
         DO_BUILD[${#DO_BUILD[@]}]="math"
         DO_BUILD[${#DO_BUILD[@]}]="arrays"
		;;	

		# General options.
      -v|--verbose)
        VERBOSE=true
      ;;
      -h|--help)
        usage 0
      ;;
      --)
		break
     ;;
      -*)
      printf "Bad argument.\n";
      exit 1
     ;;
      *) break;;
   esac
shift
done


# Verbosity
eval_flags


# list
if [ ! -z $DO_LIST ]
then
	dbm --select 'name' --from libs
fi


# Describe one thing at a time.
if [ ! -z $DO_DESCRIBE ]
then
	[ -z "$DESCRIBE" ] && echo "No description supplied!" && usage 1
	grep "$DESCRIBE" $LIB_MANIFEST
fi


# Licenses can still be included as well as banners.
# ...


# Finally, add an individual usage.
# Easy to lose track of all of this and even how to use everything.
# For functions that ship with this, just maintain a help file within the code.
# For functions that do not ship with this (e.g. dependencies from elsewhere or items added 
# through maintlib, cut their comments.  This can just be a generic option: --help-with <f>
# ...


# executables
# Going to make a list of these...
[ ! -z $DO_EXECUTABLES ] && {
	# Die on no argument received.
	[ -z "$EXECUTABLES" ] && {
		printf "%s\n" "Nothing supplied to --executables flag!" 
		usage 1
	}

	# Set up array of execs from CLI args.
  	EXECUTABLES="$(break_list_by_delim "$EXECUTABLES")"

	# Don't want to run a find everytime for certain... 
	# printf 'dep_locate(){\n\tMOV_CHECK=( which, locate, find )\n\t'
	# printf 
	# dep_locate is going to point to which.  
	# If there is no which you want this script to die.

	# Generate execs list
	{ 
		# Comments 
		[ ! -z "$DO_COMMENTS" ] && printf "# Static variables\n"

		# Have the script run a check for each.
		for ETERM in ${EXECUTABLES[@]}
		do
			printf "${ETERM}=" | tr '[a-z]' '[A-Z]'
			if [[ ! $ETERM == "sqlite" ]] && [[ ! $ETERM == "sqlite3" ]] 
			then 
				printf "\"\$(which ${ETERM} 2>/dev/null)\"\n" 
			else
				printf "\"\$(which sqlite3 2>/dev/null)\"\n"
			fi
		done	

		# Have the script run a check for each.
		printf "DEPS=( "
		for ETERM in ${EXECUTABLES[@]}
		do
			printf "\"\$${ETERM}\" " | tr '[a-z]' '[A-Z]'
		done
		printf ")\n\n" 
	} >> $FILENAME	
}


# program directory
[ ! -z "$LIBNAME" ] && {
	# Always do the first few directories.
	( [ ! -z "$DO_COMMENTS" ] && printf "# Library and directory name\n"
	printf "LIBNAME=\"${LIBNAME}\"\n"
	printf "PROGRAM_DIR=\"\$HOME/.\${LIBNAME}\"\n" ) >> $FILENAME
}


# create standard directories 
[ ! -z $DO_STANDARD_DIRS ] && {
	# Everything else will break without some library name.
	[ -z "$LIBNAME" ] && echo "Must have a library name!" >> $FILEERR && usage 1

	# Die on no argument received.
	[ -z "$STANDARD_DIRS" ] && echo "Nothing supplied to --standard-dirs flag!" >> $FILEERR && usage 1
  	STANDARD_DIRS_ARR="$(break_list_by_delim "$STANDARD_DIRS")"

	# Die if there was no program directory.

	# Comments 
	( [ ! -z "$DO_COMMENTS" ] && printf "# Standard directories\n"

	# Have the script run a check for each.
	for SDIR in ${STANDARD_DIRS_ARR[@]}
	do
		printf "${SDIR}_DIR=" | tr '[a-z]' '[A-Z]'
		printf "\"\${PROGRAM_DIR}/${SDIR}\"\n"
	done	

	# Then host dirs.
	printf "HOST_DIRS=( \"\${PROGRAM_DIR}\" "
	for SDIR in ${STANDARD_DIRS_ARR[@]}
	do
		# Have to evaluate absolute names here, lest we don't want stuff in the program directory.	
		printf "\"\${PROGRAM_DIR}/${SDIR}\" "
	done	
	printf ")\n\n" ) >>  $FILENAME
}


# Create static variables. 
[ ! -z $DO_STATIC ] && {
	# Die on no argument received.
	[ -z "$STATIC" ] && echo "Nothing supplied to --static flag!" && usage 1
  	STATIC_ARR="$(break_list_by_delim "$STATIC")"

	# Comments 
	( [ ! -z "$DO_COMMENTS" ] && printf "# Static variables\n"

	# Have the script run a check for each.
	for SVAR in ${STATIC_ARR[@]}
	do
		if [[ "$SVAR" =~ "=" ]]
		then
			# Is this a key value pair
			printf ${SVAR%%=*} | tr '[a-z]' '[A-Z]'
			printf "=\"${SVAR##*=}\"\n"   

		else
			# If not, then just make a spot for it.
			printf "${SVAR}=\n" | tr '[a-z]' '[A-Z]'
		fi
	done ) >> $FILENAME	
}


# Add some function bodies.
[ ! -z $DO_FUNCTIONS ] && {
	# Comments.
	( [ ! -z "$DO_COMMENTS" ] && printf "# Functions\n"

	# List some empty functions bodies.
  	FUNCTION_LIST="$(break_list_by_delim "$FUNCTION_LIST")"
	for FVAR in ${FUNCTION_LIST[@]}
	do
		if [[ "$FVAR" =~ "=" ]]
		then
			# Is this a key value pair
			printf "${FVAR%%=*}() {\n" 
		#	printf "=\"${FVAR##*=}\"\n"    # This doesn't work.  end...
			printf "${FVAR}" | sed 's/[a-z].*=//'
			printf "\n}\n" 
		else
			# If not, then just make a spot for it.
			printf "${FVAR}() {\n" 
			printf "   printf '' > /dev/null"
			printf "\n}\n\n" 
		fi
	done ) >> $FILENAME
}


# security
[ ! -z $DO_SECURITY ] && {
	( printf '\n' >> $FILENAME
   # Set the right internal field seperator for command line args. 
	[ ! -z $DO_COMMENTS ] && printf "# Set the right internal field seperator for command line args.\n" 
	printf "IFS=' \n\t'\n\n"

	# Limits file creation permissions. 
	[ ! -z $DO_COMMENTS ] && printf "# Limits file creation permissions.\n" >> $FILENAME
	printf "UMASK=002\n" 
	printf 'umask $UMASK\n\n' 

	# Set a normal path. 
	[ ! -z $DO_COMMENTS ] && printf "# Set a normal path.\n" >> $FILENAME
	printf 'PATH="/usr/local/bin:/bin:/usr/bin:/usr/sbin:/usr/local/sbin"\n' 
	printf 'export PATH\n\n' ) >> $FILENAME
}


# with
[ ! -z $DO_WITH ] && {
	# specify_with
	if [ ! -z $DO_SPECIFY_WITH ]
	then
   	echo '...'
	fi

   # For each in the with list, cat.
	[ -z "$WITH" ] && echo "Nothing supplied to --with flag!" && usage 1
	WITH=$(break_list_by_delim "$WITH")	

	# Evaluate excludes.
	[ ! -z "$WITHOUT" ] && WITHOUT="$( break_list_by_delim "$WITHOUT" )"

	# Limits file creation permissions. 
	[ ! -z $DO_COMMENTS ] && printf "# Library functions\n" >> $FILENAME

	# Filenames.
	for LIB_F in ${WITH[@]}
	do
		# Get the filename.
		LIB_FILE="${SRCLIB}/$(grep $LIB_F $LOOKUP_MANIFEST | \
			awk -F ':' '{print $2}')"

		# Did the user ask that this function be excluded?
		[ ! -z "$WITHOUT" ] && \
			[[ $(is_element_present_in 'WITHOUT' "$LIB_F") == 'true' ]] && \
			continue 

		# Get the file body.
		if [ -f "$LIB_FILE" ]
		then
			FL=$(wc -l "$LIB_FILE" 2>/dev/null | cut -d ' ' -f 1)
			( sed -n 2,${FL}p $LIB_FILE
			printf "\n" ) >> $FILENAME
		fi	
	done
}


# indiv groups
# I can save many lines with this...
[ ! -z "$DO_BUILD" ] && {
	for BUILD_CHOICE in ${DO_BUILD[@]}
	do
		for FR in $( ls "$SRCLIB/$BUILD_CHOICE" ) 
		do
			# List each line.
			LIB_FILE="$SRCLIB/${BUILD_CHOICE}/${FR}"
			LIB_FNAME="$(basename ${BUILD_CHOICE}/${FR%%.sh})"
			FL=$(wc -l "$LIB_FILE" | cut -d ' ' -f 1)

			# Did the user ask that this be excluded?
			[ ! -z "$WITHOUT" ] && \
				[[ $(is_element_present_in 'WITHOUT' "$LIB_FNAME") == 'true' ]] && \
				continue 
			
			# Also evaluate namespaces here.
			# grep -n -v '#' $LIB_FILE  
			
			# Can get the first line this way kind of...
			# exit

			# You might not want comments. 
			if [ -f "$LIB_FILE" ] 
			then 
				( sed -n 2,${FL}p $LIB_FILE 
				printf "\n" ) >> "$FILENAME"
			fi
		done
	done
}


# include all the libraries
#[ ! -z $DO_INC_ALL ] && {
#	while read line
#	do
#		# Save this b/c it's our folder name for different lib functions.
#		if [[ ${line:0:1} == '#' ]] || [[ -z "${line}" ]]
#		then
#			continue
#
#		# Proc
#		else
#			FNAME="$(echo $line | awk -F ':' '{print $1}' )"
#			LIB_FILE="$(echo $line | awk -F ':' '{print $2}' )"
#			FL=$(wc -l "$LIB_FILE" 2>/dev/null | cut -d ' ' -f 1)
#
#			# Did the user ask that this be excluded?
#			[ ! -z "$WITHOUT" ] && \
#				[[ $(is_element_present_in 'WITHOUT' "$FNAME") == 'true' ]] && \
#				continue 
#
#			# If the file doesn't exist, don't compile it.
#			if [ -f "$LIB_FILE" ] 
#			then 
#				( sed -n 2,${FL}p $LIB_FILE 
#				printf "\n" ) >> "$FILENAME"
#			fi
#		fi
#	done < $LOOKUP_MANIFEST
#}


# include all the libraries
[ ! -z $DO_LINKING ] && {
	# No directory specified. 
	[ -z "$LINK_AT" ] && echo "No directory specified for linking." && exit 1
	
	# Libs made with `bashutil` are always going to be under /lib 
	[[ ! $(basename "$LINK_AT") == "lib" ]] && LINK_AT="$LINK_AT/lib" 
	
	# Create this link directory. 
	[ ! -d "$LINK_AT" ] && mkdir $MKDIR_FLAGS $LINK_AT

	# Craft an OR query 
	for LIB in $(break_list_by_delim $LINK_WITH)
	do
		[ -z "$COMPLETE_OR" ] && COMPLETE_OR="name=$LIB" && continue
		COMPLETE_OR="${COMPLETE_OR} --or name=$LIB"
	done

	# Select location from this table.
	LINK_RESULTS=$(dbm --select 'location' --from libs --where $COMPLETE_OR)

	# A file for library includes...
	LIB_INC="$LINK_AT/__.sh"

	# Generate an array that will allow one to choose what 
	# should and should not be included.
	# (like source lib/*.sh)
	# (now namespaces are more important than ever...)
	( 
		printf "%s\n" "#!/bin/bash" 

		printf '_usage() {
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
'

		printf "%s\n\n" '__BULIBSRC__="$(dirname $(readlink -f $0))/lib"'
		printf "# Hold library names and checksums.\n"
		printf "%s\n" "BASHUTIL_LIBS=(" 
	

		# Craft a query.
		for FILE_FOUND in ${LINK_RESULTS[@]}
		do
			# Checksum of current file.
			# md5sum $COPIED_LIB
#__BULIBSRC__="$(dirname $(readlink -f $0))/lib"
#printf "# Hold library names and checksums.\n"
# BASHUTIL_LIBS=(" 

			COPIED_LIB="$LINK_AT/$(basename $FILE_FOUND)"
			if [ -f "$COPIED_LIB" ] 
			then
				# Get checksum and last modified date of both.
				# If checksum of COPIED_LIB is different from the original?
				# Supply overwrite to just blow away whatever's there...
				# md5sum $COPIED_LIB | awk '{print	$1}'
				printf 2>/dev/null
			fi


			# Store what's what lest my location changes for each link.
			SEED="$(dirname $LINK_AT)"
			FILE="$(basename $LINK_AT)"
			# dbm --insert-from-mem
			printf "\t%s" "\"$(basename $FILE_FOUND)\"" # >> $LIB_INC

			# Store the md5sum within the generated library file.
			# If the two are different, then updating can be 
			# automatically done...
			printf "%s\n" " # $(md5sum $SRCLIB/$FILE_FOUND | \
				awk '{print $1}')" # >> $LIB_INC

			# Link.
			[ ! -z $VERBOSE ] && LN_FLAGS="-v" || LN_FLAGS=""
			ln $LN_FLAGS $SRCLIB/$FILE_FOUND $COPIED_LIB 2>/dev/null
			unset LN_FLAGS
		done

		# Complete the generated library file.
		printf "%s\n\n" ")" 
		printf "# Load each library.\n"
		printf "for __MY_LIB__ in \${BASHUTIL_LIBS[@]}\n"
		printf "do\n"
		printf "\tsource \"\$__BULIBSRC__/\$__MY_LIB__\"\n"
		printf "done\n" 
	) > $LIB_INC

	# Make the file executable.
	chmod +x $LIB_INC

	# Test it.
	tmp_file -n TESTLIB 
	[ ! -z $VERBOSE ] && {
		printf "Testing library generated at: "
		printf "$(readlink -f $LINK_AT)\n" > /dev/stderr
	}
	printf "source $(readlink -f $LINK_AT)/__.sh\n" > $TESTLIB
	bash $TESTLIB
	tmp_file -w
}
