#!/bin/bash 
set -e
# Simple calculator
#
# Data should be inserted as follows : 
# ./calcualtor.sh -o + -n "3 5 4" -d
# ./calcualtor.sh -n "3 5 4" -o \* -d
# -d should be last for proper printing of other variables
#
# Variables
OPTSTRING="o:n:d"
USERNAME=${USER}
nFLAG=false
oFLAG=false

# Input preprocessing
while getopts ${OPTSTRING} opt; do
    case $opt in
        o)
            OPERATION=$OPTARG
            # Incorrect input should trigger error in main program
            oFLAG=true
        ;;
        n)
            NUMBERS=($OPTARG)
            RESULT=${NUMBERS[0]}
            nFLAG=true
        ;;
        d)
            if [ $nFLAG = true ] && [ $oFLAG = true ] ; then
                echo "User: ${USERNAME}"
                echo "Script: $0"
                echo "Operation: ${OPERATION}" 
                echo "Numbers: ${NUMBERS[@]}"
            else 
                echo "-d should be last for proper printing of other variables."
            fi

        ;;
        \?)
          echo "Invalid option: -$OPTARG"
          ;;
        :)
          echo "Option -$OPTARG requires an argument."
          ;;
    esac
done

if [[ $OPTIND -eq 1 ]] ; then
    echo "Data should be inserted as follows :" 
    echo "./calcualtor.sh -o + -n \"3 5 4\" -d"
    echo "./calcualtor.sh -n \"3 5 4\" -o \\* -d"
    echo "Possible operations:"
    echo "+ /* % -"
fi

# Main program
for ARG in ${NUMBERS[@]:1}; do
    echo "ARG: ${ARG}"
   RESULT=$[ $RESULT $OPERATION $ARG ] 
done

if [[ -n $RESULT ]] ; then
    echo "Result: $RESULT"
fi

