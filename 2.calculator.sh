#!/bin/bash 
set -e
# Simple calculator
#
# Data should be inserted as follows : 
# ./calcualtor.sh -o + -n "3 5 4" 12 -d
# ./calcualtor.sh -n "3 5 4" 6 -o \* -d
# -d should be last for proper printing of other variables
#

# Input checking
if [[ "$#" -lt 2 ]] ; then
    echo "Data should be inserted as follows :" 
    echo "./calcualtor.sh -o + -n \"3 5 4\" -d"
    echo "./calcualtor.sh -n \"3 5 4\" -o \\* -d"
    echo "Possible operations:"
    echo "+ \\* % -"
    exit 1
fi


# Variables
USERNAME=${USER}
numbersEmpty=true
operationEmpty=true

# Input preprocessing
while [ "$#" -gt 0 ] ; do   # for used insted of while - because for autoincrement variable, while breaking it is unpredictible
    case $1 in
        -o)
            shift 1
            OPERATION=$1
            if [[ $OPERATION == [^\*\+\-\%] ]] ; then
                echo "Wrong operation. Acceptable: '*', +, -, %"
                exit 1
            fi
            operationEmpty=false
            shift 1
        ;;
        -n)
            shift 1
            NUMBERS=()
            while [ "$#" -gt 0 ] ; do
                if [[ $1 =~ [0-9]+ ]] ; then
                    NUMBERS+=("$1")
                    shift 1
                else
                    break
                fi
            done
            result=${NUMBERS[0]}
            numbersEmpty=false
        ;;
        -d)
            if [ $numbersEmpty = false ] && [ $operationEmpty = false ] ; then
                echo "User name: ${USERNAME}"
                echo "Script name: $0"
                echo "Operation: ${OPERATION}" 
                echo "Numbers: ${NUMBERS[*]}"
            else 
                echo "-d should be last for proper printing of other variables."
            fi
            shift 1

        ;;
        *)
          echo "Invalid option: -$OPTARG"
            shift 1
          ;;
    esac
done

# Input checking - flags
if [ $numbersEmpty = true ] || [ $operationEmpty = true ] ; then
    echo "Data should be inserted as follows :" 
    echo "./calcualtor.sh -o + -n \"3 5 4\" -d"
    echo "./calcualtor.sh -n \"3 5 4\" -o \\* -d"
    echo "Possible operations:"
    echo "+ \\* % -"
    echo "--------------------------------------"
    echo "Lacks one of options."
    exit 1
fi

# Main program
for ARG in "${NUMBERS[@]:1}"; do
    #echo "ARG: ${ARG}"
   result=$(( $result $OPERATION $ARG ))
done

if [[ -n $result ]] ; then
    echo "Result: $result"
fi

