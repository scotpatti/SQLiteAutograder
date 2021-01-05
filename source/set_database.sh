#!/bin/bash
## This file is run from other scripts in the source directory ./set_database.sh
## This file should be sourced e.g. . ./set_database [databasename]
## This file also sets the DATABASE variable. I.e. no need to call get_database.sh
if [ $1 ]; then 
    echo $1 > currentdb.txt
    export DATABASE=$1
    echo "  set_database.sh set DATABASE=$DATABASE"
else
    echo "  set_database.sh did not change the Database!"
fi

