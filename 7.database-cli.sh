#!/bin/bash
set -u
#
# Interface for controling relational database
# ---------------------------
# Data is stored as follows:  (CSV) 
# attr1;attr2;attr3;.....
# attr1;attr2;attr3;.....
# rec3; ...
# rec4; ...
#
# TO DO : script return error after execution - even if it looks like its working fine
# TO DO : what if command lacks arguments
#
#
# Supported operations:
# delete, add, select - data
# create, delete - table
# create - database 

# Variables
DATABASE="my_database"
TABLE=""

# Functions

create_database() {
    # Only user can delete this folder and operate on it
    if [ ! -e $1 ] ; then
        return `mkdir -m 1700 $1 2>/dev/null` 
    fi
    return 1
}

create_table() {
    if [ ! -e "./$1/$2.csv" ] ; then
        return `touch "./$1/$2.csv" 2>/dev/null && chmod 1700 "./$1/$2.csv" 2>/dev/null `
    fi
    return 1
}

create_attrib(){
    if [ -e "./$1/$2.csv" ] ; then
       return `echo -n "$3;" >> "./$1/$2.csv"`
    fi
    return 1
}

create_record(){
    # There is assumtion that there is a header in specified data
    N=$( head -n 1 "./$DATABASE/$TABLE.csv" | awk -F ";" '{ print NF-1 }') 
    if [[ "$N" -eq "$#" ]] ; then
        while [ "$#" -gt 0 ] ; do
            create_attrib $DATABASE $TABLE $1 
            shift 1
        done
        echo "" >> "./$DATABASE/$TABLE.csv"
        return 0
    else
        echo "Wrong number of attribute specified."
        echo "Specified: "$#", Required: $N" 
    fi
    return 1
}

select_all_records(){
    awk -F ";" '
    { 
        if (NR == 1 ){
            dash = sprintf("%0*s", 20*NF+1, "0")
            gsub(/0/, "-", dash );
            print dash
            printf "|%5s%-5.10s%3s|", " ", " ", " "
        } else {
            printf "|%5s%-5.10s%3s|", " ", NR-1, " "
        }
        for (i = 1; i < NF; i++) {
            printf "|%7s%-10.10s%3s|", " ", $i, " "
        }; 
        print ""
        dash = sprintf("%0*s", 20*NF+1, "0")
        gsub(/0/, "-", dash );
        print dash
       
    }' "./$DATABASE/$TABLE.csv"
}



# Input processing
while [ "$#" -gt 0 ] ; do 
    case "$2" in 
    data)
        case "$1" in 
        add)
            TABLE="$3"
            shift 3
            if [ -e "./$DATABASE/$TABLE.csv" ] ; then
                create_record "$@" && echo "Record successfully added" || echo "Error during record creation"
            else
                echo "Database not exists."
            fi
            ;;
        delete)
            ;;
        select)
                TABLE=$3
                select_all_records
            ;;
        *)
                echo "Wrong option: $1"
                exit 1
            ;;
        esac
        shift "$#"
        ;;
    table)
        case "$1" in 
        add)
            create_table $DATABASE $3 && echo "Table created" || echo "Table already exist or there is a folder with the same name."
            TABLE="$3"
            shift 3  
            if [ ! -s "./$DATABASE/$TABLE.csv" ] ; then
                while [ "$#" -gt 0 ] ; do
                    create_attrib $DATABASE $TABLE $1 && echo "Column added: $1" || echo "Table not exist or error during column creation"
                    shift 1
                done
                echo "" >> "./$DATABASE/$TABLE.csv"
            fi
            shift "$#"
            ;;
        delete)
            ;;
        *)
                echo "Wrong option: $1"
                exit 1
            ;;
        esac
        shift 1
        ;;
    database)
        case "$1" in 
        add)
             create_database "$3" && echo "Database created" || echo "Database already exists or file with same name."
             DATABASE="$3"
            shift 1
            ;;
        delete)
            ;;
        *)
                echo "Wrong option: $1"
                exit 1
            ;;
        esac
        shift 1
        ;;
    *)
            echo "Wrong option: $2"
            echo Commands should be inserted as follows:
            echo database-cli.sh [operation] [database/table/data] [value]
            exit 1
        ;;
    esac
    shift 1
done

# Main program

