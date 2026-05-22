-- Employee Management & Analytics System
-- This code of SQL queries simulates a real-world employee database used by companies to manage employees, departments, salaries, and performance.
USE githubproj;

CREATE TABLE employees (
  emp_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  age INT,
  gender VARCHAR(10),
  department_id INT,
  hire_date DATE
);

CREATE TABLE departments (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  department_name VARCHAR(100)
);

CREATE TABLE salaries (
  salary_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  salary DECIMAL(10,2),
  bonus DECIMAL(10,2),
  effective_date DATE,
  FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


CREATE TABLE performance (
  review_id INT PRIMARY KEY AUTO_INCREMENT,
  emp_id INT,
  rating INT,
  review_date DATE,
  FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);





