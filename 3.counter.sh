#!/bin/bash
# Fizz Buzz counter

set -e 
# Variables

clear

# Main program
for i in {1..100} ; do 
    DIV3="$[ $[ i % 3 ] == 0 ]"
    DIV5="$[ $[ i % 5 ] == 0 ]"
    if [ $DIV3 -eq 1 ] && [ $DIV5 -eq 1 ] ; then 
        echo "FizzBuzz"
    elif [ $DIV3 -eq 1 ] ; then
        echo "Fizz"
    elif [ $DIV5 -eq 1 ] ; then
        echo "Buzz"
    else
        echo $i
    fi
done

