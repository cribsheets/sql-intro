# Cribsheets: Intro to SQL

At some point, you'll be working with data stored in a relational format.
Likely, this data will be accessed via SQL (Structured Query Language). _You_
may not be accessing it, as there are plenty of Object Relational Mapping (ORM)
libraries to facilitate this access in whatever language, but it is incredibly
useful to understand what's going on under the surface.

To that effect, we present this short introduction to SQL, a small data set, and
a framework to practice some basic skills. We won't even begin to pretend this
is a comprehensive guide, but it exists to get your toes wet in the SQL world,
and to give you a sense of how it works and what it's used for.

# About SQL

The Structured Query Language (SQL) is a language for interacting with
relationally structured data. The data in question is _structured_ into a
well-defined _schema_ (description) when the database is defined. Each datum can
_relate_ to other data in the database via relationships either defined in the
schema, or as a result of a query or update.

SQL provides tools for interacting with that data. Using SQL, you can select and
search for information, update information that already exists, insert new data
into the database, and delete data. There's quite a bit to SQL, and we're just
going to scratch the surface. Hopefully that will be enough to get you
interested enough to study further.

SQL has two fundamental structures: a single row of data or  _record_, and a list of
records or _table_. Most interactions with SQL will return results in a tabular
format.

If you've used a spreadsheet program, there are surface similarities between
SQL's table/record structure and a spreadsheet's sheet/row structure. This is
okay to use as a model for initial understanding, but don't get _too_ attached
to that model.

While the core features of the SQL language are uniform across relational database
management systems (RDBMS), it's worth noting that as you approach the edges of
the core language, different databases may use slightly different SQL dialects.
Don't worry too much about this right now, but when you begin work in a
database, be sure and look through it's SQL notes for deviation from what you
expect.

# SQLite

To keep the overhead for these exercises as small as possible, we'll be using
SQLite as our database engine. SQLite is a small, fast and relational SQL
database (db) engine. It's great for prototyping, embedded applications, and
doesn't require additional services to run on your machine to use.

## Setting Up

To install SQLite:

~~~bash
# mac os x
> brew install sqlite3

# ubuntu / debian
> sudo apt-get install sqlite3 libsqlite3-dev

# centos / rhel
> sudo yum install sqlite
~~~

To check whether or not your installation was successful, you can ask SQLite for
its version:

~~~bash
> sqlite3 --version
3.24.0 2018-06-04 14:10:15 95fbac39baaab1c3a84fdfc82ccb7f42398b2e92f18a2a57bce1d4a713cbaapl
~~~

## Getting Around in SQLite

Before we get into SQL proper, let's talk for a second about the db program
itself. You'll need to be able to start it, load a db, execute commands, and
quit the program. It's also useful to be able to describe a schema.

Each db will have a command line interface (CLI) available, though their
particulars vary. MySQL, PostgreSQL and there rest each have their own CLI
flavor, but the SQL they use will be (mostly) identical. With that in mind,
let's focus on the particulars of SQlite.

To start `sqlite3`, you simply type its name at the command line in your
terminal. This begin an interactive session via program's CLI, where you can
execute SQL commands directly. This is the primary interface we'll be using in
these exercises. In this CLI, non-SQL commands are preceded by a period (`.`).

To get help, type `.help`. You'll use this one quite a bit. To exit the program,
type `.q`.

It's also useful when using SQLite to have the headers for the columns print
with each request. You can ensure this happens by setting `.headers on`.

You can load data in two ways:

To load a db file (such as `dbfile.db`) when you start the CLI, include the
filename on the command line:

~~~bash
> sqlite3 dbfile.db
~~~

From inside the CLI, you can load a file as the main database by providing its path:

~~~bash
sqlite> .restore dbfile.db
~~~

If you want to restore a file as a named database, you can give the name when
restoring. This won't be important for our purposes, but it might be handy to
know.

~~~bash
sqlite> .restore myname dbfile.db
~~~

Finally, if you want to take a snapshot of the database as it currently exists
in memory, you'd (predictably) use `.save`:

~~~bash
sqlite> .save dbfile-snapshot.db
~~~

# SQL Basics

## First Steps

Let's start with hello. Open sqlite3 and type in `select 'hello!';`:

