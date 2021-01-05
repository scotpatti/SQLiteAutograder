#!/bin/bash
# This file expects your answer keys to be stored in key1.sql, ..., keyn.sql. 
# This file is used in run_autograder to generate output that will be checked
# against the student's queries output. 
# THIS SCRIPT EXPECTS TO BE RUN FROM THE ./source DIRECTORY.
# 
# 2021-Update. running this file will not change the database
echo "generate_keys.sh is running ..."
./create_originaldb.sh #safe to run multiple times
. ./get_database.sh # We can't guarantee that the database variable is set so we get it from currentdb.txt.
echo "  get_database.sh set DATABSE=$DATABASE"
./restoredb.sh
#DIRECTORY=.
keycount=`ls -lq | grep "key[0-9]*.sql" | wc -l`
for ((i=1; i<=$keycount; i++)) do
  #if you require a bash script before this question, run it now. It expects to be run from /
  if [ -f ./before${i}.sh ]; then
    echo "  before${i}.sh is running ..."
    cd ..
    script="./source/before${i}.sh"
    . $script
    cd source
  fi
  #if you provide a setup sql script for this question run it now.
  if [ -f key${i}s.sql ]; then 
    echo "  key${i}s.sql is running ..."
    sqlite3 -init sqliterc $DATABASE ".read key${i}s.sql"
  fi
  #key file is required!
  #echo "sqlite3 -init sqliterc $DATABASE \".read key${i}.sql\" > \"key${i}.txt\""
  sqlite3 -init sqliterc $DATABASE ".read key${i}.sql" > "key${i}.txt"
  #if you provide an alternate test sql script for this question, run it now
  if [ -f test${i}.sql ]; then
    echo "  test${i}.sql is running ..."
    sqlite3 -init sqliterc $DATABASE ".read test${i}.sql" > "key${i}.txt"
  fi
  #if you provide a teardown sql script for this question, run it now
  if [ -f key${i}t.sql ]; then
    echo "  key${i}t.sql is running ..."
    sqlite3 -init sqliterc $DATABASE ".read key${i}t.sql"
  fi
  #if you require a bash script after this question, run it now. It expects to be run from /
  if [ -f "./after${i}.sh" ]; then
    echo "  after${i}.sh is running ..."
    cd ..
    script="./source/after${i}.sh"
    . $script
    cd source
  fi  
done
./restoredb.sh
echo "generate_keys.sh is finished!"