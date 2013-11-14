#!/bin/bash
#------------------------------------------------------
# where.sh 
# 
# Create clauses.
#-----------------------------------------------------#
where() {
	# Always find what you want to modify
	# Then set what you want to modify

	if [ ! -z "$1" ]
	then
		CLAUSE="WHERE $(echo $1 | sed "s/=/ = '/" | sed "s/$/'/" )"
	fi
}