~~~bash
> sqlite3
SQLite version [stuff]
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite> select 'hello!';
hello!
~~~

You've executed your first SQL statement! Note the parts: we begin with a
`select`, since we're selecting values. We've told the engine what to
select---in this case, the string 'hello!', surrounded by single quotes (`'`).
The statement is terminated with a semicolon (`;`). The semicolon is important,
as SQL can span multiple lines quite happily, and the engine needs to know when
to start processing.

Try a few more things:

* add: `select 2 + 5;`
* subtract: `select 5 - 2;`
* multiply: `select 6 * 8;`
* divide: `select 8 / 2;`
* integer division: `select 9 / 2;`
* floating point division: `select 9 / 2.0;`
* modulo: `select 9 % 2';`
* oops? `select '2 + 5';`

SQL includes some mathematical operators, and is aware of the difference between
a integer and a floating point number. Note that every SQL statement ends with a
semicolon, and that the single quote (`'`) always denotes a string literal.

SQL also includes logical operators. Let's try some:

* test for equality (yes is 1): `select 2 = 2;`
* test for equality (no is 0): `select 2 = 3;`
* test less-than or equal: `select 2 <= 3;`
* test greater-than: `select 2 > 3;`
* test for inequality: `select 12 <> 13;`

As you can see, SQL represents a 'false' as 0, and a 'true' as 1. At the moment,
we're simply using these operators with a `select` statement to get some
familiarity with how SQL works (and to practice adding a semicolon to
_everything_).

We can also use logical operators to chain together tests:

* logical and: `select (1 < 3) and (3 < 5);`
* logical not: `select not (3<>3);`
* between values: `select 3 between 1 and 5;`
* `select 3 between 4 and 5;`
* found in list/set: `select 3 in (1,2,3,4,5);`
* `select '3' in (1,2,3,4,5);`
* with strings: `select 'Monster' in ('Monster', 'Mina', 'Fluffy', 'Spot');`

Finally, we can do some matching:

* `select 'Monster' like 'm%';`
* `select 'Fluffy' like 'm%';`

These are the tools in SQL we'll have available to make decisions and
calculations about data stored in the db, but by themselves, they're not very
exciting. So let's load up some data and query.

## Selecting Data

Selecting data retrieves it from the database using the `select` statement. In
general, `select` will be the statement you use the most, so let's start with
that one.

A `select` statement (or query) has the following general format:

`select <fields,data> from <somewhere> where <some condition> <options>;`

We can think of this as being broken up into clauses:

* select clause: `select <something>`
* from clause: `from <somewhere>`
* where clause: `where <some condition(s) is (are) true>`
* options clauses
* don't forget the semicolon!

The select clause is required (and the semicolon) however everything else is
optional.

The select clause tells the db what we want to receive from the data we're
querying. This can include literals (3, 'Monster'), the results of operations
(5 / 2.0), but more commonly it is a list of fields in the data we're querying.
If we were querying a list of employees, we might only want the name returned,
as in `select first_name, last_name from employees;`

The from clause tells the db where to look. This can be a single table, or it
can be more than one table joined in some fashion into a temporary structure.
The from clause can get complex. We'll start with a single table and move on
from there.

The where clause sets conditions on the data we care about, using the logical
statements we played with above. For example: 

`select name, color from pets where color='black' and species='cat';` or<br/>
`select name, calories, price from menu where calories < 800 and price < 15.00;`

Finally, the options clause can contain a variety of constraints and modifiers
to fiddle with the data before it's presented to us. Two examples are `limit`,
which tells the db the maximum number of records to return, and `order by`,
which can sort the data before we see it.

Got it? Okay, let's get cracking.

### Load 'employees.db'

