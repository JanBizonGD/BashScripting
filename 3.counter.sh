#!/bin/bash
# Fizz Buzz counter

set -e
# Variables

clear

# Main program
for i in {1..100} ; do 
    DIV3=$(( i % 3 ))
    DIV5=$(( i % 5 ))
    if [ $DIV3 -eq 0 ] && [ $DIV5 -eq 0 ] ; then 
        echo "FizzBuzz"
    elif [ $DIV3 -eq 0 ] ; then
        echo "Fizz"
    elif [ $DIV5 -eq 0 ] ; then
        echo "Buzz"
    else
        echo "$i"
    fi
done

