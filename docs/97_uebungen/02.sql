-- 1. View v_current_employees
CREATE OR REPLACE VIEW v_current_employees AS
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    s.salary AS current_salary,
    d.dept_name AS current_dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no AND de.to_date > NOW()
JOIN salaries s ON e.emp_no = s.emp_no AND s.to_date > NOW()
JOIN departments d ON d.dept_no = de.dept_no;

-- Beispielabfrage
SELECT * FROM v_current_employees WHERE last_name = 'Facello';


-- 2. Virtual Column full_name (Stored)
ALTER TABLE employees
ADD COLUMN full_name VARCHAR(100) 
       GENERATED ALWAYS AS (CONCAT(first_name, ' ', last_name)) STORED;

-- Optionaler Index für Suche
CREATE INDEX idx_full_name ON employees(full_name);


-- 3. Reporting View: v_dept_stats
CREATE OR REPLACE VIEW v_dept_stats AS
SELECT 
    d.dept_name,
    COUNT(de.emp_no) AS employee_count,
    AVG(s.salary) AS avg_salary,
    SUM(s.salary) AS total_salary
FROM departments d
JOIN dept_emp de ON de.dept_no = d.dept_no AND de.to_date > NOW()
JOIN salaries s ON s.emp_no = de.emp_no AND s.to_date > NOW()
GROUP BY d.dept_name;

-- Hinweis: Jede Abfrage auf v_dept_stats berechnet alle Aggregationen neu.


-- BONUS: WITH CHECK OPTION (Sales-only View)
CREATE OR REPLACE VIEW v_sales_employees AS
SELECT *
FROM v_current_employees
WHERE current_dept_name = 'Sales'
WITH CHECK OPTION;

-- Versuch: Insert in Marketing -> schlägt fehl
-- INSERT INTO v_sales_employees (...) VALUES (... 'Marketing');


-- BONUS: Updatable View Test
-- Versuch: UPDATE v_current_employees SET current_salary = 99999 WHERE emp_no = 10001;
-- Ergebnis: MySQL erlaubt kein Update, da die View mehrere Tabellen referenziert.


-- BONUS: Index auf Virtual Column (bereits oben erstellt)
EXPLAIN SELECT * FROM employees WHERE full_name = 'John Smith';


-- BONUS: Security Definer View
CREATE OR REPLACE VIEW v_secure_data
SQL SECURITY DEFINER
AS
SELECT * FROM sensitive_table;

-- User ohne Rechte kann jetzt:
-- SELECT * FROM v_secure_data;


-- BONUS: View auf View
CREATE OR REPLACE VIEW v_managers AS
SELECT *
FROM dept_manager;

CREATE OR REPLACE VIEW v_current_managers AS
SELECT *
FROM v_managers
WHERE to_date > NOW();


-- BONUS: Algorithm TEMPTABLE
CREATE ALGORITHM=TEMPTABLE VIEW v_temp_example AS
SELECT dept_no, COUNT(*) AS cnt
FROM dept_emp
GROUP BY dept_no;


-- BONUS: Generated Column hire_year
ALTER TABLE employees
ADD COLUMN hire_year INT 
       GENERATED ALWAYS AS (YEAR(hire_date)) STORED;

CREATE INDEX idx_hire_year ON employees(hire_year);


-- BONUS: CASCADED CHECK OPTION
CREATE OR REPLACE VIEW v_high_salary AS
SELECT * FROM employees WHERE hire_year >= 2000
WITH CASCADED CHECK OPTION;

CREATE OR REPLACE VIEW v_high_salary_males AS
SELECT * FROM v_high_salary WHERE gender = 'M'
WITH CASCADED CHECK OPTION;

-- Insert mit falschem hire_year oder gender wird verhindert.


-- BONUS: JSON Virtual Column + Index
ALTER TABLE json_test
ADD COLUMN city VARCHAR(50)
       GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(json_data, '$.address.city'))) STORED;

CREATE INDEX idx_city ON json_test(city);


-- BONUS: Materialized View Workaround
CREATE TABLE mv_dept_stats AS
SELECT d.dept_no, d.dept_name,
       COUNT(de.emp_no) AS employee_count,
       AVG(s.salary) AS avg_salary,
       SUM(s.salary) AS total_salary
FROM departments d
JOIN dept_emp de ON de.dept_no = d.dept_no
JOIN salaries s ON s.emp_no = de.emp_no
GROUP BY d.dept_no, d.dept_name;

-- Automatisches Refresh-Event alle 5 Minuten
CREATE EVENT refresh_mv_dept_stats
ON SCHEDULE EVERY 5 MINUTE
DO
    REPLACE INTO mv_dept_stats
    SELECT d.dept_no, d.dept_name,
           COUNT(de.emp_no),
           AVG(s.salary),
           SUM(s.salary)
    FROM departments d
    JOIN dept_emp de ON de.dept_no = d.dept_no
    JOIN salaries s ON s.emp_no = de.emp_no
    GROUP BY d.dept_no, d.dept_name;
