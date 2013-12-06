#!/bin/bash
BASHUTIL_LIBS=(
	'lib/break_list_by_delim.sh' # 059619afaf95f737eb844ce92e470ce5
	'lib/break_maps_by_delim.sh' # a4ddc2e9ba4a81dec71d2397fed440fd
	'lib/is_element_present_in.sh' # 4a85d469af74c76c14f199c287ee989e
	'lib/eval_flags.sh' # 4d2b5aae266d3478cfa28660762894f2
	'lib/is_flag.sh' # 16049b3a35923617ea653ff4325fcd36
	'lib/tmp_file.sh' # 9eda50a97c7b97a3976d6412a0c973fa
	'lib/dbm.sh' # 
)

# ...
for __MY_LIB__ in ${BASHUTIL_LIBS[@]}
do
	source "$__MY_LIB__"
done
