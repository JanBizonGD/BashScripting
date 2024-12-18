#!/bin/bash 
# Script to cipher wiht caesar cipher.
#
# Example : ./caesar_cipher.sh -i message.txt -o cipher.txt -s 10
#
set -u

# Variables
OPTSTRING=":i:o:s:v-:"
A=65                            # eq A in ASCII
z=122
ALPH_SIZE=26                    # a-z range size
suppress=false
INPUT=
OUTPUT=
SHIFT=

# Input processing
while getopts ${OPTSTRING} opt; do
    case "${opt}" in
    -)
        case "${OPTARG}" in
            suppress)
                suppress=true
                echo Output is suppressed
                ;;
                \?)
                     echo "Invalid option: -$OPTARG"
                ;;
        esac
        ;;
    i)
        INPUT=${OPTARG}
        if [ ! -f "$INPUT" ] ; then 
            echo Wrong input file: "${INPUT}"
            exit 1
        fi
    ;;
    o)
        OUTPUT=${OPTARG}
        if [ ! -f "$OUTPUT" ] ; then 
            echo Wrong output file: "${OUTPUT}"
            exit 1
        fi
    ;;
    s)
        SHIFT=${OPTARG}
        if [ "$SHIFT" -le 0 ] ; then
            echo Shift should be '>' 0
        fi
    ;;
    v)
        echo "input: ${INPUT}"
        echo "output: ${OUTPUT}"
        echo "shift: ${SHIFT}"   
    ;;
    \?)
         echo "Invalid option: -$OPTARG"
    ;;
    :)
        echo "Option -$OPTARG requires an argument."
        exit 1
    ;; 
    esac
done

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ] || [ -z "$SHIFT" ] ; then
    echo Lacking at least one of arguments: execute with -v for more info. 
    exit 1
fi


# Main program

STDOUT=/dev/stdout
if [ $suppress = true ]; then
    STDOUT=/dev/null
fi

awk -v low=$A -v high=$z -v shift="$SHIFT" -v alph_size="$ALPH_SIZE" '
BEGIN {
for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
};
{ 
split($0, chars, "");
for (i=1; i <= length($0); i++) {
    character = chars[i]  
    if( character ~ /[A-Z]/) {
        ciph = ((_ord_[character] - _ord_["A"] + shift ) % alph_size ) + _ord_["A"];
    } else if( character ~ /[a-z]/) {
        ciph = ((_ord_[character] - _ord_["a"] + shift ) % alph_size ) + _ord_["a"];
    } else {
        ciph = character;
    }
    printf("%c", ciph);

}
    print ""
} ' "${INPUT}" | tee "${OUTPUT}" > "${STDOUT}"

