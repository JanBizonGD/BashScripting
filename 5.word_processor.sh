#!/bin/bash 
# Word processor
#
# Example use:
# ./word_processor.sh -r -l -i message.txt -o converted.txt -s Hello "Good Morning"

set -e

# Variables
lowerFlag=false
reverseFlag=false
upperFlag=false
flipCaseFlag=false
substituteFlag=false
OPTSTRING=":rluvs:i:o:"

# Functions
take_not_empty () {
    if [[ -n "$1" ]] ; then
        echo "$1"
    else
        echo "$2"
    fi
}


# Input processing
while getopts ${OPTSTRING} opt ; do
    case "${opt}" in
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
    r)
        reverseFlag=true
    ;;
    l)
        lowerFlag=true
        if [ $upperFlag = true ]  ; then
            upperFlag=false
            echo Lowercase is being used
        fi
    ;;
    u)
        upperFlag=true
        if [ $lowerFlag = true ]; then
            lowerFlag=false
            echo Uppercase is being used
        fi
    ;;
    v)
        flipCaseFlag=true
    ;;
    s)
        substituteFlag=true
        shift $(( OPTIND - 1 )) # changing pointer on input - then there is known that 2nd argument for s is $1
        AWORD=${OPTARG}
        BWORD=$1
        shift 1                 # skipping $1 for furthure search
        OPTIND=1                # now OPTIND should start overagain from 1 (it looks on futhure input like on new string)
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

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ] ; then
    echo "No input or output specified, use -o and -i with filenames."
    exit 1
fi



# Main Program
# ====================================================
echo -n "" > "${OUTPUT}"
while read -r SINGLELINE; do
   conv_text=$SINGLELINE
   last_step_text=""
    if [ $substituteFlag = true ] ; then
            last_step_text=$(echo "${conv_text}" | awk -v AWORD="${AWORD}" -v BWORD="${BWORD}" '{ gsub( AWORD, BWORD ); print}')
    fi
    conv_text=$(take_not_empty "$last_step_text" "$SINGLELINE")
    if [ $reverseFlag  = true ] ; then
      last_step_text=$(rev <<< "${conv_text}")
    fi
    conv_text=$(take_not_empty "$last_step_text" "$SINGLELINE")
    if [ $lowerFlag = true ] ; then
            last_step_text=$(echo "${conv_text}" | awk '{print tolower( $0 )}')
    fi
    conv_text=$(take_not_empty "$last_step_text" "$SINGLELINE")
    if [ $upperFlag = true ] ; then
            last_step_text=$(echo "${conv_text}" | awk '{print toupper( $0 )}')
    fi
    conv_text=$(take_not_empty "$last_step_text" "$SINGLELINE")
    if [ $flipCaseFlag = true ] ; then
    # problem with i in line on macos
      last_step_text=$(echo "${conv_text}" | awk '{
        split($0, line, "");
        for(i=1; i<=length($0); i++) {
            if(line[i] ~ /[a-z]/) printf("%c", toupper(line[i]));
            if(line[i] ~ /[A-Z]/) printf("%c", tolower(line[i]));
        };
        print ""
      }')
    fi
    conv_text=$(take_not_empty "$last_step_text" "$SINGLELINE")
    echo "${last_step_text}" >> "${OUTPUT}"
done < "${INPUT}"

