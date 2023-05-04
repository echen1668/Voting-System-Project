To run the application, first run dropAll.sql just to be sure that nothing that is going to be created already exists, then run createAll.sql to create tables. 
After that, run loadAll.sql to fill in the new tables with data. loadAll.sql should also print out each table after inserting elements into them.
You then run queryAll.sql, A2code.sql, and A3code.sql to create the necessary functions.
After you run all the previously mentioned script files, you can run the Juypter Notebook. For A.4, you will have to run transaction.sql.
You must close the connection if you are done using the Juypter Notebook.
In the end, run dropAll.sql to delete all the tables and relvant objects.