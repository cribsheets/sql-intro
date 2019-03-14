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
into the database, and delete data.

SQL has two fundamental structures: a single row of data or  _record_, and a list of
records or _table_. Most interactions with SQL will return results in a table
format.

## Getting Started

To keep the overhead for these exercises as small as possible, we'll be using
SQLite as our database engine. SQLite is a small, fast and relational SQL
database (db) engine. It's great for prototyping, embedded applications, and
doesn't require additional services to run on your machine to use.

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




## Cheating: DB Browser for SQLite

It's best to learn how to do things from the terminal emulator, as _every system
you're likely to use will have a terminal or console_. However, if you've become
accustomed to clicking on things, or if you're not comfortable of the command line, you
may want a more visual tool. If so, check out [DB Browser for
SQLite](https://sqlitebrowser.org/).
