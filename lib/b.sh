# cONvert...
while read line 
do
	if [[ ! $(echo $line | head -c 1) == "#" ]] && [[ ! -z "$line" ]] 
	then
	NAME="$(printf "%s\n" "$line" | awk -F ":" '{ print $1 }')"
	LOCATION="$(grep $NAME lookup.manifest | awk -F ":" '{ print $2 }')"
	DESCRIPTION=""
	DATE_ADDED="$(date +%s)"
	DATE_LAST_MODIFIED="$(date +%s)"
	else
		CLASS=$(printf "$line" | sed 's/# //')
		continue
	fi
	echo "INSERT INTO libs VALUES (
		null,
		'$LOCATION',
		'$NAME',
		'$CLASS',
		'',
		'$(md5sum $LOCATION | awk '{print $1}')',
		$DATE_ADDED,
		$DATE_LAST_MODIFIED
		);"
done < gen.manifest
