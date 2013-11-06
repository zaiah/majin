#!/bin/bash -
#-----------------------------------------------------#
# load_from_db_columns
#
# Create a variable in Bash out of each column header in a table and fill it with information found in that column.
#-----------------------------------------------------#
load_from_db_columns() {
	# Die if no table name.
	TABLE="$1"

	if [ -z "$TABLE" ]
	then
		echo "In function: load_from_db_columns()"
		echo "\tNo table name supplied, You've made an error in coding."
		exit 1
	else
		# Use Some namespace...
		# LFDB
		TMP="/tmp"
		TMPFILE=$TMP/__lfdb.sql
		[ -e $TMPFILE ] && rm $TMPFILE
		touch $TMPFILE

		# Choose a table and this function should: 
		# Get column titles and create variable names.
		printf ".headers ON\nSELECT * FROM ${TABLE};\n" >> $TMPFILE

		LFDB_HEADERS=( $( $__SQLITE $DB < $TMPFILE | \
			head -n 1 | \
			sed 's/id|//' | \
			tr '|' ',' ) )

		LFDB_VARS=( $( $__SQLITE $DB < $TMPFILE | \
			head -n 1 | \
			sed 's/id|//' | \
			tr '|' ' ' | \
			tr [a-z] [A-Z] ) )

		# It may be more intelligent to go line by line for this...
		[ -e $TMPFILE ] && rm $TMPFILE

		# Get whatever settings we've asked for.
		printf "SELECT ${LFDB_HEADERS[@]} FROM ${TABLE};\n" >> $TMPFILE
		LFDB_RES=$( $__SQLITE $DB < $TMPFILE | tail -n 1 )
		[ -e $TMPFILE ] && rm $TMPFILE

		# Output a list of variables to temporary file.
		# This code needs to be introduced to our application somehow
		# eval is one choice
		# Files and source are another... (but not reliable if deleted) 
		TMPFILE=$TMP/__var.sh
		COUNTER=0
		for XX in ${LFDB_VARS[@]}
		do
			( printf "DEFAULT_${XX}='"
			echo $LFDB_RES | \
				awk -F '|' "{ print \$$(( $COUNTER + 1 )) }" | \
				sed "s/$/'/"
			printf "${XX}="
			printf '${'
			printf "$XX"
			printf ':-${DEFAULT_'
			printf "$XX"
			printf '}}\n' ) >> $TMPFILE
			COUNTER=$(( $COUNTER + 1 ))
		done

		# Load these within the program.
		#cat $TMPFILE
		source $TMPFILE
		[ -e $TMPFILE ] && rm $TMPFILE
	fi
}
