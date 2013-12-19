#-----------------------------------------------------#
# manifest_parse
#
# Parses bashutil's manifest files.
#
# An example manifest looks something like this:
# 
# o:<program option>
# [ a: <argument name> ]
# [ c: <comment> ]
# [ v: <variable name> ]
# s: <short description>
# [ d: <long description> ]
# [ f: \n<function> ]
#  
# o and s are required for each.
#
# We parse each one or just a particular one.
#-----------------------------------------------------#
manifest_parse() {
	# Variable.
	LIBPROGRAM="manifest_parse"
	local LINE=
	local FORMAT=
	
	# manifest_parse_usage - Show usage message and die with $STATUS
	manifest_parse_usage() {
	   STATUS="${1:-0}"
	   echo "Usage: ./$LIBPROGRAM
		[ -  ]
	
	-f | --from <arg>             Use <arg> as the manifest. 
	-g | --get <arg>              Get a particular 
	-u | --usage                  Create the usage only from manifest. 
	-d | --description            Create the descriptions from manifest.
	-o | --options                Create the options from manifest. 
	-b | --build

	-m | --markdown               Create documentation in markdown format. 
	-h | --html                   Create an html documentation. 
	-t | --troff                  Create something in troff output for a man page. 

	-v | --verbose                Be verbose in output.
	-h | --help                   Show this help and quit.
	"
	   exit $STATUS
	}
	
	
	# Die if no arguments received.
	[ -z "$#" ] && {
		printf "Nothing to do\n" > /dev/stderr 
		manifest_parse_usage 1
	}
	
	# Process options.
	while [ $# -gt 0 ]
	do
	   case "$1" in
	     -f|--from)
	         shift
	         MANIFEST="$1"
			;;
	     -g|--get)
	         DO_GET=true
	         shift
	         GET="$1"
	      ;;
	     -u|--usage)
	         DO_USAGE=true
	      ;;
	     -d|--description)
	         DO_DESCRIPTION=true
	      ;;
	     -o|--options)
	         DO_OPTIONS=true
	      ;;
	     -b|--build)
	         DO_BUILD=true
	      ;;
	     -m|--markdown)
	         DO_MAN=true
	      ;;
	     -h|--html)
	         DO_HTML=true
	      ;;
	     -t|--troff)
	         DO_TROFF=true
	      ;;
	     -v|--verbose)
	        VERBOSE=true
	      ;;
	     -h|--help)
	        manifest_parse_usage 0
	      ;;
	     --) break;;
	     -*)
	      printf "Unknown argument received.\n" > /dev/stderr;
	      manifest_parse_usage 1
	     ;;
	     *) break;;
	   esac
	shift
	done

	# Only get certain term(s)
	[ ! -z $DO_GET ] && {
	   printf '' > /dev/null
	}

	# usage
	[ ! -z $DO_USAGE ] && {
	   printf '' > /dev/null
	}
	
	# description
	[ ! -z $DO_DESCRIPTION ] && {
	   printf '' > /dev/null
	}
	
	# options
	[ ! -z $DO_OPTIONS ] && {
	   printf '' > /dev/null
	}


	# Choose a format.
	# Be sure to allow one and only one of the following...
	# man
	[ ! -z $DO_MAN ] && FORMAT=man 
	
	# html
	[ ! -z $DO_HTML ] && FORMAT=html 
	
	# troff
	[ ! -z $DO_TROFF ] && FORMAT=troff 


	# Choose a file and move through each line finding
	# the range between \nL:0:2 and the next \nL:0:2

	# When processing each line.
	# Mega super bomb ray...
	local FILE_POS=0
	while read LINE 
	do
		# Keep track of our position.
		# [ ! $FILE_POS == 0 ] && FILE_POS=$(( $FILE_POS + 1 )) || FILE_POS=0
		FILE_POS=$(( $FILE_POS + 1 ))
		# echo $FILE_POS
		# echo -n sed: 
		# sed -n ${FILE_POS}p $MANIFEST

		# Move up by this number of lines within the file.
		[ ! -z $INC ] && {
			INC=$(( $INC - 1 ))
			[ $INC == 0 ] && unset INC && continue
			continue
		}

		# Evaluate
		case "${LINE:0:2}" in
			# o - option name 
			'o:'|'s:'|'v:'|'c:')
				[ ! -z $VERBOSE ] && {
					{	
						[ "${LINE:0:2}" == 'o:' ] && printf "option:\n" 
						[ "${LINE:0:2}" == 's:' ] && printf "short desc:\n" 
						[ "${LINE:0:2}" == 'v:' ] && printf "argv name:\n" 
						[ "${LINE:0:2}" == 'c:' ] && printf "comments:\n" 
					} > /dev/stderr
				}


				{	
					# Decide on long or short options.
					[[ "${LINE:0:2}" =~ [Oo]: ]] && {
						printf "%s\n" "${LINE:3:${#LINE}}"
					}

					# Always in the option call.
					[[ "${LINE:0:2}" =~ [Ss]: ]] && {
						printf "%s\n" "${LINE:3:${#LINE}}"
					}

					# Depending on case choice:
					# snake_case, capitalize, uppercase
					[[ "${LINE:0:2}" =~ [Vv]: ]] && {
						printf "%s\n" "${LINE:3:${#LINE}}" | \
							tr '[a-z]' '[A-Z]'
					}

					# Add a hash.
					[[ "${LINE:0:2}" =~ [Cc]: ]] && {
						printf "%s\n" "# ${LINE:3:${#LINE}}"
					}
				} 
			;;
