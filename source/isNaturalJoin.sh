#!/bin/bash
## isSubquery returns 0 if the given file contains NATURAL JOIN and 1 otherwise
echo $1
answer=`cat $1`
regex='.*NATURAL\s+JOIN.*'
if [[ "${answer^^}" =~ $regex ]]; then
    exit 0
else 
    exit 1
fi