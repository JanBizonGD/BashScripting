#!/bin/bash
# Automated tests for database 

# Variables
CLI_NAME="7.database-cli.sh"
FOLDER="./"

RUN="${FOLDER}${CLI_NAME}"

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
${RUN} delete table my_table
${RUN} delete database my_database
echo --------------------------------------------------

echo ---------------- Tests ENDED ---------------------
