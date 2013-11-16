#!/bin/bash -
#-----------------------------------------------------#
# edit_in_place
#
# Opens a temporary file with variables within an editor.
#-----------------------------------------------------#
edit_in_place() {
	# Can use a timestamp...
	TMP="__file_`date +%s`__"

	# Edit and drop.
	echo $TMP

	# Loading the buffer after editing is smart.
}