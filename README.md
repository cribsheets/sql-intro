# Cribsheets: Intro to SQL

At some point, you'll be working with data stored in a relational format.
Likely, this data will be accessed via SQL (Structured Query Language). _You_
may not be accessing it, as there are plenty of Object Relational Mapping (ORM)
libraries to facilitate this access in whatever language, but it is incredibly
useful to understand what's going on under the surface.

To that effect, we present this short introduction to SQL, a small data set, and
a framework to practice some basic skills.

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

## Getting Around

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
