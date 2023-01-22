#!/bin/bash
#Ran these commands to populate VerbType Dropdown:

# cat verb_stems.lexc | awk -F "[][]" '{print $2}' > classifications.txt
# cat classifications.txt | tr ' ' '\n' > sorted_classifications.txt 
# sort -u sorted_classifications.txt

# or one can simply run:
cat verb_stems.lexc | awk -F "[][]" '{print $2}' | tr ' ' '\n' | sort -u | grep -v "^#\|^$" | sed 's/^.*/"&",/' | tr '\n' ' ' > classifications.txt