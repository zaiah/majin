#!/bin/bash -
#-----------------------------------------------------#
# buildopts.sh
#
# Builds out the innards of a shell script.
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

LIC="${BINDIR}/licenses"
PROGRAM="buildopts"


# usage message
# Show a usage message and die.
usage() {
	STATUS=${1:-0}
	echo "
./$PROGRAM [ - ]

General options:
-f | --from <list>          Supply a list of options to create flags for.
-g | --generate             Generate a new manifest file.
-c | --clobber              Overwrite file if one exists.
     --library              Build as a package, versus a standalone script.

Shell Script tuning:
-d | --die-on-no-arg        Make changes on <file>.
-s | --summary <summ>       Add a quick summary.
-e | --license <type>       Add a particular license at the top of the script.
-l | --logic                Generate accompanying logic.
-n | --name <name>          Set up a script name.
-p | --program <name>       Set up a script name and use this name in a \$PROGRAM variable.
-o | --options              Generate a list of options.
-x | --only-options <list>  Do not generate logic for items in list.
-t | --to <file>            Make changes on <file>.
-i | --static <arg>         Turn list in <arg> to variables.
-u | --usage <file>         Make changes on <file>.
-z | --shell <type>         Choose a particular shell for she-bang line.
                            (Default is bash)
-m | --from-manifest        Generate through the use of a manifest file.
-ff| --functions-for <list> Generate some skelelon functions.
                            ( echo '...' is default )
-b | --binref               Include references to script file and directory 
                            that script resides in.
-y | --libref               Include references to library 
     --short-if             Use shorthand if-else form within logic.
-q | --make-exec            Set the executable bit on the resultant file.
-a | --all <arg>            Set all flags that don't require an argument.
                            <arg> is the name of the script.
     --library              Instead of creating a standalone script, create
	                         the scaffolding for a library.

General Options:
-v | --verbose              Be verbose in output.
-h | --help                 Show help and quit.
"
	exit $STATUS
}


# Die if no string received.
[ -z "$BASH_ARGV" ] && echo "Nothing to do." && usage 1 > /dev/stderr
while [ $# -gt 0 ]
do
	case "$1" in 
		-a|--all)
			PROC_ALL=true
			DO_SELFSOURCE=true
			DO_LIBSOURCE=true
			DO_PROGRAM=true
			SHOW_USAGE=true
			DO_COMMENTS=true
			DO_DIENARG=true
			SELECT_LICENSE=true
			DO_LOGIC=true
			DO_OPTIONS=true
			shift
			NAME="$1"
		;;

		-b|--binref)
			DO_SELFSOURCE=true
		;;

		-y|--libref)
			shift
			LIBREF="$1"
		;;

		-s|--summary)
			shift
			SUMMARY="$1"
		;;

		-f|--from)
			shift
			[[ "$1" =~ '|' ]] && {
				printf "Argument supplied via --from cannot contain a '|' character" > /dev/stderr
				exit 1
			}
			[ -z "$FROM" ] && FROM="$1" || FROM="$FROM|$1"
		;;

		-p|--program)
			DO_PROGRAM=true
			shift
			NAME="$1"
		;;

		-g|--generate)
			GENERATE=true
		;;

		-gi|--generate-install)
			GENERATE_INSTALL=true
		;;

		-c|--comments)
			DO_COMMENTS=true
		;;

		-a|--according-to)
			shift
			ACC_FILE="$1"
		;;

		-ff|--functions-for)
			DO_FUNCTIONS=true
			shift
			FUNCTION_LIST="$1"
		;;

		-d|--die-on-no-arg)
			DO_DIENARG=true
		;;

		-e|--license)
			SELECT_LICENSE=true
			shift
			LICENSE="$1"
		;;

		-i|--static)
			DO_STATIC=true
			shift
			STATIC_VARS="$1"
		;;

		-l|--logic)
			DO_LOGIC=true
		;;
		
		-m|--modify)
			MODIFY=true
			shift
			FILENAME="$1"
		;;

		-z|--shell)
			shift
			SHELL_ARG="$1"
		;;
		-n|--name)
			shift
			NAME="$1"
		;;

		-o|--options)
			DO_OPTIONS=true
		;;

		-x|--only-options)
			shift
			ONLY_OPTIONS="$1"
		;;

		-t|--to)
			shift
			FILENAME="$1"
		;;

		--library)
			MAKE_LIBRARY=true
		;;

		--short-if)
			SHORT_IF=true
		;;

		-q|--make-exec)
			MAKE_EXECUTABLE=true
		;;

		-u|--usage)
			SHOW_USAGE=true
		;;

		-v|--verbose)
			VERBOSE=true	
		;;

		-h|--help)
		usage 0
		;;

		--)
		;;

		-*) 
			printf "Unknown argument received: $1"  > $STDERR
		 	usage 1 
		;;

		*) break # Is this smart?
		;;
	esac
