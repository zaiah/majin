#------------------------------------------------------
# save_to_test.sh 
# 
# Testing...
#-----------------------------------------------------#

source save.sh

bla="THIS
THIS thing
That Thing THIS"


#shopt alias
#grep 'THIS' $0 | save -t VAR
echo "abc\ndef\n" | save -t VAR

echo "$VAR"
