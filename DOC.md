# Database CLI

## Description 
This is documentation for `database-cli.sh`. Database-cli is command line tool for creating database, tables and inserting, deleting and displaying data from it.

## Examples
1. `database-cli.sh add database my_database`
2. `database-cli.sh config database `
3. `database-cli.sh add table my_table id name location`
4. `database-cli.sh config database `
5. `database-cli.sh add data 1 Asia Krakow`
6. `database-cli.sh add data 2 Kasia Warszawa`
7. `database-cli.sh add data 3 Ola Wroclaw`
8. `database-cli.sh add data 4 Weronika Rzeszow`
9. `database-cli.sh add data 5 Ania Lodz`
10. `database-cli.sh select data `
11. `database-cli.sh delete data "id=3"`
12. `database-cli.sh select data `
13. `database-cli.sh delete data "location=Krakow"`
14. `database-cli.sh select data `
15. `database-cli.sh delete table my_table`
16. `database-cli.sh delete database my_database`

## Testing
There is file called `database-tests.sh` that contains tests for database. Executing command like so: `database-tests.sh yes` automaticly answer yes to all questions during file deletion.

## Main concepts
Inside config file there is configuration pointing to current database and current tale. Thanks to `database-cli.sh config database` there is possibility to display current configuration and also to change it manually with `database-cli.sh update databse`. During creation of database and table this location is changed automaticlly. Configuration file is stored inside */tmp/database-config/config.conf*.

Databases are described via folders and tables via particular files. Files have got .csv extention and they are described it such manner  (delimited with ;). (It is not described according to requirements from execise). There is no line and record limitations related to text size.

## Functions

* **create_database()** - creates database ( folder ) and changes its mode - only usr can perform operations on it (including deletion).
* **create_table()** - creates table (new file) and changes its mode - only user can perform operations on it (including deletion).
* **create_attrib()** - adds new addribute for record (eventually new attrib header). 
* **create_record()** - iterates over all input passed to it and for each of them performs insertion. Correctness of records if checked by compering table header size with amount of data inserted. It is not possible to write new data if header is not present.
* **select_all_records()** - prints all records from table.
* **delete_data()** - deletes single record from database based on first occurence of true statement of inserted filter rule. Only compering is supported.
* **create_config()** - creates new config file inside previously defined location
* **load_config()** - loads config before any previous execution
* **update_config()** - updates config file after performing changes on database
* **show_config()** - shows config loaded
* **show_databases()** - shows all databases ( all folders inside current folder )
* **show_tables()** - shows all tables ( all files inside folder s inside current folder )

## Notes
* Table without header is broken.
* Everything was made by Jan Bizon
