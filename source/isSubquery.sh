#!/bin/bash
## isSubquery expects to be run from root
## isSubquery returns 0 if the given file contains a subquery or set operation (involving two queries) and 1 otherwise
answer=`cat $1`
regex='.*FROM +.*SELECT +.*'
if [[ "${answer^^}" =~ $regex ]]; then
    exit 0
else 
    exit 1
fi