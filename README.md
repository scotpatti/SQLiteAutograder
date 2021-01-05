# SQLiteAutograder for Gradescope - For assignments and tests.

This folder mimics the contents of the Autograder feature on gradescope.com. 
Only the ./source folder contains files that need to be edited. 

## TYPICAL USE CASE:

1. Create a database file using sqlite3 
   1. Place the database file in the source directory
   2. Edit the source/currentdb.txt file replacing university.db with your filename.
2. Write a series of query key files (in the education parlance not the security parlance). They should be named key1.sql, key2.sql ... and they should contain only one query per file. I almost always recommend that you include a ORDER  BY clause. Currently this tool does not do set comparison, it does string comparison. You can also create optional files:
   1. Optionally create a before script named before[x].sh file (where X is the problem number) that runs before the problem is graded. In here you can change the environment such as running `cd source && ./set_database.sh new.db && cd ..`
   2. Optionally create a setup sql file named key[x]s.sql - a file that runs before the key file (Name example: key1s.sql, key2s.sql, ...). Be very careful with these, you should not need them.
   3. Optionally create a teardown sql file named key[x]t.sql - a file that runs after the key file (Name example: key1t.sql, key2t.sql, ...). Be very careful with these, you should not need them. 
   4. Optionally create a different sql file to run a separate test after the students submitted file runs. Name this file test[x].sql (Nameing example: test1.sql, test2.sql, ...). Whenever you modify the database in the student's answer, you probably want to test for that modification. This is where you do that. 
   5. Optionally create a test[x].sh file that returns a 0 if passed and 1 if failed (using bash convention) You may do anything in this shell script. E.g. I used it to determin if a student is using NATURAL JOIN - I don't allow that. We could also use it to exclude a sub query or an outer join. 
   6. For example, in grading answer1.sql submitted by the student, this starts the following sequence of events
      1. if before1.sh exists, it is run (no output is saved)
      2. if key1s.sql exists, it is run (no output is saved)
      3. key1.sql is run (output is saved to results1.json)
      4. if test1.sql exists, it is run and output replaces results1.json (if I want to test side effects of the answer1.sql)
      6. if test1.sh exists, it is run and output replaces results1.json (if I want to test the answer1.sql directly)
      7. if key1t.sql exists, it is run (no output is saved)
      8. if after1.sh exists, it is run (no output is saved)
   7. NOTE: Each grading run may change the database during the run, but after the run the database will be restored to its original state. 
3. Delete any keyN.sql files that you did not overwrite.
4. From the source directory run ./test and inspect the output. If any answers are listed as incorrect. There is a problem with one of your queries. 
5. After you are happy with your queries, from the source directory run ./clean which will delete all the generated files used in the test. 
6. From the source directory run ./generate_upload_zip
7. Upload the zip file to gradescope following their directions.
8. To test on grade scope submit your answers in files named answer1.sql, ..., answerN.sql

# Parts and pieces explained

## Testing

To Test your files (from the source directory) run 

`./test` 

This will run several commands (see the script to see what is actually happening) that outputs the json results file that Gradescope uses. Examine the output to make sure that all the answers are correct. They should be correct because the script is copying the key files to answer files and then comparing the output of each query. Not a great test, but a basic one. I always test my queries in sqlite browser before I put use them in this tool. 

## File details
The following files should exist in your source directory and have the given functionality:

1. `setup.sh` - Autograder required file. It makes sure sqlite3 is installed
2. `university.db` - sqlite database that we are using to test our queries. You should upload your own. 
3. `set_database.sh [databasename]` is the file that sets the database to use. You will need to edit the `currentdb.txt` file if you rename the database. 
4. `run_autograder` - Autograder required file. This file is what is run by the autograder system. For more information see comments in this file. 
5. `grade.sh` - Used by run_autograder to grade each individual query. See file for additional information. 
   1. runs `before[x].sh` which allows you to change the environment such as running `cd source && ./set_database.sh new.db && cd ..`
   2. runs `key[x]s.sql` against database in case you need to setup/alter the database for this question - not a permenant change!
   3. runs `key[x].sql` against database and outputs results to `key[x].txt`
   4. runs `key[x]t.sql` against database in case you need to teardown any changes you made.
   5. runs `after[x].sh` 
6. generate_* files are simple scripts that generate sets of files that you can use to troubleshoot your queries.
    1. `generate_keys` takes key1.sql, key1s.sql, key1t.sql, test1.sql, ..., keyn.sql, keyns.sql, keynt.sql, testn.sql and generates the output of those queries to key1.txt, ..., keyn.txt. These are used in `grade.sh`
    2. `generate_answers` copies the keyX.sql files and moves them to the submission folder for testing the run_autograder script. 
    3. `generate_error_answers` copies erroneous answers to the submission folder for testing the run_autograder script.. 
    4. `generate_upload_zip` creates a zip file for you to upload to `Gradescope.com`
7. `cleanup` removes temporary files created during testing. 
8. key*.sql: a series of key1*.sql...keyN*.sql; test1.sql, ..., testN.sql are files that contain the setup, answers, teardown and alternate tests for your SQL questions. These files are run on the database to create answers that are used to grade your student's submission files. 
9.  *.json files are used to construct a results.json file for `Gradescope.com`.