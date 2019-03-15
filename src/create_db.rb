require 'sqlite3'
require 'csv'

create_sql = <<-SQL
  CREATE TABLE employees (
    name TEXT,
    first_name TEXT,
    last_name TEXT,
    empno TEXT,
    state TEXT,
    zip TEXT,
    dob DATE,
    age INTEGER,
    sex TEXT,
    marital_status TEXT,
    citizenship TEXT,
    hire_date DATE,
    termination_date DATE,
    term_reason TEXT,
    status TEXT,
    department TEXT,
    position TEXT,
    hourly_rate FLOAT,
    manager TEXT,
    source TEXT,
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

csv_file = File.join(File.dirname(__FILE__), '..', 'data', 'employees.csv')
db_file  = File.join(File.dirname(__FILE__), '..', 'employees.db')
employees = CSV.read(csv_file).map { |r| Hash[field_names.zip(r)] }
employees.each do |e|
  lname, fname = e[:name].split(', ')
  e[:first_name] = fname
  e[:last_name] = lname
  e.each do |k,v|
    e[k] = v.strip if v
  end
end

db = SQLite3::Database.new(db_file)
db.execute('drop table employees;')
db.execute(create_sql)

insert_sql = <<-SQL
  insert into employees values (
    "%{name}",
    "%{first_name}",
    "%{last_name}",
     %{empno},
    '%{state}',
    '%{zip}',
     %{dob},
     %{age},
    '%{sex}',
    '%{marital_status}',
    '%{citizenship}',
     %{hire_date},
     %{termination_date},
    '%{term_reason}',
    '%{status}',
    '%{department}',
    '%{position}',
     %{hourly_rate},
    '%{manager}',
    '%{source}',
    '%{performance_score}'
  );
SQL

employees.each do |e|
  emp_row = insert_sql % e

  pp emp_row
  db.execute(emp_row)
end








