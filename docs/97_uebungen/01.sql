-- 1. Alle aktuellen Mitarbeiter in "Sales"
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE d.dept_name = 'Sales'
  AND de.to_date > NOW();

-- 2. Manager-Historie (nur frühere Manager, sonst Filter entfernen)
SELECT e.first_name, e.last_name, dm.from_date, dm.to_date
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
JOIN departments d ON d.dept_no = dm.dept_no
WHERE d.dept_name = 'Development'
  AND dm.to_date < NOW()
ORDER BY dm.from_date ASC;

-- 3. Durchschnittsgehalt pro Abteilung (nur aktuelle Daten)
SELECT d.dept_name,
       ROUND(AVG(s.salary), 2) AS avg_salary
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE s.to_date > NOW()
  AND de.to_date > NOW()
GROUP BY d.dept_name;

-- 4. Mitarbeiter ohne Titel (Left Join)
SELECT e.emp_no, e.first_name, e.last_name
FROM employees e
LEFT JOIN titles t ON e.emp_no = t.emp_no
WHERE t.emp_no IS NULL;

-- 5. Manager UND Senior Engineers (Big Union)
SELECT e.first_name, e.last_name, 'Manager' AS role
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no

UNION ALL

SELECT e.first_name, e.last_name, 'Senior Dev' AS role
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
WHERE t.title = 'Senior Engineer';

-- BONUS 1: Self Join – gleiche Nachnamen
SELECT a.emp_no AS emp1, b.emp_no AS emp2, a.last_name
FROM employees a
JOIN employees b ON a.last_name = b.last_name AND a.emp_no < b.emp_no
LIMIT 10;

-- BONUS 2: Cross Join – Kombinationen Abteilungen x Titel
SELECT d.dept_name, t.title
FROM departments d
CROSS JOIN titles t;

-- BONUS 3: Abteilungen mit > 50000 dept_emp Einträgen (Subquery in FROM)
SELECT d.dept_name, x.cnt
FROM (
    SELECT dept_no, COUNT(*) AS cnt
    FROM dept_emp
    GROUP BY dept_no
) x
JOIN departments d ON d.dept_no = x.dept_no
WHERE x.cnt > 50000;

-- BONUS 4: Manager die auch Engineers waren (IN)
SELECT dm.emp_no
FROM dept_manager dm
WHERE dm.emp_no IN (
    SELECT emp_no FROM titles WHERE title LIKE '%Engineer%'
);

-- BONUS 4b: Manager die auch Engineers waren (EXISTS)
SELECT dm.emp_no
FROM dept_manager dm
WHERE EXISTS (
    SELECT 1 FROM titles t
    WHERE t.emp_no = dm.emp_no
      AND t.title LIKE '%Engineer%'
);

-- BONUS 5: Rekursive CTE 1 bis 10
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 10
)
SELECT * FROM nums;

-- BONUS 6: NATURAL JOIN Demo (Employees x dept_emp)
SELECT *
FROM employees
NATURAL JOIN dept_emp;

-- BONUS 7: Gaps in einer fortlaufenden ID Liste
SELECT a.id + 1 AS missing_id
FROM numbers a
LEFT JOIN numbers b ON b.id = a.id + 1
WHERE b.id IS NULL;

-- BONUS 8: Abteilungen ohne Manager (Anti Join)
SELECT d.dept_no, d.dept_name
FROM departments d
LEFT JOIN dept_manager dm ON d.dept_no = dm.dept_no
WHERE dm.emp_no IS NULL;

-- BONUS 9: Durchschnittsgehalt pro Abteilung, nur > 60000
SELECT d.dept_name,
       AVG(s.salary) AS avg_salary
FROM salaries s
JOIN dept_emp de ON s.emp_no = de.emp_no
JOIN departments d ON d.dept_no = de.dept_no
WHERE s.salary > 60000
  AND s.to_date > NOW()
  AND de.to_date > NOW()
GROUP BY d.dept_name;

-- BONUS 10: Grouping nach Einstellungsjahr und Geschlecht
SELECT YEAR(e.hire_date) AS hire_year,
       e.gender,
       COUNT(*) AS cnt
FROM employees e
GROUP BY YEAR(e.hire_date), e.gender
ORDER BY hire_year, e.gender;
