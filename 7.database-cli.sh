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
# TO DO : attrib and line doesnt conform to requirements
#
#
# Supported operations:
# delete, add, select - data
# create, delete - table
# create - database 

# Variables
CONFIG="/tmp/database-config/config.conf"
DATABASE=""
TABLE=""
SEP=";"

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
       return `echo -n "$3${SEP}" >> "./$1/$2.csv"`
    fi
    return 1
}

create_record(){
    # There is assumtion that there is a header in specified data
    N=$( head -n 1 "./$DATABASE/$TABLE.csv" | awk -F "${SEP}" '{ print NF-1 }') 
    if [[ "$N" -ge 0 ]] ; then 
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
    fi
    return 1
}

select_all_records(){
    awk -F "${SEP}" '
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

delete_data(){
    COL=`echo $1 | cut -f1 -d'='`
    VAL=`echo $1 | cut -f2 -d'='`
    COL_ID=`head -n 1 "./$DATABASE/$TABLE.csv" | 
    awk -F "${SEP}" -v COL=$COL -v VAL=$VAL '{
        for (i=1; i<NF; i++){
            if ($i == COL){
                print i
            }
        }
    }' "./$DATABASE/$TABLE.csv" `
    LINE=`awk -F "${SEP}" -v COL_ID=$COL_ID -v VAL=$VAL '{
        for (i=1; i<NF; i++){
            if( i==COL_ID && $i==VAL) {
                print NR
                exit
            }
        }
    }' "./$DATABASE/$TABLE.csv" `
    if [[ -z $LINE ]] ; then
        return 1
    fi
    if [ -e "./$DATABASE/$TABLE.csv" ] ; then
        return `sed -i '' -e "${LINE} d" "./$DATABASE/$TABLE.csv" ` 
    else
        echo "Delete: File not found."
        return 1
    fi
    return 0
}

create_config(){
    if [ ! -e "$CONFIG" 2>/dev/null ] ; then
    # TO DO: Variable path
        mkdir -m 1700 -p /tmp/database-config && \
            touch "$CONFIG" && \
                chmod 1700 "$CONFIG"
    fi
    echo "DATABASE=" >> "$CONFIG"
    echo "TABLE=" >> "$CONFIG"
}

load_config(){
    if [ -e "$CONFIG" 2>/dev/null ] ; then
        DATABASE=`grep -e DATABASE "$CONFIG" | cut -f2 -d"="`
        TABLE=`grep -e TABLE "$CONFIG" | cut -f2 -d"="`
        return 0
    fi
    return 1
}

update_config(){
    if [ -e "$CONFIG" 2>/dev/null ] ; then
        sed -i '' -E "s/DATABASE=.*/DATABASE=${1}/" "$CONFIG"
        sed -i '' -E "s/TABLE=.*/TABLE=${2}/" "$CONFIG"
        load_config
        return 0
    fi
    return 1
}

show_config(){
    echo "* Database: $DATABASE"
    echo "* Table: $TABLE"
}

show_databases(){
    ls -l -p | awk '{print $9}' | grep /  2>/dev/null
}

show_tables(){
    ls -p -l "./$1/" | cut -f11 -d" " | grep -v / 2>/dev/null 
}



# Main program
load_config || \
create_config | echo "Choose database and table to operate on."
while [ "$#" -gt 0 ] ; do 
    if [[ $# -lt 2 ]] ; then
        echo "Operation failed. Arguments specified: $#, Required at least 2."
        exit 1
    fi
    case "$2" in 
    data)
        case "$1" in 
        add)
            shift 2
            if [ -e "./$DATABASE/$TABLE.csv" ] ; then
                create_record "$@" && \
                    echo "Record successfully added" ||\
                    echo "Error during record creation. Table is broken - needs rebuild."
            else
                echo "Database not exists."
            fi
            ;;
        delete)
            if [[ $# -lt 3 ]] ; then 
                echo "Deletion not successfull. Rule for deletion required."
                exit 1
            fi
            delete_data $3 &&\
                echo "Deletion successfull" ||\
                echo "Deletion failed"
            ;;
        select)
                select_all_records ||\
                    echo "Error during data selection."
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
            if [[ $# -lt 3 ]] ; then 
                echo "Addition not successfull. Table not provided."
                exit 1
            fi
            create_table $DATABASE $3 && \
                echo "Table created" || \
                echo "Table already exist or there is a folder with the same name."&&\
            update_config $DATABASE $3
            shift 3  
            if [ ! -s "./$DATABASE/$TABLE.csv" ] ; then
                while [ "$#" -gt 0 ] ; do
                    create_attrib $DATABASE $TABLE $1 && \
                        echo "Column added: $1" || \
                        echo "Table not exist or error during column creation"
                    shift 1
                done
                echo "" >> "./$DATABASE/$TABLE.csv"
            fi
            shift "$#"
            ;;
        delete)
            if [[ $# -lt 3 ]] ; then
                echo "Deletion not successfull. Table not provided"
                exit 1
            fi
            TABLE=$3
            rm -i "./$DATABASE/$TABLE.csv" && \
                echo "Table $TABLE deleted sucessfully" ||\
                echo "Error during deletion"
            update_config $DATABASE ""
            shift 3
            ;;
        update)
            update_config $DATABASE $3 &&\
                echo "Table changed to: $3" ||\
                echo "Error during switching table"
            shift 1
        ;;
        select)
            show_tables "${DATABASE}" ||\
                echo "Error during tables listing."
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
            if [[ $# -lt 3 ]] ; then
                echo "Addition not successfull. Database not provided"
                exit 1
            fi
             create_database "$3" &&\
                 echo "Database created" ||\
                 echo "Database already exists or file with same name." &&\
             update_config "$3" ""
            shift 1
            ;;
        delete)
            if [[ $# -lt 3 ]] ; then
                echo "Deletion not successfull. Database not provided"
                exit 1
            fi
            DATABASE=$3
            rm -rfi "./$DATABASE" &&\
                echo "Database $DATABASE deleted sucessfully" ||\
                echo "Error during deletion" &&\
            update_config "" ""
            shift 3
            ;;
        update)
             update_config "$3" "" &&\
                 echo "Database switched to: $3" ||\
                 echo "Error during switching database"
            shift 1
            ;;
        config)
            show_config ||\
                echo "Error during database config display"
            ;;
        select)
            show_databases ||\
                echo "Error during database listing"
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

exit 0

