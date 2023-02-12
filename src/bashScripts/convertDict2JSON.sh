#/bin/bash
# usage: bash convertDict2JSON.sh "verb_stems.lexc" "cwDictionary.txt"
# ONE MUST REMOVE COMMA AFTER THE FINAL OBJECT MANUALLY
FILE="$1" #change this to $1 to use the first argument passed as the file
TEMPFILE="test.txt"
OUTFILE="cwDictionary.txt"

convertCSV(){
    while read line; do
    echo $line | sed -e 's/\[/;/1' -e 's/\]/;/1' >> $2
done < $1
}

generateJSON(){
echo "[" >> $2
while IFS=";" read -r LEMMA VTYPE DEFINITION
do
DEFINITION="$(sed s/\"/\'/g <<<$DEFINITION | sed 's/^[ \t]*//g; s/[ \t]*$//g')"
echo "{ \"lemma\":\"${LEMMA}\", \"verbtype\":\"${VTYPE}\", \"definition\":\"${DEFINITION}\" }," >> $2
done < <(grep -v "^#\|^$" $1)
# sed 'x; ${s/\},/\}/;p;x}; 1d' $2 
echo "]" >> $2
}

# removeTrailingComma(){
#     SECONDLASTLINE=$( tail -n 2 $1)
    
# }
[ -e $OUTFILE ] && rm $OUTFILE
[ -e $TEMPFILE ] && rm $TEMPFILE
touch $TEMPFILE
touch $OUTFILE
convertCSV "$FILE" "$TEMPFILE"
generateJSON "$TEMPFILE" "$OUTFILE"
# removeTrailingComma "$OUTFILE"
rm $TEMPFILE
