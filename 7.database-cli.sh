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

create_column(){
    if [ -e "./$1/$2.csv" ] ; then
       return `echo -n "$3;" >> "./$1/$2.csv"`
    fi
    return 1
}


# Input processing
while [ "$#" -gt 0 ] ; do 
    case "$2" in 
    data)
        case "$1" in 
        add)
            ;;
        delete)
            ;;
        select)
            ;;
        *)
                echo "Wrong option: $1"
                exit 1
            ;;
        esac
        shift 1
        ;;
    table)
        case "$1" in 
        add)
            create_table $DATABASE $3 && echo "Table created" || echo "Table already exist or there is a folder with the same name."
            TABLE="$3"
            shift 3  
            if [ ! -s "./$DATABASE/$TABLE.csv" ] ; then
                while [ "$#" -gt 0 ] ; do
                    create_column $DATABASE $TABLE $1 && echo "Column added: $1" || echo "Table not exist or error during column creation"
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

