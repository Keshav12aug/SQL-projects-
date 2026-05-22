-- USE githubproj;
-- SELECT * FROM employees;
-- SELECT * FROM departments;
-- SELECT * FROM salaries;
-- SELECT * FROM performance;

#AVERAGE SALARY PER DEPARTMENT

SELECT d.department_name, AVG(s.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY d.department_name;

#HIGHEST PAID EMPLOYEE

SELECT e.name, s.salary
FROM employees e
JOIN salaries s 
ON e.emp_id = s.emp_id
ORDER BY s.salary DESC
LIMIT 1;

#EMPLOYEES WITH ABOVE AVERAGE SALARY

SELECT *
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.salary > (
  SELECT AVG(salary) FROM salaries
);

#MOST CONSISTENT PERFORMER

SELECT e.name, AVG(p.rating) AS avg_rating
FROM employees e
JOIN performance p ON e.emp_id = p.emp_id
GROUP BY e.name
ORDER BY avg_rating DESC
LIMIT 1;

#EMPLOYEES WITHOUT REVIEWS

SELECT e.*
FROM employees e
LEFT JOIN performance p ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;

#adding up an index and creating the view

CREATE INDEX idx_salary ON salaries(emp_id);


CREATE VIEW high_salary_employees AS
SELECT e.name, s.salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.salary > 50000;


SELECT * FROM high_salary_employees;


#stored-producedure

DELIMITER //

CREATE PROCEDURE get_employee_by_dept(IN dept_name VARCHAR(50))
BEGIN
  SELECT e.name
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  WHERE d.department_name = dept_name;
END //

DELIMITER ;


CALL get_employee_by_dept('IT');


#TOP THREE EMPLOYEES PER DEPT

SELECT *
FROM (
  SELECT e.name, d.department_name, s.salary,
         ROW_NUMBER() OVER (
           PARTITION BY d.department_name 
           ORDER BY s.salary DESC
         ) AS rn
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN salaries s ON e.emp_id = s.emp_id
) t
WHERE rn <= 3
ORDER BY salary AND rn DESC;