#			'o:')
#				[ ! -z $VERBOSE ] && printf "option: " > /dev/stderr
#				# If an option is encountered check the CLOSEST range moving 
#				# towards the end of the file to get the argument name.
#				# Catch nothing if you catch \n\n, eof or any other flags before 
#				# the next o:
#
#				# Find first character that is not a space.
#				printf "%s\n" "${LINE:3:${#LINE}}"
#				continue
#			;;
#			# s - short description
#			's:')   
#				[ ! -z $VERBOSE ] &&  printf "short desc: " > /dev/stderr
#				printf "%s\n" "${LINE:3:${#LINE}}"
#				continue
#			;;
#			# v - argv name 
#			'v:')   
#				[ ! -z $VERBOSE ] &&  printf "argv name: " > /dev/stderr
#				printf "%s\n" "${LINE:3:${#LINE}}"
#				continue
#			;;
#			# c - comments
#			'c:')   
#				[ ! -z $VERBOSE ] &&  printf "comments: " > /dev/stderr
#				printf "%s\n" "# ${LINE:3:${#LINE}}"
#				continue
#			;;

			# d - long description
			'd:'|'f:')   
				# Messages.
				[ ! -z $VERBOSE ] && {
					{
						[ "${LINE:0:2}" == 'd:' ] && printf "long desc:\n" 
						[ "${LINE:0:2}" == 'f:' ] && printf "function :\n"
					} > /dev/stderr
				}

				# As long as the line is not empty. 
				while \
					[[ ! -z "$(sed -n ${FILE_POS}p $MANIFEST)" ]]  
				do
					UML="$(sed -n ${FILE_POS}p $MANIFEST)"

					# Wrong keyword, move on.
					[[ ${UML:0:2} =~ [oasvc]: ]] && break	

					# Description is in top line. 
					if [[ ${UML:0:2} =~ d: ]] || [[ ${UML:0:2} =~ f: ]]
					then
						printf -- "%s\n" "${UML:3:${#UML}}"

					# Put lines elsewhere.
					else	
						sed -n ${FILE_POS}p $MANIFEST | \
							sed 's/^[ \t]//g' >> /dev/stderr
					fi

					# Increase
					FILE_POS=$(( $FILE_POS + 1 ))
					INC=$(( $INC + 1 ))
				done
				continue
			;;

			*) continue ;;
		esac
	done < $MANIFEST
}



