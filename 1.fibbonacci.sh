#!/bin/bash
set -e 
# Fibbonaci sequence generator

# Global variables
FN1=0
FN2=1
N=$1

# Function definitions
fibbonacci () {
    #echo `expr $1 + $2`    # expr is archaic - should be avoided
    echo $(( $1 + $2 ))
}

# Program
if [ $N -lt 0 ] ; then 
    echo "Wrong number of iterations - should be >= 0)."
    exit 1
elif [ $N -eq 0 ] ; then
    echo $FN1
elif [ $N -eq 1 ] ; then 
    echo $FN2
else
    N=$(( $N - 1 ))
    for i in `seq $N`; do 
        X=$FN2
        FN2=`fibbonacci $FN1 $FN2`
        FN1=$X
    done
    echo $FN2
fi

