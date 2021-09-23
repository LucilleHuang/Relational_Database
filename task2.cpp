////////////////////////////////////////////////////////////////////////////////
//
// showDatabases.cpp: using C++ as a "better C" but no exception handling, RTTI
//
// Purpose: execute a query on information_schema to determine databases
//          with optional pattern matching on the database name
//          some data
//
// Usage: ./showDatabases [-l pattern]
//        ./showDatabases [-n pattern]
//
// Connects to MySQL database server machine "SERVER"
// with MySQL userid "USERID" and password "PASSWORD"
// The program prompts for a password using
// the obsolete system call getpass().  It isn't ideal but it's better than
// having it visible.
//
// -l and -n are optional parameters.  If -l is used, the program will take the
// subsequent string of characters as a pattern to match in the database name
// If -n is used, the program will take the subsequent string of characters as
// a pattern to reject in matching the database name
// The pattern is a standard SQL pattern: letters/numbers, and % as a wildcard
//
// History: v. 0.01: 11 January 2021: Initial Drop; PASW
//             0.02: 13 January 2021: Error handling; comments; PASW
//             0.1:  14 September 2021: Changed to do showDatabases
//
// Acknowledgements:
// MySQL Ref. Manual, especially
// https://dev.mysql.com/doc/c-api/8.0/en/c-api-functions.html
// Useful Sample MySQL/C code at http://zetcode.com/db/mysqlc/
// (but be cautious as it has memory errors in the code)
// (e.g., see mysql_stmt_init() usage compared to ref manual)
// 
// Deficiencies: numerous, including the use of the obsolete getpass()
// 

#include <mysql/mysql.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <iostream>

using namespace std;

int main(const int argc, const char* argv[]) {

// Defined parameters
// Recommend use of -p option instead of
// Hardcoding password here
//

  const char* USERID   = "j349huan";                      // Your UserID here
  const char* SERVER   = "marmoset02.shoshin.uwaterloo.ca";
  const char* DBNAME   = "";                                // Can specify a database; don't want to
  const char* QUERY    = "select schema_name from information_schema.schemata order by schema_name";
  
  MYSQL  mysql;                                             // Space for handler
  MYSQL* pMysql = &mysql;                                   // Pointer to handler
  
  const int bufLen = 256;

  MYSQL_RES* pQueryResult;                                  // Pointer to query result handler
  MYSQL_ROW  row;                                           // Space for result row
  int numFields;                                            // Number of fields in query

  // Check the command-line arguments first
  // Either 1 or 3:
  // 1 for all databases accessible to the account to be listed
  // 3 for a pattern match (either -l: database names must match the pattern
  //                            or -n: database names must NOT match the pattern
  // The pattern is in argv[2] if argc = 3
  
  if (argc != 1 && argc != 3) {
    cerr << argv[0] << ": Usage: " << argv[0] << " [-l/n pattern]" << endl;
    return -1;
  }
  if (argc == 3 &&
      ((strncmp("-n", argv[1], 2) != 0 ) &&
       (strncmp("-l", argv[1], 2) != 0 ))) {
    cerr << argv[0] << ": Usage: " << argv[0] << " [-l/n pattern]" << endl << "argv[1]: '" << argv[1] << "'" << endl;
    return -1;
  }

  // Validate argv[2] as containing only alphanumeric characters and %
  // We will be lazy and just do an ASCII check; NLS support should be better.
  // In particular, we want to prevent any SQL injection attacks
  if (argc == 3) {
    const char* pattern = argv[2];
    while (*pattern) {
      if (!( (*pattern >= 'A' && *pattern <= 'Z') ||
	     (*pattern >= 'a' && *pattern <= 'z') ||
	     (*pattern >= '0' && *pattern <= '9') ||
	     (*pattern == '%'))) {
	cerr << argv[0] << ": Usage Error: pattern must be of the form: '[A-Za-z0-9%]+'" << endl;
	return -1;
      }
      ++pattern;
    }
  }

  // Attempt DB connection
  // Get a handler first

  // Handy debugging statement to ensure I connected to the database
#ifdef DEBUG
  cout << "Attempting to connect to database '" << DBNAME
       << "' on server " << SERVER
       << " with MySQL userid " << USERID << endl;
#endif
  
  if (!mysql_init(pMysql)) {
    cerr << ": mysql_init() error: insufficient memory" << endl;
    return -1*ENOMEM;
  }
  
  // Prompt for a password and connect (use default port 3306)
  const char* passwd = getpass("Password: ");
  if (!mysql_real_connect(pMysql,
			  SERVER,
			  USERID,
			  passwd,
			  DBNAME,
			  0,                                // Use default port (3306)
			  NULL,                             // Not using unix socket or named pipe
			  0)) {                             // No client flags
    cerr << ": mysql_real_connect() error: " << mysql_error(pMysql) << endl;
    return -1;
  }

  // Now we need to do the query.  The specific query depends on the options or
  // lack of options.

  const char* baseQuery = "select schema_name from information_schema.schemata";
  const char* orderingClause = " order by schema_name;";

  // THE queryLen WILL NEED TO BE DIFFERENT THAN THAT SHOWN BELOW
  int queryLen = strlen(baseQuery) +
                 strlen(orderingClause) +
    1;                        // Needed for null terminator 
  
  // Allocate the query buffer
  char queryBuffer[queryLen];

  // Copy the query into the query buffer
  strcpy(queryBuffer, baseQuery);

  // YOUR CODE HERE TO DEAL WITH THE -l AND -n CASES
  
  strcpy(queryBuffer + strlen(queryBuffer), orderingClause);

  // Handy debugging statement to ensure I have a good query
#ifdef DEBUG
  cout << "Query is: " << queryBuffer << endl
       << "with length: " << strlen(queryBuffer) << " and queryLen = " << queryLen << endl;
#endif
  
  // Run the query
  int rc =  mysql_query(pMysql, queryBuffer);
  if (rc) {
    cerr << ": mysql_query() error: " << mysql_error(pMysql) << endl
	 << "rc: " << rc << endl;
    return -1;
  }

  // Fetch the results
  pQueryResult =  mysql_store_result(pMysql);
  numFields = mysql_field_count(pMysql);                     // And get the field count
  if (!pQueryResult) {                                       // We got nothing back; that may be OK
    cout << "!pQueryResult" << endl;
    if (numFields == 0) {                                    // We should have nothing back!
      cerr << argv[0] << ": Information: Query \"" << QUERY << "\" returned zero rows" << endl;
    }
    else {
      cerr << argv[0] << ": Error: Query \"" << QUERY << "\" failed to return expected data" << endl
	   << argv[0] << ": error information: " << mysql_error(pMysql) << endl;
       return -1;
    }
  }
  else {                                                    // Retrieve the rows
    cout << "Database";
    if (argc == 3) {
      if (strncmp("-n", argv[1], 2) == 0)
	cout << " (^" << argv[2] << ")";
      else
	cout << " (" << argv[2] << ")";
    }
    cout << endl << "--------------" << endl;
    while ((row = mysql_fetch_row(pQueryResult))) {
      unsigned long *lengths;
      lengths = mysql_fetch_lengths(pQueryResult);
      for (int i = 0; i < numFields; i++)
	printf("%.*s ", (int) lengths[i], row[i] ? row[i] : "NULL");
      printf("\n");
    }
    cout << "--------------" << endl;
  }
  mysql_free_result(pQueryResult);
  mysql_close(pMysql);

  return 0;
}
