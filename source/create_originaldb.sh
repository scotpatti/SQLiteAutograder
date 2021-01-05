#!/bin/bash
## EXPECTS TO BE RUN FROM ./source
dblist=`ls *.db`
for i in $dblist 
do
    if [ ! -f "${i}.original" ]; then
        cp $i "${i}.original"
    fi
done