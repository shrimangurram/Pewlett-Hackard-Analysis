# Pewlett-Hackard Challenge Project Overview
HR Director would like to get a list of employees who would be good candidates for a supervisory role. Ideally, these candidates would be born in 1965.

## ERD Diagram
---
Link to the ERD Diagram for the Pewlett Hackard data:
[Pewlett Hackard ERD](https://github.com/shrimangurram/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png)
-- Data can be orgainized into 6 tables: departments, employees, dept_managers, dept_emp, titles, and salaries

### Find all employees who are eligible for retirement
-- Query to find the employees who are elgible for retirements:
```
   SELECT e.emp_no,e.first_name,e.last_name,
       ti.title, ti.from_date,
	   s.salary
   INTO emp_title_salary_retirees
   FROM employees AS e
   INNER JOIN titles AS ti
   ON (e.emp_no = ti.emp_no)
   INNER JOIN salaries AS s
   ON (e.emp_no = s.emp_no)
   WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
   AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
   ORDER BY e.emp_no ASC;
```
-- Query return emp no, first name, last name, title, salary information from employees, titles, and salaries table for all employees whose birth date is between 1952 and 1955 and hire date is between 1985 and 1988
-- The above query returns the following data:
[Employees eligible for retirement](https://github.com/shrimangurram/Pewlett-Hackard-Analysis/blob/master/Data/emp_title_salary_retirees.csv)
-- Analysis of the data returned shows the following:
   - The query return 65427 records with duplicates
   - Titles held by employees that are eligible for retirements include: Assistant Engineer, Engineer, Manager, Senior Engineer, Senior Staff, Staff, and Technique Leader
   - Salaries range between $40k to $120k

### Find count of titles of employees who are eligible for retirement
-- Query to find the count of titles of employees who are eligible for retirement:
```
   SELECT stemp.title, COUNT(stemp.title)
   INTO emp_title_retirees_count_bytitle
   FROM
   (SELECT emp_no,first_name,last_name, 
          title,from_date,salary 
    FROM
    (SELECT emp_no,first_name,last_name, 
     title,from_date,salary,
       ROW_NUMBER() OVER 
       (PARTITION BY (emp_no) ORDER BY from_date DESC) rn
     FROM emp_title_salary_retirees
     ) tmp WHERE rn = 1) AS stemp
     GROUP BY stemp.title;
```
-- Query returns count of titles of all employees who are eligible for retirement
-- The above query returns the following data:
[Title count of all employees who are eligible for retirement](https://github.com/shrimangurram/Pewlett-Hackard-Analysis/blob/master/Data/emp_title_retirees_count_bytitle.csv)
-- Analysis of the data returned shows the following:
   - There are 501 Assistant Engineers eligible for retirement
   - There are 4692 Engineers eligible for retirement
   - There are 2 Managers eligible for retirement
   - There are 15600 Senior Engineers eligible for retirement
   - There are 14735 Senior Staff elgibile for retirement
   - There are 3837 Staff eligible for retirement
   - There are 2013 Technique leader's eligible for retirement
   - The proportion of Senior Engineers and Senior Staff retiring is higher than the rest of the roles
 
### Employees eligible for being a mentor
-- Query to find employees eligible for being a mentor:
```
    SELECT e.emp_no,e.first_name,e.last_name,
          ti.title, ti.from_date, ti.to_date
    INTO emp_titles_subset
    FROM employees AS e
    INNER JOIN titles AS ti
    ON (e.emp_no = ti.emp_no)
    WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND ti.to_date = '9999-01-01'
    ORDER BY e.emp_no ASC;
```
-- Query returns list of mentors whose birth date is between Jan 1, 1965 and Dec 31, 1965
-- The above query returns the following data:
[List of mentors](https://github.com/shrimangurram/Pewlett-Hackard-Analysis/blob/master/Data/emp_titles_subset.csv)
-- Analysis of the data returned shows the following:
  - There are 1549 current employees who can be potential mentors
  - Titles held by employees that can be mentors include: Assistant Engineer, Engineer, Senior Engineer, Senior Staff, Staff, and Technique Leader
  - Hire dates range from 1985 to 2002
