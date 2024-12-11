#!/bin/bash 
# Script to cipher wiht caesar cipher.
#
# There are no spaces - spaces are changed into -
#
set -u

# Variables
ALPH_SIZE=58                    # A-z
OPTSTRING="i:o:s:v-:"
MINCHAR=65                         # eq A in ASCII
Z=90                             # Number in ASCII
a=97
z=122
SUPPRESS=false

# Input processing
while getopts ${OPTSTRING} opt; do
    case "${opt}" in
    -)
        case "${OPTARG}" in
            suppress)
                SUPPRESS=true
                #OPTIND=$(( OPTIND + 1 ))
                echo Output is suppressed
                ;;
        esac
        ;;
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
    s)
        SHIFT=${OPTARG}
        if [ $SHIFT -le 0 ] ; then
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
    ;; 
    esac
done

# Main program
echo -n ""  > ${OUTPUT}
shopt -s extglob                            # Turn on globbing for case
while read -r SINGLELINE; do 
    # N=`expr "${SINGLELINE}" : '.*'`       # expr is problematic
    N=`wc -c <<< "${SINGLELINE}"`
    SINGLELINE=`tr ' ' '-' <<< "${SINGLELINE}"`
    #ARR=(`fold -w 1 <<< ${SINGLELINE}`)
    ARR=(`grep -o . <<< "${SINGLELINE}"`)
    for i in ${ARR[@]}; do
        if [[ $i == [[:alpha:]] ]] ; then
            TOCHAR=`printf '%d' "'$i"`
            # Linear space cut off
            CIPH=$(( ( ( ${TOCHAR} - ${MINCHAR} + ${SHIFT} ) % ${ALPH_SIZE} ) + ${MINCHAR} ))

            # Reinterpret characters over legal limitations
            if [ $CIPH -gt $Z ]  && [ $CIPH -lt $a ]; then
                CIPH=$(( ( ${CIPH} % $(($Z + 1)) + $a ) ))
            fi
            if [ $CIPH -gt $z ] ; then
                CIPH=$(( ( ${CIPH} % $z ) + ${MINCHAR} ))
            fi

            if [ $SUPPRESS = false ] ; then
                printf "\x`printf %x ${CIPH}`" | tee -a "${OUTPUT}"
            else
                printf "\x`printf %x ${CIPH}`" >> ${OUTPUT} 
            fi
        else 
            if [ $SUPPRESS = false ] ; then
                printf %c $i | tee -a "${OUTPUT}"
            else
                printf %c $i >> ${OUTPUT}
            fi
        fi
    done
    if [ $SUPPRESS = false ] ; then
        printf '\n' | tee -a "${OUTPUT}"
    else
        printf '\n' >> ${OUTPUT}
    fi
done <${INPUT}

