#!/bin/bash
DIRECTORY=.
for i in $DIRECTORY/key[0-9]*.sql; do
  cp $i ../submission/${i/key/answer}
done
