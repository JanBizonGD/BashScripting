#!/bin/bash
set -e 
# Fibbonaci sequence generator

if [ $# -lt 1 ] ; then
    echo "Wrong number of arguments - should be at least 1"
    exit 1
fi

# Global variables
f_N1=0                      # first relative term of sequence used to calculate new term
f_N2=1
TERM_NUMBER=$1

# Function definitions
fibbonacci () {
    #echo `expr $1 + $2`    # expr is archaic - should be avoided
    echo $(( $1 + $2 ))
}

# Program
if [ "$TERM_NUMBER" -lt 0 ] ; then 
    echo "Wrong number of sequence term - should be >= 0)."
    exit 1
elif [ "$TERM_NUMBER" -eq 0 ] ; then
    echo $f_N1
elif [ "$TERM_NUMBER" -eq 1 ] ; then 
    echo $f_N2
else
    TERM_NUMBER=$(( TERM_NUMBER - 1 ))
    for _ in $(seq "$TERM_NUMBER"); do 
        buff=$f_N2
        f_N2=$(fibbonacci "$f_N1" "$f_N2")
        f_N1="$buff"
    done
    echo "$f_N2"
fi

