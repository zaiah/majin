# Manifests 
SRCLIB="${BINDIR}/bulib"
#LIB_MANIFEST="${SRCLIB}/gen.manifest"
#LOOKUP_MANIFEST="${SRCLIB}/lookup.manifest"

# Filenames
FILENAME="/dev/stdout"
FILEERR="/dev/stderr"
DB="$SRCLIB/libs.db"

# Gotta deal with these within the lib.
DELIM=","
JOIN="="

# Library and directory name
LIBNAME="bashutil"
PROGRAM_DIR="$HOME/.${LIBNAME}"

# Standard directories
CORE_DIR="${PROGRAM_DIR}/core"
LIB_DIR="${PROGRAM_DIR}/lib"
LICENSES_DIR="${PROGRAM_DIR}/licenses"
HOST_DIRS=( 
	"${PROGRAM_DIR}" 
	"${PROGRAM_DIR}/core" 
	"${PROGRAM_DIR}/lib" 
	"${PROGRAM_DIR}/licenses" 
)


# Set the right internal field seperator for command line args.
IFS=' 
	'

# Limits file creation permissions.
UMASK=002
umask $UMASK

# Set a normal path.
PATH="/usr/local/bin:/bin:/usr/bin:/usr/sbin:/usr/local/sbin"
export PATH

