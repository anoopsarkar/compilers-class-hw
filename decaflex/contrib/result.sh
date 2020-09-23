
for file in "$@"
do
	echo ---- Original ----
	cat testcases/dev/"$file".decaf
	echo ---- Expected ----
	cat references/dev/"$file".out
	echo ---- Actual ----
	cat output/dev/"$file".out
	echo
	echo
done