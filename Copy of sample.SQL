-- Create first the database, please (using CREATE DATABASE statement) 

CREATE TABLE employee  (emp_no INTEGER NOT NULL, 
                        emp_fname CHAR(20) NOT NULL,
                        emp_lname CHAR(20) NOT NULL,
                        dept_no CHAR(4) NULL)
CREATE TABLE department(dept_no CHAR(4) NOT NULL,
                        dept_name CHAR(25) NOT NULL,
                        location CHAR(30) NULL)
CREATE TABLE project   (project_no CHAR(4) NOT NULL,
                        project_name CHAR(15) NOT NULL,
                        budget FLOAT NULL)
CREATE TABLE works_on	(emp_no INTEGER NOT NULL,
                        project_no CHAR(4) NOT NULL,
                        job CHAR (15) NULL,
                        enter_date DATEtime NULL)
insert into employee values(25348, 'Matthew', 'Smith','d3')
insert into employee values(10102, 'Ann', 'Jones','d3')
insert into employee values(18316, 'John', 'Barrimore', 'd1')
insert into employee values(29346, 'James', 'James', 'd2')
insert into employee values(9031, 'Elsa', 'Bertoni', 'd2')
insert into employee values(2581, 'Elke', 'Hansel', 'd2')
insert into employee values(28559, 'Sybill', 'Moser', 'd1')
insert into department values ('d1', 'research','Dallas')
insert into department values ('d2', 'accounting', 'Seattle')
insert into department values ('d3', 'marketing', 'Dallas')
insert into project values ('p1', 'Apollo', 120000.00)
insert into project values ('p2', 'Gemini', 95000.00)
insert into project values ('p3', 'Mercury', 186500.00)
insert into works_on values (10102,'p1', 'analyst', '2006.10.1')
insert into works_on values (10102, 'p3', 'manager', '2008.1.1')
insert into works_on values (25348, 'p2', 'clerk', '2007.2.15')
insert into works_on values (18316, 'p2', NULL, '2007.6.1')
insert into works_on values (29346, 'p2', NULL, '2006.12.15')
insert into works_on values (2581, 'p3', 'analyst', '2007.10.15')
insert into works_on values (9031, 'p1', 'manager', '2007.4.15')
insert into works_on values (28559, 'p1', NULL, '2007.8.1')
insert into works_on values (28559, 'p2', 'clerk', '2008.2.1')
insert into works_on values (9031, 'p3', 'clerk', '2006.11.15')  
insert into works_on values (29346, 'p1','clerk', '2007.1.4')

SELECT  emp_no, emp_fname, emp_lname, dept_no 
   INTO employee_enh 
   FROM employee; 
ALTER TABLE employee_enh 
          ADD domicile CHAR(25) NULL;


           UPDATE employee_enh SET domicile = 'San Antonio' 
              WHERE emp_no = 25348; 
UPDATE employee_enh SET domicile = 'Houston' 
               WHERE emp_no = 10102; 
UPDATE employee_enh SET domicile = 'San Antonio' 
              WHERE emp_no = 18316; 
UPDATE employee_enh SET domicile = 'Seattle' 
              WHERE emp_no = 29346; 
           UPDATE employee_enh SET domicile = 'Portland' 
              WHERE emp_no = 9031; 
           UPDATE employee_enh SET domicile = 'Tacoma' 
              WHERE emp_no = 2581; 
           UPDATE employee_enh SET domicile = 'Houston' 
               WHERE emp_no = 28559;
