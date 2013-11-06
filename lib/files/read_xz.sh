#!/bin/bash -
#-----------------------------------------------------#
# read_xz
#
# Read a compressed file to stdout as long as it's gz, bz2 or 7z.
#-----------------------------------------------------#
read_xz() {
	local FILE=
	FILE=$1

	if [ -f "$FILE" ]
	then
		# Find shortest matching extension.
		case "${FILE##.*}" in
			gz)
				gzip -dc $FILE
				;;
			bz2)

				;;
			7z)

				;;
		esac
	fi
}
