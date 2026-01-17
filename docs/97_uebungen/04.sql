-- 1. Window Functions (Ranking)
SELECT 
    dept_no, 
    emp_no, 
    salary,
    RANK() OVER (PARTITION BY dept_no ORDER BY salary DESC) as salary_rank
FROM dept_emp
JOIN salaries USING (emp_no)
WHERE to_date > NOW();

-- 2. Window Functions (Lag)
SELECT 
    emp_no,
    salary,
    from_date,
    LAG(salary) OVER (ORDER BY from_date) as prev_salary,
    salary - LAG(salary) OVER (ORDER BY from_date) as diff
FROM salaries
WHERE emp_no = 10001;

-- 3. JSON Basics
CREATE TEMPORARY TABLE user_configs (
    id INT PRIMARY KEY,
    config JSON
);

INSERT INTO user_configs VALUES 
(1, '{"theme": "dark", "notifications": {"email": true, "sms": false}}'),
(2, '{"theme": "light", "notifications": {"email": false, "sms": true}}');

-- 3.1 Find dark theme users
SELECT * FROM user_configs 
WHERE JSON_EXTRACT(config, '$.theme') = 'dark';
-- Oder kurz: config->>'$.theme' = 'dark'

-- 3.2 Find SMS users
SELECT * FROM user_configs
WHERE JSON_EXTRACT(config, '$.notifications.sms') = true;

-- 3.3 Update Theme
UPDATE user_configs
SET config = JSON_SET(config, '$.theme', 'light')
WHERE id = 1;

-- 4. Stored Function get_years_employed
DELIMITER //
CREATE FUNCTION get_years_employed(p_emp_no INT) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_hire_date DATE;
    DECLARE v_years INT;
    
    SELECT hire_date INTO v_hire_date FROM employees WHERE emp_no = p_emp_no;
    
    SET v_years = TIMESTAMPDIFF(YEAR, v_hire_date, NOW());
    RETURN v_years;
END //
DELIMITER ;

-- Test
SELECT get_years_employed(10001);

-- BONUS 1: JSON_TABLE
SELECT *
FROM user_configs,
     JSON_TABLE(config, '$' COLUMNS (
         theme VARCHAR(20) PATH '$.theme',
         email_notif BOOL PATH '$.notifications.email'
     )) AS jt;

-- BONUS 2: NTILE
SELECT emp_no, salary, NTILE(4) OVER (ORDER BY salary DESC) as quartile
FROM salaries WHERE to_date > NOW();

-- BONUS 3: Datums-Rechnung
SELECT emp_no, DATEDIFF(NOW(), birth_date) as age_in_days FROM employees LIMIT 10;

-- BONUS 4: JSON_MERGE
SELECT JSON_MERGE_PATCH('{"a": 1, "b": 2}', '{"b": 3, "c": 4}'); -- Result: {"a": 1, "b": 3, "c": 4}

-- BONUS 5: JSON Validation
SELECT JSON_VALID('{"valid": true}'), JSON_VALID('{invalid}');

-- BONUS 6: JSON Search
SELECT JSON_SEARCH(config, 'one', 'dark') FROM user_configs;

-- BONUS 7: Regular Expressions
SELECT * FROM employees WHERE last_name REGEXP '^[AEIOU].*[AEIOU]$' LIMIT 10;

-- BONUS 8: Coalesce
SELECT COALESCE(NULL, NULL, 'First Value', 'Second Value');

-- BONUS 9: Cast & Convert
SELECT CAST('123.45' AS DECIMAL(10,2)) * 2;

-- BONUS 10: Random Samples
SELECT * FROM employees ORDER BY RAND() LIMIT 5;
