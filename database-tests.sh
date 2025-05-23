#!/bin/bash 
# Automated tests for database 

# Variables
CLI_NAME="7.database-cli.sh"
FOLDER="./"

RUN="${FOLDER}${CLI_NAME}"
YES="$1"

# Tests

echo ---------------- Tests STARTED -------------------

# Default test
echo ---------------- Test 1 --------------------------
${RUN} add database my_database
${RUN} config database 
${RUN} add table my_table id name location
${RUN} config database 
${RUN} add data 1 Asia Krakow
${RUN} add data 2 Kasia Warszawa
${RUN} add data 3 Ola Wroclaw
${RUN} add data 4 Weronika Rzeszow
${RUN} add data 5 Ania Lodz
${RUN} select data 
${RUN} delete data "id=3"
${RUN} select data 
${RUN} delete data "location=Krakow"
${RUN} select data 
if [[ -n "$YES" ]] ; then 
    ${YES} | ${RUN} delete table my_table
    ${YES} | ${RUN} delete database my_database
else
    ${RUN} delete table my_table
    ${RUN} delete database my_database
fi
echo --------------------------------------------------

# Print tables and databases
echo ---------------- Test 2 --------------------------
${RUN} add database my_database
${RUN} config database 
${RUN} add table my_table id name location
${RUN} config database 
${RUN} add data 1 Asia Krakow
${RUN} add data 2 Kasia Warszawa
${RUN} add data 3 Ola Wroclaw
${RUN} add data 4 Weronika Rzeszow
${RUN} add data 5 Ania Lodz
${RUN} select data 
${RUN} select table 
${RUN} select database 
if [[ -n "$YES" ]] ; then 
    ${YES} | ${RUN} delete table my_table
    ${YES} | ${RUN} delete database my_database
else
    ${RUN} delete table my_table
    ${RUN} delete database my_database
fi
echo --------------------------------------------------

# When database or table exists
echo ---------------- Test 3 --------------------------
${RUN} add database my_database
${RUN} add database my_database
${RUN} config database 
${RUN} add table my_table 
${RUN} add table my_table id name location
${RUN} config database 
${RUN} add data 1 Asia Krakow
${RUN} add data 2 Kasia Warszawa
${RUN} add data 3 Ola Wroclaw
${RUN} add data 4 Weronika Rzeszow
${RUN} add data 5 Ania Lodz
${RUN} select data 
${RUN} select table 
${RUN} select database 
if [[ -n "$YES" ]] ; then 
    ${YES} | ${RUN} delete table my_table
    ${YES} | ${RUN} delete database my_database
else
    ${RUN} delete table my_table
    ${RUN} delete database my_database
fi
echo --------------------------------------------------

# Lacking arguments
echo ---------------- Test 4 --------------------------
${RUN} add database 
${RUN} config database 
${RUN} add table  
${RUN} config database 
${RUN} add data 1 Asia Krakow
${RUN} add data 2 Kasia Warszawa
${RUN} add data 3 Ola Wroclaw
${RUN} add data 4 Weronika Rzeszow
${RUN} add data 5 Ania Lodz
${RUN} select  
${RUN} select  
${RUN} select  
if [[ -n "$YES" ]] ; then 
    ${YES} | ${RUN} delete table 
    ${YES} | ${RUN} delete database 
else
    ${RUN} delete table 
    ${RUN} delete database 
fi
echo --------------------------------------------------
#

echo ---------------- Tests ENDED ---------------------

exit 0