shift
done


# Generate a file.
FILENAME=${FILENAME:-'/dev/stdout'}
STDERR=${FILENAME:-'/dev/stderr'}
[[ ! $FILENAME == '/dev/stdout' ]] && [ -f $FILENAME ] && {
	rm $RM_FLAGS $FILENAME
}


# No more processing needed.
[ -z $DO_LOGIC ] && \
[ -z $SELECT_LICENSE ] && \
[ -z $DO_OPTIONS ] && \
[ -z $DO_STATIC ] && \
[ -z $SHOW_USAGE ] && \
[ -z "$SUMMARY" ] && \
[ -z "$NAME" ] && {
	( 
		printf "Nothing to do!" 
		usage 1
	) > $STDERR
}


# --all must have a list via --from.
[ ! -z $PROC_ALL ] && [ -z "$FROM" ] && {
	(
		printf "%s" "No list supplied via --from!"
		printf "Can't create options or usage menu "
		printf "without at least one argument here."
		usage 1
	) > $STDERR
}


# Need the ability to choose between action flags and logic / arugment flags.
# If there's no list, manifest or file to read, this is pretty much useless.
if [ -z "$FROM" ] || [[ "${FROM:0:1}" == '-' ]]
then
	if [ ! -z $DO_OPTIONS ] || \
		[ ! -z $DO_LOGIC ] || \
		[ ! -z $SHOW_USAGE ] || \
		[ ! -z $ONLY_OPTIONS ]
	then
		{
			printf "%s" "No list supplied via --from!" 
			usage 1
		} > $STDERR
	fi
else
	[[ "$FROM" =~ '|' ]] && FROM="`printf "$FROM" | sed 's/|/,/g'`"
fi



# Choose a shell.
SHELL=
case "$SHELL_ARG" in
	s|sh|SH|sH|Sh)
		SHELL="sh"
	;;
	z|zsh|ZSH|zSH|zSh|Zsh|ZsH)
		SHELL="zsh"
	;;
	b|bash)
		SHELL="bash"
	;;
	c|csh|CSH|cSH|cSh|Csh|CsH)
		SHELL="csh"
	;;
	k|ksh|KSH|kSH|kSh|Ksh|KsH)
		SHELL="ksh"
	;;
	*)
		SHELL="bash"
	;;
esac


# Print to file, stdout or temp 
{
	# Use a shebang line to invoke the right shell.
	[ -z $MAKE_LIBRARY ] && printf "#!/bin/${SHELL} -\n"


	# Set name and add some info.
	[ ! -z "$NAME" ] || [ ! -z "$SUMMARY" ] && {
		printf '#-----------------------------------------------------#\n'
		printf "# $NAME\n" 
		printf '#\n'
		printf "# $SUMMARY\n"
		printf '#-----------------------------------------------------#\n'
	}


	# Choose licenses.
	[ ! -z $SELECT_LICENSE ] && {
		printf -- '#-----------------------------------------------------#\n# Licensing\n# ---------\n'
		case $LICENSE in
			mit|MIT|gpl|GPL|apache|APACHE|eclipse|ECLIPSE)
				cat ${LIC}/${LICENSE}.txt | sed 's/^/# /'
			;;
		esac
		printf -- '#-----------------------------------------------------#\n'
	}

	# Print the function name.
	[ ! -z $MAKE_LIBRARY ] && printf "${NAME}() {\n"
} > $FILENAME


# Generate install.

# Make it look like a library.
if [ ! -z $MAKE_LIBRARY ] 
then 
	ADD_TAB="\t" 
	PROGNAME="LIBPROGRAM" 	# Should just be some random name.
else
	ADD_TAB=''
	PROGNAME="PROGRAM" 
fi


