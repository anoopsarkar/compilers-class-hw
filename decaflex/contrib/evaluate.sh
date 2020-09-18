FILES=references/dev/*.out
for filename in $FILES; do 
	IFS='/' read -r -a file <<< "$filename" 
	REFERENCE=references/dev/${file[2]} 
	OUTPUT=output/dev/${file[2]} 
	DIFF=$(diff $REFERENCE $OUTPUT -y --suppress-common-lines) 
	if [ "$DIFF" != "" ]
	then 
		IFS='.' read -r -a f <<< "${file[2]}" 
		echo "$f"
		echo "$DIFF" >&2
	fi 
done

FILES=references/dev/*.ret
for filename in $FILES; do 
	IFS='/' read -r -a file <<< "$filename" 
	REFERENCE=references/dev/${file[2]} 
	OUTPUT=output/dev/${file[2]} 
	DIFF=$(diff $REFERENCE $OUTPUT -y --suppress-common-lines) 
	if [ "$DIFF" != "" ]
	then 
		IFS='.' read -r -a f <<< "${file[2]}" 
		echo "$f"
		echo "$DIFF" >&2
	fi 
done