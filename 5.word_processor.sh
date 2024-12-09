#!/bin/bash 
# Word processor
#
# Not checking if file exist
# Diffrent arguments to clear
#
# Example use:
# ./word_processor.sh -r -l -i message.txt -o converted.txt -s Hello "Good Morning"

set -e

# Variables
LFLAG=false
RFLAG=false
UFLAG=false
VFLAG=false
SFLAG=false

# Functions
check_if_empty () {
    if [[ -n $1 ]] ; then
        echo $1
    else
        echo $2
    fi
}


# Input processing
while getopts "rluvs:i:o:"  OPT ; do
    case "${OPT}" in
    i)
        INPUT=${OPTARG}
        if [ ! -f $INPUT ] ; then 
            echo Wrong input file: "${INPUT}"
            exit 1
        fi
    ;;
    o)
        OUTPUT=${OPTARG}
        if [ ! -f $OUTPUT ] ; then 
            echo Wrong output file: "${OUTPUT}"
            exit 1
        fi
    ;;
    r)
        RFLAG=true
    ;;
    l)
        LFLAG=true
        if [ $UFLAG = true ]  ; then
            UFLAG=false
            echo Lowercase is being used
        fi
    ;;
    u)
        UFLAG=true
        if [ $LFLAG = true ]; then
            LFLAG=false
            echo Uppercase is being used
        fi
    ;;
    v)
        VFLAG=true
    ;;
    s)
        SFLAG=true
        shift $[ $OPTIND - 1 ] # changing pointer on input - then there is known that 2 argument for s is $1
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
     ;;
    esac
done

# Main Program
echo -n "" > ${OUTPUT}
while read -r SINGLELINE; do
   CONV_TEXT=$SINGLELINE
   OUTPUT_TEXT=""
    if [ $SFLAG = true ] ; then
            OUTPUT_TEXT=`echo "${CONV_TEXT}" | awk -v AWORD="${AWORD}" -v BWORD="${BWORD}" '{ gsub( AWORD, BWORD ); print}'`
    fi
    CONV_TEXT=`check_if_empty "$OUTPUT_TEXT" "$SINGLELINE"`
    if [ $RFLAG  = true ] ; then
       #N={#SINGLELINE}
       N=`wc -c <<< "${CONV_TEXT}"`
       OUTPUT_TEXT=""
       for((i=$N-1;i>=0;i--)); do
            OUTPUT_TEXT="$OUTPUT_TEXT${CONV_TEXT:$i:1}"
        done
    fi
    CONV_TEXT=`check_if_empty "$OUTPUT_TEXT" "$SINGLELINE"`
    if [ $LFLAG = true ] ; then
            OUTPUT_TEXT=`echo "${CONV_TEXT}" | awk '{print tolower( $0 )}'`
    fi
    CONV_TEXT=`check_if_empty "$OUTPUT_TEXT" "$SINGLELINE"`
    if [ $UFLAG = true ] ; then
            OUTPUT_TEXT=`echo "${CONV_TEXT}" | awk '{print toupper( $0 )}'`
    fi
    CONV_TEXT=`check_if_empty "$OUTPUT_TEXT" "$SINGLELINE"`
    if [ $VFLAG = true ] ; then
       N=`wc -c <<< "${CONV_TEXT}"`
       OUTPUT_TEXT=""
       for i in `seq 0 $N`; do
            CH=${CONV_TEXT:$i:1}
            case $CH in
            [[:lower:]])
                CH=`echo ${CH} | awk '{print toupper($0) }'`
                ;;
            [[:upper:]])
                CH=`echo ${CH} | awk '{print tolower($0) }'`
                ;;
            esac
            OUTPUT_TEXT="${OUTPUT_TEXT}${CH}" 
       done
    fi
    CONV_TEXT=`check_if_empty "$OUTPUT_TEXT" "$SINGLELINE"`
    echo ${OUTPUT_TEXT} >> ${OUTPUT}
done <${INPUT}

