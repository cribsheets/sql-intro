#!/usr/bin/env ruby

require 'sqlite3'
require 'csv'

create_sql = <<-SQL
  CREATE TABLE employees (
    name TEXT, first_name TEXT, last_name TEXT, empno TEXT, state TEXT,
    zip TEXT, dob DATE, age INTEGER, sex TEXT, marital_status TEXT,
    citizenship TEXT, hire_date DATE, termination_date DATE, term_reason TEXT, status TEXT,
    department TEXT, position TEXT, hourly_rate FLOAT, manager TEXT, source TEXT,
    performance_score TEXT
  );
SQL

field_names = %i[
    name empno state zip dob
    age sex marital_status citizenship hisp
    race hire_date termination_date term_reason status
    department position hourly_rate manager source
    performance_score
]

insert_sql = <<-SQL
  insert into employees values (
    "%{name}", "%{first_name}", "%{last_name}", %{empno}, '%{state}',
    '%{zip}', date('%{dob}'), %{age}, '%{sex}', '%{marital_status}',
    '%{citizenship}', date('%{hire_date}'), date('%{termination_date}'), '%{term_reason}', '%{status}',
    '%{department}', '%{position}', %{hourly_rate}, '%{manager}', '%{source}',
    '%{performance_score}'
  );
SQL

# turn the date into something sql can
# deal with
def sqlify_date(raw_date)
    m, d, y = raw_date.split('/')
    "%04d-%02d-%02d" % [y, m, d]
end

# files
csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'employees.csv')
db_file  = File.join(File.dirname(__FILE__), '..', 'employees.db')

# read in the csv data, and clean
employees = CSV.read(csv_file).map { |r| Hash[field_names.zip(r)] }
employees.each do |e|
  begin
    lname, fname = e[:name].split(/\s*,\s*/).map(&:strip)
    e[:first_name] = fname
    e[:last_name] = lname
    e.each { |k,v| e[k] = v.strip if v }
    e[:name] = "#{fname} #{lname}"

    # convert date to something sane
    e[:dob] = sqlify_date(e[:dob])
    e[:hire_date] = sqlify_date(e[:hire_date])
    if e[:termination_date].downcase != "null"
      e[:termination_date] = sqlify_date(e[:termination_date])
    end
  rescue => ex
    require 'pp'
    pp e
    pp ex
  end
end



print("creating new employees.db...")
db = SQLite3::Database.new(db_file)
db.execute('drop table employees;')
db.execute(create_sql)
employees.each { |e| db.execute(insert_sql % e) }
puts("done")

