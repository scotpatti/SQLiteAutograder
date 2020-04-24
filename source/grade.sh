#!/bin/bash
# Send the problem # E.g. 1, 2, etc.
# Send "No" if this is the last one E.g. json doesn't allow trailing commas in general.
# Expect key${problem}.txt e.g. key1.txt to contain the output of a the correcte query for problem 1.
# Expect student answers for problem 1 to be named answer1.txt
problem=$1
comma=$2
CORRECTQ=`cat ./source/correctQuery.json`
ERRORQ=`cat ./source/errorQuery.json`
sqlite3 -init ./source/sqliterc ./source/${DATABASE} ".read ./submission/answer${problem}.sql" > results${problem}.txt
if cmp -s ./source/key${problem}.txt results${problem}.txt; then
   result="${CORRECTQ/REPLACE/$problem}" > ./results${problem}.json
else
   result="${ERRORQ/REPLACE/$problem}" > ./results${problem}.json
fi
if [ $comma = "No" ]; then
   result="${result/'},'/'}'}"
fi
echo $result > ./results${problem}.json
rm results${problem}.txt
