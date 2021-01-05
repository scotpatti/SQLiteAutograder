#!/bin/bash
# Send the problem # E.g. 1, 2, etc.
# Send "No" if this is the last one E.g. json doesn't allow trailing commas in general.
# Expect key${problem}.txt e.g. key1.txt to contain the output of a the correcte query for problem 1.
# Expect student answers for problem 1 to be named answer1.txt
# Expects to be in the root directory (i.e. not in source)
problem=$1
comma=$2
CORRECTQ=`cat ./source/correctQuery.json`
ERRORQ=`cat ./source/errorQuery.json`
# If there is setup for the problem, do it here e.g. you can change the database here
if [ -f "./source/before${problem}.sh" ]; then
   echo "  before${problem} is running ..."
   script="./source/before${problem}.sh"   
   . $script
fi
# If you need to alter the database before the query, do it here e.g. you shouldn't need this.
if [ -f "./source/key${problem}s.sql" ]; then
   echo "  key${problem}s.sql is running ..."
fi
# run the actual student query here 
sqlite3 -init ./source/sqliterc ./source/${DATABASE} ".read ./submission/answer${problem}.sql" > results${problem}.txt
# if you need to run an alternate sql test, do it here e.g. if you need to test for student side effects
alternate_sql_test="./source/test${problem}.sql"
if [ -f $alternate_sql_test ]; then
   echo "  ${alternate_sql_test} running..."
   sqlite3 -init ./source/sqliterc ./source/${DATABASE} ".read ${alternate_sql_test}" > results${problem}.txt
fi
# if you need to run an alternate test against the sql source, do it here e.g. testing for subqueries
alternate_source_test="./source/test${problem}.sh"
if [ -f $alternate_source_test ]; then 
   echo "  test${problem}.sh is running..."
   eval "${alternate_source_test} ./submission/answer${problem}.sql"
   result=$?
   if [ "$result" -gt 0 ]; then
      echo "  ./source/test${problem}.sh failed!"
      echo "Failed generic test" > results${problem}.txt
   fi
fi
# If there is teardown for the problem, do it here e.g. you can change the database back to the original if need be
if [ -f "./source/after${problem}.sh" ]; then
   echo "  after${problem}.sh is running ..."
   script="./source/after${problem}.sh"
   . $script
fi
# Compare your results to the students results
if cmp -s ./source/key${problem}.txt results${problem}.txt; then
   result="${CORRECTQ/REPLACE/$problem}" > ./results${problem}.json
else
   result="${ERRORQ/REPLACE/$problem}" > ./results${problem}.json
fi
if [ $comma = "No" ]; then
   result="${result/'},'/'}'}" # RegEx substitution
fi
echo $result > ./results${problem}.json
# In debugging, comment out the next line
rm results${problem}.txt
