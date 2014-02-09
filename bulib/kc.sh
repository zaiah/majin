kc() {
	DEST=$1
	SRC=$2
	if [ -z "$DEST" ] || [ -z "$SRC" ]
	then
		echo "Both destination and source directories must be specified."
		echo "Usage: kc . ~/www/mrdrstatus"
		return

	else
		#DIFF_OPTS="--side-by-side --recursive"
		DIFF_OPTS="--recursive"
		# Hard link the interface, so we're working off of the same copy.
		for EACHFILE in $SRC/interface/*
		do
			[ -d $EACHFILE ] && for y in `ls $EACHFILE`; do diff $DIFF_OPTS $EACHFILE/$y $DEST/interface/$(basename $EACHFILE)/$y | colordiff; done
			[ -f $EACHFILE ] && diff $DIFF_OPTS $EACHFILE $DEST/interface/$(basename $EACHFILE) | colordiff
		done	
	fi
}

# Merge the changes found in the interface.
kd() {
	DEST=$1
	MERGE=$2
	C=0
	declare -A MERGE_FILES
	if [ -z "$DEST" ]
	then
		echo "Usage: kd <dir>"
		echo "You must use this command with a filename path (Try '.')."
		return
	else
		for EACH in $DEST/interface/*
		do
			if [ -d $EACH ]
			then
				for FILE in $EACH/*.lua
				do
					INT_FILE=$INTERFACE/$(basename $EACH)/$( basename $FILE)
					DIFF=$(diff -s $FILE $INT_FILE )
					if [[ $DIFF != "Files $FILE and $INT_FILE are identical" ]] && [ -f $INT_FILE ]
					then
						echo "$FILE is not in Pagan distribution."
						if [ ! -z $MERGE ] && [[ $MERGE == "merge" ]]
						then
							cp -v $FILE $INTERFACE/$(basename $EACH)
						fi
					fi
				done
			fi
		done
	fi
}

# Commit a new copy of Pagan.
commit_new_copy() {
	cd $INTERFACE
	git commit -a
	cd -
}


# View todo list.
[ -z "$BASH_ARGV" ] && usage 1 "Nothing to do."
while [ $# -gt 0 ]
do
	case "$1" in
		# Don't increase the version number.
		# (Maybe it's a very insignificant change.
		-n|--no-version-increase)
			NO_INCREASE_VERSION=true
			;;

		# Quite possibly the most useless function you could add.
		-m|--commit)
			COMMIT=true
			;;

		# Update stable version. 
		-c|--commit-production)
			COMMIT=true
			IVERSION="p"
			;;

		# Update development version.
		-d|--commit-development)
			COMMIT=true
			IVERSION="d"
			;;

		# Push either version
		-p|--push)
			DO_PUSH=true
			;;

		# Pack stable version (users who want development can git pull)
		-k|--pack)
			COMMIT=true
			DO_PUSH=true
			DO_PACK=true
			IVERSION="p"
			;;

		# Show the differences between versions.
		-f|--differences)
			DO_SHOWDIFF=true
			shift
			INSTANCE=$1
			;;

		# Show the difference in a particular file.
		--diff-in)
			DO_SINGLE_SHOWDIFF=true
			shift
			IFILE=$1
			;;

		# Run an instance:
		# 	with an interface directly linked to the development version.
		--run-linked)
			UPDATE_INSTANCE=true
			RUNTYPE="linked"
			shift
			INSTANCE_NAME="$1"
			;;

		#  with a clone of the latest development version
		--run-snapshot)
			UPDATE_INSTANCE=true
			RUNTYPE="snap"
			IISNAP=true
			shift
			INSTANCE_NAME="$1"
			;;

		#  or from the latest stable version.
		--run-stable)
			UPDATE_INSTANCE=true
			RUNTYPE="stable"
			shift
			INSTANCE_NAME="$1"
			;;

		# Set up a passphrase or public key auth method.
		# Or maybe we'll have a bunch of users with passwords...

		# Choose between versions when it's not convenient to use a ton
		# of arguments.
		-e|--version)
			shift
			IVERSION=$1
			;;

		# Tell me errrthang
		-v|--verbose)
			VERBOSE=true
			;;

		# Show help message and die.
		-h|--help)
			usage 0;;
		-*)
			echo "Unrecognized option: $1"
			usage 1;;
		*)
			break;;
	esac
	shift
done


INTERFACE_PERM_STABLE="$HOME/projects/kirk/kirk/www"
INTERFACE_STABLE="$HOME/projects/kirk/kirk/www-stable"
INTERFACE_DEVELOPMENT="$HOME/www/new.testbed/interface"
COMMIT_DIR=

#echo $INTERFACE_STABLE
#echo $INTERFACE_DEVELOPMENT

# Verbosity?
if [ ! -z $VERBOSE ]
then
	MV_FLAGS="-v"
	LN_FLAGS="-v"
	MKDIR_FLAGS="-pv"
	GZCREATE_FLAGS="czvf"
	BZ2CREATE_FLAGS="cjvf"
	UNGZ_FLAGS="xzvf"
	UNBZ2_FLAGS="xjvf"
	SCP_FLAGS="-v"
	RM_FLAGS="-rfv"
else
	MV_FLAGS=
	LN_FLAGS=
	MKDIR_FLAGS="-p"
	GZCREATE_FLAGS="czf"
	BZ2CREATE_FLAGS="cjf"
	UNGZ_FLAGS="xzf"
	UNBZ2_FLAGS="xjf"
	SCP_FLAGS=
	RM_FLAGS="-rf"
fi


# Update the interface.
if [ ! -z $UPDATE_INSTANCE ]
then
	INSTANCE_DIR="$($__SQLITE $__DB "SELECT srv_path FROM instances WHERE user_owner = '${USER_NAME-${USER}}