We've provided a database with some employee data, courtesy of
Kaggle's [Human Resources Data
Set](https://www.kaggle.com/rhuebner/human-resources-data-set/home). Let's
load that into SQLite. From the project directory (where this README is), run:

~~~bash
> sqlite3 employees.db
~~~

### Explore the Data

Now let's poke around. The first thing you'll want to do when opening a new data
set is to check out its structure. Remember that `.help` exists, and let's see
what databases are present.

In the SQLite CLI, type `.databases`. You should see a result like this:

~~~bash
sqlite> .databases
main: /path/to/project/employees.db
~~~

Now we can look at the available tables, using `.tables`:

~~~bash
sqlite> .tables
employees
~~~

We can take a look at the structure of the `employees` table using `.schema`:

~~~
sqlite> .schema employees
CREATE TABLE employees (
    name TEXT, first_name TEXT, last_name TEXT, empno TEXT, state TEXT,
    zip TEXT, dob DATE, age INTEGER, sex TEXT, marital_status TEXT,
    citizenship TEXT, hire_date DATE, termination_date DATE, term_reason TEXT, status TEXT,
    department TEXT, position TEXT, hourly_rate FLOAT, manager TEXT, source TEXT,
    performance_score TEXT
  );
~~~

This is the `CREATE` statement used to build the table. As before, a _table_ is
one of the two fundamental structures in SQL, along with a _record_. A record is
composed of a number of _fields_ or _columns_ (used interchangeably).
Each field has a _datatype_.

In this table, most columns are TEXT, but a few are DATEs, with
an INTEGER and FLOAT thrown in for variety. Now that we know what fields are
available, let's start looking at the data itself.

### Counting Things

The first thing we want to know is how many records are in the table. This gives
us a sense of scale. This is very small data set, but future data you encounter
could be quite large. We can count the number of records using `select` and
`count()`:

~~~
sqlite> select count() from employees;
count()
301
~~~

Here we're using `select`, and asking SQL to count the records in
the employees table. Since we didn't use a `where` clause, it will count
all of the rows. By adding a where clause, we can get more specific counts:

~~~
sqlite> select count() from employees where state = 'CT';
count()
6
sqlite> select count() from employees where state = 'TX';
count()
3
~~~

We could do this for every state, but it's also possible to see everything
at once. To group things together, we use `group by` in the options clause.

### Grouping Things

The `count()` function can be combined with the `group by`
options to get a count by state for all states:

~~~
sqlite> select count(), state from employees group by state;
count()|state
1|AL
1|AZ
1|CA
1|CO
6|CT
...
~~~

We selected count() and state, otherwise we'd just see the counts by state
without knowing which state the count referred to.  When we group a query,
we're instructing the db to partition the data a certain way.

The `count()` function isn't the only function we can use in a query:

~~~
sqlite> select state, max(hourly_rate), min(hourly_rate), avg(hourly_rate)
   ...> from employees
   ...> group by state;
state|max(hourly_rate)|min(hourly_rate)|avg(hourly_rate)
AL|55.0|55.0|55.0
AZ|55.0|55.0|55.0
CA|55.0|55.0|55.0
CO|55.0|55.0|55.0
CT|58.2|26.0|46.2833333333333
FL|57.0|57.0|57.0
...
~~~

Because this query was getting a little long, we broke it up over multiple
lines. Until you add the semicolon, you're still composing your query. In
practice, a complex query can be hundreds of lines long.

### Selecting Data By Column

Using the included functions is useful, but sometimes you just want data by
itself. Let's see the names of the employees in CT, and their rates of pay.

~~~
sqlite> select first_name, last_name, hourly_rate
   ...> from employees
   ...> where state = 'CT';
first_name|last_name|hourly_rate
Lisa|Galia|31.4
Leonara|Lindsay|26.0
Donald|Favis|58.2
Ann|Daniele|54.1
Joe|South|53.0
Maruk|Fraval|55.0
~~~

In this case, we're looking for three specific column values for records in the
`employees` table, if and only if the `state` column is 'CT'. If we only wanted
employees in Connecticut whose hourly rate was above $50/hour, we could specify
that:

~~~
sqlite> select first_name, last_name, hourly_rate
   ...> from employees
   ...> where state = 'CT' and hourly_rate > 50.0;
first_name|last_name|hourly_rate
Donald|Favis|58.2
Ann|Daniele|54.1
Joe|South|53.0
Maruk|Fraval|55.0
~~~

### Sorting Results

In addition to selecting particular fields and deciding on which records using
`where`, we can also order the results we get back by a column or columns. We do
this with the `order by` directive in the options clause.  First, let's order it
by last name, alphabetically:

~~~
sqlite> select first_name, last_name, hourly_rate
   ...> from employees
   ...> where state = 'CT' and hourly_rate > 50.0
   ...> order by last_name;
first_name|last_name|hourly_rate
Ann|Daniele|54.1
Donald|Favis|58.2
Maruk|Fraval|55.0
Joe|South|53.0
~~~

The `order by` clause instructs SQL to return the result set sorted. The default
is 'ascending' order, but we can also specify descending order:

~~~
sqlite> select first_name, last_name, hourly_rate
   ...> from employees
   ...> where state = 'CT' and hourly_rate > 50.0
   ...> order by last_name desc;
first_name|last_name|hourly_rate
Joe|South|53.0
Maruk|Fraval|55.0
Donald|Favis|58.2
Ann|Daniele|54.1
~~~

### Limiting the Result Set and Skipping Results

Limiting the size of the result set to a set number is also possible, and
sometimes useful. Let's suppose we want to find the three highest paid people
in the table:

~~~
sqlite> select first_name, last_name, hourly_rate
   ...> from employees
   ...> order by hourly_rate desc
   ...> limit 3;
first_name|last_name|hourly_rate
Janet|King|80.0
Jennifer|Zamora|65.0
Jason|Foss|65.0
~~~

By specifying a limit, we can control how many records we see. We can also
specify an `offset`, telling SQL to skip a certain number of records when
returning results. In the last query, we got the three highest paid people in
the `employees` table. If we wanted the _next_ three, we'd do something like
this:

~~~
sqlite> select first_name, last_name, hourly_rate
   ...> from employees
   ...> order by hourly_rate desc
   ...> limit 3 offset 3;
first_name|last_name|hourly_rate
Eric|Dougall|64.0
Peter|Monroe|63.0
Simon|Roup|62.0
~~~

We'd use something like this if we were displaying a set of results one
page at a time, with say 20 entries per page. The first page would be
limit 10 offset (0 * 10), the second page limit 10 offset (1 * 10), and
so on. It's straightforward to see how you might write a program to extract data
a page at a time, given `order by`, `limit`, and `offset`.

One last thing we can do with select that's very useful is to find only unique
entries in the data. Let's review the schema of the employees table:

~~~sql
sqlite> .schema employees
CREATE TABLE employees (
    name TEXT, first_name TEXT, last_name TEXT, empno TEXT, state TEXT,
    zip TEXT, dob DATE, age INTEGER, sex TEXT, marital_status TEXT,
    citizenship TEXT, hire_date DATE, termination_date DATE, term_reason TEXT,
status TEXT,
    department TEXT, position TEXT, hourly_rate FLOAT, manager TEXT, source
TEXT,
    performance_score TEXT
  );
~~~

Each record in the table applies to a particular employee, however there are
some columns that are likely duplicate data. For instance, 'status' is very
likely one of a few options, rather than custom text for each employees.
Similarly, 'department', 'manager', 'position', and 'citizenship' likely have a
handful of data entries across all employees, rather than a unique entry for
each employee.

We can check this by asking sql to return values that are unique, or `distinct`.
Let's find all the possible employee statuses in the the current data set. We'll
use `select distinct status` to indicate that we only want to see each entry
once:

~~~
sqlite> select distinct status from employees;
Active
Voluntarily Terminated
Terminated for Cause
Leave of Absence
Future Start
~~~

So, out of 301 records, there are only five distinct statuses that apply to
employees. Experienced developers will recognize this as a problem, caused
by importing data into this database from a merged csv; we _could_ extract
these status fields into another table to dry up our data, but that's
another show.

-----------
















* All employees
* All employees, with limits (fields, rows)
* Ordered by Hire Date
* Conditionals - more than five years since hire
* 



### On Case

Probs should say something about select vs SELECT







# Where to Go From Here?

Next steps for the SQL student and a list of resources.

## Cheating: DB Browser for SQLite

It's best to learn how to do things from the terminal emulator, as _every system
you're likely to use will have a terminal or console_. However, if you've become
accustomed to clicking on things, or if you're not comfortable of the command line, you
may want a more visual tool. If so, check out [DB Browser for
SQLite](https://sqlitebrowser.org/).
