# SQLiteAutograder for Gradescope - For assignments and tests.

This folder mimics the contents of the Autograder feature on gradescope.com. 
Only the ./source folder contains files that need to be edited. 

## TYPICAL USE CASE:

1. Create a database file using sqlite3 
  2. Place the database file in the source directory
  3. Edit the source/set_database file replacing university.db with your filename.
2. Write a series of query key files (in the education parlance not the security parlance). They should be named key1.sql, key2.sql ... and they should contain only one query per file. 
3. Delete any keyN.sql files that you did not overwrite.

## Testing

To Test your files (from the source directory) run 

`./test` 

This will run several commands (see the script to see what is actually happening) and outputs the results file that will be used by Gradescope. 

## File details
The following files should exist in your source directory and have the given functionality:

1. setup.sh - Autograder required file. It makes sure sqlite3 is installed
2. university.db - sqlite database that we are using to test our queries. You should upload your own. 
3. set_database is the file that sets the database name for all the scripts. You will need to edit this file if you rename the database. 
4. run_autograder - Autograder required file. This file is what is run by the autograder system. For more information see comments in this file. 
5. grade.sh - Used by run_autograder to grade each individual query. See file for additional information. 
6. generate_* files are simple scripts that generate sets of files that you can use to troubleshoot your queries.
  1.  generate_keys takes key1.sql, ..., keyn.sql and generates the output of those queries to key1.txt, ..., keyn.txt. These are used in grade.sh
  2.  generate_answers copies the keyX.sql files and moves them to the submission folder for testing the run_autograder script. 
  3.  generate_error_answers copies erroneous answers to the submission folder for testing the run_autograder script.. 
  4.  generate_upload_zip creates a zip file for you to upload to Gradescope.com
7. cleanup removes temporary files created during testing. 
8. keyN.sql: a series of key1.sql...keyN.sql files that contain the answers to your SQL questions. These files are run on the database to create answers that are used to grade your student's submission files. 
9. *.json files are used to construct a results.json file for Gradescope.com.