# Print to standard out or file.

	# ...
{	
	if [ ! -z $MAKE_LIBRARY ] 
	then 
		# Use a different name altogether.
		printf "$PROGNAME=\"${NAME}\"\n"

	else
		# Use $PROGRAM variable.
		[ ! -z $DO_PROGRAM ] && printf "$PROGNAME=\"${NAME}\"\n" 

		# Include a reference to self and the program's directory.
		[ ! -z $DO_SELFSOURCE ] || [ ! -z "$LIBREF" ] && {
			[ ! -z $DO_COMMENTS ] && printf '\n# References to $SELF\n' 

			printf 'BINDIR="$(dirname "$(readlink -f $0)")"\n'
			printf 'SELF="$(readlink -f $0)"\n' 

			[ ! -z "$LIBREF" ] && {
				[ ! -z $DO_COMMENTS ] && {
					printf '\n# Reference a central library\n' 
				}
				printf "LIB=\"\${BINDIR}/${LIBREF}\"\nsource \$LIB\n"
			}	
		}
	fi	

	# Create static variables. 
	[ ! -z $DO_STATIC ] && {
		# Die on no argument received.
		[ -z "$STATIC_VARS" ] && {
			( printf "%s\n" "Nothing supplied to --static flag!" 
			usage 1 ) > $STDERR
		}

		STATIC_ARR="$(break_list_by_delim "$STATIC_VARS")"

		# Comments 
		[ ! -z "$DO_COMMENTS" ] && printf "# Static variables\n"

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
		done
	}


	# Errors, Traps, Standard files.
	# (trap will be a built-in)
	[ ! -z "$ERROR" ] && {
		{
			printf -- "%s\n" "error() {"
			printf -- "\t%s\n" 'printf "$1\n" > /dev/stderr'
			printf -- "%s\n" "}"
		} > $FILENAME
	}


	# From
	[ ! -z "$FROM" ] && {
		# Catch arguments here if we want them.
		OPTS_FROM_LIST=( $( break_list_by_delim "$FROM" ) )
		[ ! -z "$ONLY_OPTIONS" ] && {
			NO_OPT_FROM_LIST=( $( break_list_by_delim "$ONLY_OPTIONS" ) )
		}

		# Break up arguments before moving further.
		COUNTER=0
		declare -a ARG_SUB_SET
		declare -a GENERATE_LOGIC_SET
		for EACH_ARG in ${OPTS_FROM_LIST[@]}
		do
			# ...
			if [[ ${EACH_ARG:0:1} == '@' ]] 
			then 
				ARG_SUB_SET[$COUNTER]=true 
			else
				ARG_SUB_SET[$COUNTER]=false
			fi

			# Set no logic.
			[ ! -z "$NO_OPT_FROM_LIST" ] && {
				if [ $( is_element_present_in "NO_OPT_FROM_LIST" "$EACH_ARG" ) == true ] || \
					[ $( is_element_present_in "NO_OPT_FROM_LIST" "${EACH_ARG:1:${#EACH_ARG}}" ) == true ]
				then
					GENERATE_LOGIC_SET[$COUNTER]=true 
				else
					GENERATE_LOGIC_SET[$COUNTER]=false
				fi
			}	

			COUNTER=$(( $COUNTER + 1 ))
		done	
		unset COUNTER


		# Move forward with setting flags.
		ARG_FLAG_SET=( $(echo ${OPTS_FROM_LIST[@]} | tr '[a-z]' '[A-Z]' | tr '-' '_') )
		COUNTER=0
		LIM=$(( ${#OPTS_FROM_LIST[@]} - 1 ))


		# Show a usage message.
		[ ! -z $SHOW_USAGE ] && {
			# Select which type of usage to use.
			[ ! -z $MAKE_LIBRARY ] && USAGE="${NAME}_usage" || USAGE="usage"

			# Print any comments. 
			[ ! -z $DO_COMMENTS ] && {
				printf "\n# $USAGE - Show usage message and die with \$STATUS\n"
			}

			# Eventually add option for top tags.
			printf "${USAGE}() {\n"
			printf '   STATUS="${1:-0}"\n'
			printf "   echo \"Usage: ./\$${PROGNAME}\n\t[ -  ]\n\n"

			# Logic
			for OPTCOUNT in `seq $COUNTER $LIM`
			do
				# Print formatted help with additional arguments.
				if [[ ${ARG_SUB_SET[$OPTCOUNT]} == true ]]
				then
					ARG_FLAG_NAME="${ARG_FLAG_SET[$OPTCOUNT]:1:${#ARG_FLAG_SET[$OPTCOUNT]}}"
					OPT_NAME="$( echo ${ARG_FLAG_NAME} | tr '[A-Z]' '[a-z]' )"
				#	ARG_LETTER=`push_option_alpha ${OPT_NAME:0:1}`
				#	push_option_alpha ${OPT_NAME:0:1}
				#	ARG_LETTER="$(get_last_alpha)"
					ARG_LETTER="${OPT_NAME:0:1}"

					printf -- \
						"$(printf -- "-${ARG_LETTER} | --${OPT_NAME} <arg>                     " | \
						head -c 30)"
					printf "desc\n"

				# Print formatted help without arguments.
				else
					OPT_NAME="$( echo ${OPTS_FROM_LIST[$OPTCOUNT]} | tr '[A-Z]' '[a-z]' )"
		#			ARG_LETTER=$(push_option_alpha ${OPT_NAME:0:1})
			#		push_option_alpha ${OPT_NAME:0:1}
			#		ARG_LETTER="$(get_last_alpha)"
					ARG_LETTER="${OPT_NAME:0:1}"

					printf -- \
						"$(printf -- "-${ARG_LETTER} | --${OPTS_FROM_LIST[$OPTCOUNT]}                      " | \
						head -c 30)"
					printf "desc\n"
				fi
			done

			printf -- '-v | --verbose                 ' | head -c 30 
			printf 'Be verbose in output.\n'
			printf -- '-h | --help                    ' | head -c 30
			printf 'Show this help and quit.\n"\n' 
			printf '   exit $STATUS\n'
			printf '}\n\n' 
		}	


		# Add some function bodies.
		if [ ! -z $DO_FUNCTIONS ]
		then
			# Comments.
			[ ! -z "$DO_COMMENTS" ] && printf "# Functions\n"

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
					printf "   echo '...'"
					printf "\n}\n\n" 
				fi
			done 
		fi


		# Die on no arguments.
		[ ! -z $DO_DIENARG ] && {
			# Print any comments. 
			[ ! -z $DO_COMMENTS ] && {
				printf '\n# Die if no arguments received.'
			}

			# Die!
			if [ ! -z $MAKE_LIBRARY ]
			then
				printf '\n[ -z "$#" ] && printf "Nothing to do\\n" > /dev/stderr && '
				printf "$USAGE 1\n"
			else
				printf '\n[ -z "$BASH_ARGV" ] && printf "Nothing to do\\n" > /dev/stderr && '
				printf "$USAGE 1\n"
			fi
		}


		# Process all the options.
		# unset OPTION_ALPHA
		if [ ! -z $DO_OPTIONS ]
		then
			# Print any comments. 
			[ ! -z $DO_COMMENTS ] && printf '\n# Process options.'

			# Do some basics.
			printf '\nwhile [ $# -gt 0 ]\ndo\n'
			printf '   case "$1" in\n' 


			# Generate list of options. 
			for OPTCOUNT in `seq $COUNTER $LIM`
			do
				#printf "Argument: ${ARG_SUB_SET[$OPTCOUNT]}"

				if [[ ${ARG_SUB_SET[$OPTCOUNT]} == true ]]
				then
					ARG_FLAG_NAME="${ARG_FLAG_SET[$OPTCOUNT]:1:${#ARG_FLAG_SET[$OPTCOUNT]}}"
					OPT_NAME="$( echo ${ARG_FLAG_NAME} | tr '[A-Z]' '[a-z]' | tr '_' '-')"

					# This is ridiculous...
					#push_option_alpha ${OPT_NAME:0:1}
					#ARG_LETTER="$(get_last_alpha)"
					ARG_LETTER=${OPT_NAME:0:1}

					# Can optionally loop these to go through whole range.
					# Also need to check if this first letter is a member of an array.
					#( printf -- "     -${OPT_NAME:0:1}|"
					printf -- "     -${ARG_LETTER}|"
					printf -- "--${OPT_NAME})\n"

					# Wants arg or not?
					[ ! -z "$DO_LOGIC" ] && {
						printf "         DO_$ARG_FLAG_NAME=true\n"
					}
					printf "         shift\n"
					printf "         ${ARG_FLAG_NAME}=\"\$1\"\n" 

					# Unset for the next round.
					unset ARG_FLAG_NAME
					unset OPT_NAME
				else
					# This is ridiculous...
					#push_option_alpha ${OPTS_FROM_LIST[$OPTCOUNT]:0:1}
					#ARG_LETTER="$(get_last_alpha)"
					ARG_LETTER=${OPTS_FROM_LIST[$OPTCOUNT]:0:1}

					#( printf -- "     -${OPTS_FROM_LIST[$OPTCOUNT]:0:1}|"
					printf -- "     -${ARG_LETTER}|"
					printf -- "--${OPTS_FROM_LIST[$OPTCOUNT]})\n"
					printf "         DO_${ARG_FLAG_SET[$OPTCOUNT]}=true\n" 
				fi

				printf "      ;;\n"
			done	


			# End the flags.
			printf '     -v|--verbose)\n        VERBOSE=true\n      ;;\n' 
			printf '     -h|--help)\n        '

			# Show the correct exit code.
			if [ ! -z $SHOW_USAGE ]
			then
				printf "$USAGE 0\n      ;;\n" 			# Only if USAGE was asked for.
			else
				printf 'exit 0\n       ;;\n'
			fi

			# Catch the signal for the end of the flags.
			printf '     --) break;;\n'

			# Catch unknown flags and show correct exit code.
			printf '     -*)\n   ' 
			printf '   printf \"Unknown argument received: $1\\n\" > /dev/stderr;\n'
			if [ ! -z $SHOW_USAGE ]
			then
				printf "      $USAGE 1\n     ;;\n"
			else
				printf '      exit 1\n     ;;\n'
			fi

			# Skip arguments.
			printf '     *) break;;\n'
			printf '   esac\nshift\n'	
			printf 'done\n' 
		fi


		# Process all the logic.
		if [ ! -z $DO_LOGIC ]
		then
			# Logic
			for OPTCOUNT in `seq $COUNTER $LIM`
			do
				# ...
				if [[ ${GENERATE_LOGIC_SET[$OPTCOUNT]} == true ]]
				then
					continue

				elif [[ ${ARG_SUB_SET[$OPTCOUNT]} == true ]]
				then
					ARG_FLAG_NAME="${ARG_FLAG_SET[$OPTCOUNT]:1:${#ARG_FLAG_SET[$OPTCOUNT]}}"

					# Print any comments. 
					[ ! -z $DO_COMMENTS ] && {
						printf "\n# $(printf ${ARG_FLAG_NAME} | \
							tr '[A-Z]' '[a-z]')"
					}

					# Then print the flag.
					if [ ! -z $SHORT_IF ]
					then
						printf "\n[ ! -z \$DO_${ARG_FLAG_NAME} ] && {\n"
					else
						printf "\nif [ ! -z \$DO_${ARG_FLAG_NAME} ]\n"
					fi

				else
					# Print any comments. 
					[ ! -z $DO_COMMENTS ] && {
						printf "\n# $(printf ${ARG_FLAG_SET[$OPTCOUNT]} | \
							tr '[A-Z]' '[a-z]')"
					}

					# Then print the flag.
					if [ ! -z $SHORT_IF ]
					then
						printf "\n[ ! -z \$DO_${ARG_FLAG_SET[$OPTCOUNT]} ] && {\n" 
					else
						printf "\nif [ ! -z \$DO_${ARG_FLAG_SET[$OPTCOUNT]} ]\n" 
					fi
				fi

				# End this logic. 
				if [ -z $SHORT_IF ] 
				then
					printf "then\n   printf '' > /dev/null\nfi\n"
				else
					printf "   printf '' > /dev/null\n"
					printf "}\n"
#					printf "   printf '' > /dev/null\n"
#					[ ! -z $SHORT_IF ] && printf "}\n" || printf "fi\n" 
				fi
			done
		fi
	}
} | sed "s/^/$ADD_TAB/g" >> $FILENAME

# Close off the remainder of the new library.
[ ! -z $MAKE_LIBRARY ] && printf "}\n" >> $FILENAME

# Make it executable?
[ ! -z $MAKE_EXECUTABLE ] && chmod +x $FILENAME
