
source installation.sh

# When using declare, do it from within the function.

# Files and whatnot and stuff....
tmp_file -n TEST_ME
cat installation.sh > $TEST_ME
installation

declare | less
# Find the opening line...
# Then run declare from within the function
#declare -f


# source tmp_file.sh
