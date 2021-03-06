--create database view_lab1
use view_lab1
set dateformat dmy;


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
go

go
create view v_1 as
 select emp_no, emp_fname, emp_lname, dept_no
  from employee
   where dept_no = 'd1'
go
select * from v_1
select * from employee where dept_no = 'd1';
go
/* 1. Tạo view chứa thông tin của tất cả nhân viên làm việc cho phòng d1 */
go
create view Information_d1 as
 select *
  from employee_enh
   where dept_no = 'd1'
   
/* 2. Tạo view gồm tất cả thông tin của bảng project, ngoại trừ cột budget */
go 
 create view Infor_project as
  select project_no, project_name
   from project
go   
select * from project;   

go
create view v_2 as
 select project_no, project_name
  from project 
go
select project_no, project_name
 from project;
select * from v_2;
go
/* 3. Tạo view bao gồm họ và tên của tất cả nhân viên đã gia nhập dự án vào nửa cuối năm 2007 */
go 
select * from employee;
select * from works_on;
select * from employee e join works_on w on e.emp_no = w.emp_no;

select * from employee e left join works_on w on e.emp_no = w.emp_no;
go
create view v_3 as
	select emp_fname, emp_lname 
		from employee e right join works_on w on e.emp_no = w.emp_no
			where w.enter_date between '1/6/2007' and '30/12/2007'
go
 select * from employee e left join works_on w on e.emp_no = w.emp_no
 where w.enter_date between '1/6/2007' and '30/12/2007';
select * from v_3
go


 create view Infor_halfLast_2007 as
  select e.emp_fname, e.emp_lname
   from employee e join works_on w on e.emp_no = w.emp_no
    where w.enter_date between '1/6/2007' and '31/12/2007'
 select * from Infor_halfLast_2007
/* 4. Giải lại câu 3, đặt lại tên cho cột emp_fname, emp_lname là first và last */
go
create view v_4 as
	select emp_fname as first, emp_lname as last
		from employee e right join works_on w on e.emp_no = w.emp_no
			where w.enter_date between '1/6/2007' and '31/12/2007'
			
go
alter view v_3 as
	select emp_fname as first, emp_lname as last
		from employee e right join works_on w on e.emp_no = w.emp_no
			where w.enter_date between '1/6/2007' and '31/12/2007'
go
select * from v_4

go 
 create view Infor_halfLast_2007_2 (first, last) as
  select e.emp_fname, e.emp_lname
   from employee e join works_on w on e.emp_no = w.emp_no
    where w.enter_date between '1/6/2007' and '31/12/2007'

/* 5. Sử dụng view trong câu 1, hiển thị đầy đủ thông tin của nhân viên có tên bắt đầu với chữ M */
go

go
create view v_5 as
	select emp_no, emp_fname, emp_lname, dept_no from employee
		where emp_fname like 'e%'
go
select * from employee where emp_fname like 'e%'
select * from v_5 

go
create view Information_d1_2 as
 select *
  from employee_enh
   where dept_no = 'd1' and emp_lname like 'M%'
   
/* 6. Tạo view bao gồm thông tin của tất cả các dự án mà nhân viên có tên Smith làm việc. */
go

CREATE VIEW v_6 as
	SELECT
		emp_no, emp_fname, emp_lname, dept_no
	FROM 
		employee
	WHERE 
		emp_lname LIKE 'Smith';
go
SELECT 
	*
FROM 
	employee
WHERE 
	emp_lname LIKE 'Smith';
go
SELECT 
	* 
FROM
	v_6
go
 create view Infor_project_smith as
  select p.project_no, p.project_name, p.budget
   from employee e join works_on w on e.emp_no = w.emp_no
				   join project p on w.project_no = p.project_no
	where e.emp_lname = 'smith'
	
/* 7. Sử dụng câu lệnh ALTER VIEW, chỉnh sửa điều kiện trong view bài 1 bao gồm dữ liệu của tất cả các nhân viên làm việc cho phòng d1 hoặc d2. */goALTER VIEW v_1 as	SELECT 		emp_no, emp_fname, emp_lname, dept_no	FROM		employee	WHERE 		dept_no = 'd2'goSELECT * FROM v_1goalter view Information_d1 as select *   from employee_enh   where dept_no = 'd1' or dept_no = 'd2'/* 8. Xóa view được tạo ra trong câu 3. Điều gì xảy ra với view được tạo ra trong câu 4? */goSELECT * FROM v_3;SELECT * FROM v_4;DROP VIEW v_3 drop view Infor_halfLast_2007 /* 9. Sử dụng view câu 2, chèn thêm chi tiết của dự án mới với mã dự án p2 và tên Moon */go  insert infor_project  values('p2', 'Moon')/* 10. Tạo view (với mệnh đề WITH CHECK OPTION) bao gồm họ và tên của tất cả nhân viên có số nhân viên dưới 10.000. Sau đó, sử dụng view để chèn dữ liệu cho một nhân viên mới có tên Kohn với số nhân viên 22123, làm việc cho phòng d3. */go create view v_empNo_smaller_10000 as  select *   from employee    where emp_no < 10000     with check optiongo insert v_empNo_smaller_10000   values(22123,'Join', 'Kohn', 'd3')/* The attempted insert or update failed because the target view either specifies WITH CHECK OPTION or spans a view that specifies WITH CHECK OPTION and one or more rows resulting from the operation did not qualify under the CHECK OPTION constraint. *//* 11. Giải quyết câu 10 mà không có mệnh đề WITH CHECK OPTION và tìm sự khác biệt liên quan đến việc chèn dữ liệu */go create view v_empNo_smaller_10000_2 as  select *   from employee    where emp_no < 10000go insert v_empNo_smaller_10000_2   values(22123,'Join', 'Kohn', 'd3')  /* 12. Tạo view (với mệnh đề WITH CHECK OPTION) với đầy đủ thông tin từ bảng works_on cho tất cả nhân viên tham gia dự án của họ trong những năm 2007 và 2008. Sau đó, sửa đổi ngày gia nhập của nhân viên có mã số 29346 thành ngày mới là 06/01/2006.*/go  create view v_date_2007_2008 as  select *   from works_on    where Year(Enter_date) = '2007' and Year(Enter_date) = '2008'     with check optiongo update  v_date_2007_2008  set Enter_date = '06/01/2006'   where emp_no = '29346'   /* Giải quyết câu 12 mà không có mệnh đề WITH CHECK OPTION và tìm ra sự khác biệt liên quan đến việc sửa đổi dữ liệu. */go  create view v_date_2007_2008_2 as  select *   from works_on    where Year(Enter_date) = '2007' and Year(Enter_date) = '2008'go update  v_date_2007_2008  set Enter_date = '06/01/2006'   where emp_no = '29346'    