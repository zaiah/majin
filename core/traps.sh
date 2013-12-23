
trap 'echo "Exit caught."' EXIT
trap 'echo "Interrupt caught."' INT 
trap 'echo "Abort caught.' ABRT 
trap 'echo "Quit caught."' QUIT
trap 'echo "Term(inate) caught. Dont you close me!" > /dev/stderr' TERM 
trap 'echo "Debug caught. Hello!" > /dev/stderr' DEBUG 
