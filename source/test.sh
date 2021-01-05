#!/bin/bash
#used to generate answers!
./generate_keys.sh
./generate_answers.sh
cd ..
./source/run_autograder
echo "RESULTS OF TEST:"
cat results/results.json
cd source
