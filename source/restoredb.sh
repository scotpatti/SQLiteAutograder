#!/bin/bash
## EXPECTS TO RUN IN THE SOURCE DIRECTORY
dblist=`ls *.db`
for i in $dblist 
do
    if [ -f "${i}.original" ]; then
        cp "${i}.original" "$i"
    fi
done