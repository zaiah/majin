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
grep 'THIS' $0 | sed 's/^/### /' | save --diag -t VAR

echo $VAR
