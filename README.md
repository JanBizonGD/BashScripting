# BashScripting
## Description
Practical tasks from Grid Dynamics internal course : "5. Scripting basics: Bash". 

## Structure
Executable bash scripts are numbered from 1 to 7 in order of apperance in practical task. Files like *message.txt*, *cipher.txt*, *converted.txt* contains example inputand output data for task 4. and 5. (It is intendet to use them during execution of that scripts). Folders inside this folders are forbidden because folders are interpreted as a database in exercise 7..
Inside DOC.md there is a documentation describing usage of script and functions of database-cli.sh .
dataabsh-test.sh constains test for database-cli.sh

## Install
To download and unzip this directory:
`git clone [link to repository]`
Inside folder:
`chmod u+x *.sh`

## Examples
1. `fibbonacci.sh 1` 
    - *input:*
    first argument should be >0
    - *output:*
    N-th number of fibbonacci series.
2. `/calcualtor.sh -o + -n "3 5 4" -d`
    `./calcualtor.sh -n "3 5 4" -o \* -d`
    - *input:*
    * -d should be last for proper printing of other variables
    * numbers after -n should be surrouded with quotes 
    * supported operations: + - /* %
    - *output:*
    * returns result of performing specified operation on every number 
    * -d returns additional information about current operation and others
3.  `counter.sh`
    - *input:*
    no input
    - *output:*
    returns 100 lines with there number and if that number is divided by 3 or 5 it is replaced by Fizz or Buzz or both.
4. `./4.caesar_cipher.sh  -i message.txt -o cipher.txt -s 5`
    - *input:*
    * if input string contains spaces they are replaced with '-'
    * message.txt contains sample input data for that script
    * -v returns values for inserted options (input, output, shift)
    * possible flags: -i -o -s -v --suppress
    * suppress - result is saved only to file
    - *output:*
    * returns string after performing cipher on it.
5. `./word_processor.sh -r -l -i message.txt -o converted.txt -s Hello "Good Morning"`
    - *input:*
    * there is possiblity to choose only one of: upper or lower case. Option that apperes later is used.
    * changing lower to upper and upper to lower can be used despite using l or r earlier.
    * program operates only of input and output files (not strings from console).
    * there is possibility to operate on characters - reversing it and substitution text
    - *output:*
    * returns text after seriese of modifications returned to file.
6.  `report.sh`
    - *input:*
    no input
    - *output:*
    * returns information about system like: timestamp, username, internal ip, external ip, hostname, version, uptime, used/free space, total/free ram space, number/ freq of cpus.
    * this commands works only on linux devices (MAC not supported)
7. Is described inside DOC.md

## Notes
- Every script was made by Jan Bizon
